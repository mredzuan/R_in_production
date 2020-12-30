

library(shiny)
library(caret)
library(e1071)
library(waiter)

#Load data & model
data_iris <- iris
classifier_SVM <- readRDS("Iris_Model/Iris_SVM_model.RDS")


ui <- fluidPage(
  
  use_waiter(), 
  waiter_show_on_load(html = spin_fading_circles()),

    # Application title
    titlePanel("Iris Type Predictor"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("SepalLength",
                        "Sepal Length:",
                        min = 0,
                        max = max(data_iris$Sepal.Length) + 1,
                        value = 6.3),
            
            sliderInput("SepalWidth",
                        "Sepal Width:",
                        min = 0,
                        max = max(data_iris$Sepal.Width) + 1,
                        value = 3.4),
            
            sliderInput("PetalLength",
                        "Petal Length:",
                        min = 0,
                        max = max(data_iris$Petal.Length) + 1,
                        value = 5.6),
            
            sliderInput("PetalWidth",
                        "Petal Width:",
                        min = 0,
                        max = max(data_iris$Petal.Width) + 1,
                        value = 2.4),
            
            tags$br(),
            
            actionButton("runPredict",
                         "Predict!"),
            
            
            actionButton("show_help", "Help")
                
            
           
        ),

        # Show a plot of the generated distribution
        mainPanel(
          
          tags$h2(textOutput("predict_res")),
          
          imageOutput("iris_img"), 
          tags$br(),
          tags$br(),
          tags$br(),
          tags$br(),
          tags$br(),
          tags$br(),
            
          plotOutput("distPlot")
        )
    )
)






# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  waiter_hide()
  
  w <- Waiter$new(id = "distPlot",
                  html = spin_google(), 
                  color = transparent(.5))
  
  w_image <- Waiter$new(id = "iris_img",
                        html = spin_google(),
                        color = transparent(.5))
  
  
  #Provide help text
  
  observeEvent(input$show_help,{
    showModal(modalDialog(
      title = "Help",
      "This is an Iris type predictor Application. To run, select required values using slider and press Predict button",
      easyClose = TRUE,
      footer = NULL
    ))
  })
    
  
       new_sample <- eventReactive(
         input$runPredict,{
         
        
        df <- data.frame(Sepal.Length = input$SepalLength, 
                         Sepal.Width = input$SepalWidth, 
                         Petal.Length = input$PetalLength, 
                         Petal.Width = input$PetalWidth)
    
        return(df)
        
       
        })
    
    
 
    
    predict_newSample <- reactive({
        
        res <- predict(classifier_SVM, newdata = new_sample())
        
        return(res)
        
    })
    
    
    output$predict_res <- renderText({
      
      paste0("Predicted Iris Type is ", toupper(predict_newSample()), "!")
      
    })
    
  
    dataset_update <- reactive({
      
      w$show()
      
      # on.exit({
      #   w$hide()
      # })
      
      w_image$show()
      
      Sys.sleep(0.4)   
        
        newDf <- rbind(data_iris, cbind(new_sample(), Species = paste(predict_newSample(), " (Predicted)", sep = "")))
        return(newDf)
    })
    
    
  
    
    observe({
        print(list(new_sample(), 
                   predict_newSample(),
                   str(dataset_update())))
    })
    
    
    
  
    output$iris_img <- renderImage({
      
      
      if(predict_newSample() == "versicolor"){
         return(list(
            src = "img/Versicolor.PNG",
            width = 445,
            height = 518,
            contentType = "image/png",
            alt = "Versicolor"
        ))
        
        
      }
      else if(predict_newSample() == "setosa"){
        return(list(
          src = "img/Setosa.PNG",
          contentType = "image/png",
          alt = "Setosa"
        ))
      } 
      else if(predict_newSample() == "virginica"){ 
        return(list(
          src = "img/Virginica.PNG",
          contentType = "image/png",
          alt = "Virginica"
        ))
      }
      
        
       
        
    }, 
    deleteFile = FALSE)

    output$distPlot <- renderPlot({
        
        
        pairs(dataset_update()[,1:4],col=dataset_update()[,5],oma=c(4,4,6,12))
        par(xpd=TRUE)
        legend(0.90,0.6, as.vector(unique(dataset_update()$Species)),fill=c(1,2,3,4))
        
        
     
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
