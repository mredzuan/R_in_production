#
# This is a Plumber API exercises
#

library(plumber)


#* @apiTitle Plumber Example Exercise

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers
#* @param a enter 1st number
#* @param b enter 2nd number
#* @post /sum
add_number <- function(a, b){
  as.numeric(a) + as.numeric(b)
}


#* Predict Iris Type

library(jsonlite)
library(caret)
library(e1071)

classifier_svm <- readRDS("model/Iris_SVM_model.RDS")


#* @post /Predict
#* Predict Iris Type

predict_iris <- function(sepal_length, sepal_width, petal_length, petal_width){
  

  newSample <- data.frame(Sepal.Length = as.numeric(sepal_length),
                          Sepal.Width = as.numeric(sepal_width), 
                          Petal.Length = as.numeric(petal_length), 
                          Petal.Width = as.numeric(petal_width))
  
  predict_iris <- predict(classifier_svm, newdata = newSample)
  
  return(list(predict_res = as.character(predict_iris[[1]]), 
              input = newSample))
  
}


