
#Pick up variable pass from command line

session_id <- (paste("-----Run time: ", Sys.time(), " by: ", Sys.getpid() ," --------"))
print(session_id)

#sink(file = paste("log_file/", format(Sys.time(), "%Y%m%d_%H%M"), "_R_console_Msg.log", sep = ""), append = TRUE)

arguments <- commandArgs(trailingOnly = TRUE)

print("Inputted Arguments: ")
print(arguments)


#Iris predict function script

suppressPackageStartupMessages(library(randomForest))


suppressPackageStartupMessages(library(caret))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(DBI))
suppressPackageStartupMessages(library(RSQLite))


predict_iris_fun <- function(sepal_length, sepal_width, petal_length, petal_width) {
  
  stopifnot(is.numeric(sepal_length) & is.numeric(sepal_width) & is.numeric(petal_length) & is.numeric(petal_width))
  
  
  new_data = data.frame(Sepal.Length = sepal_length, 
                        Sepal.Width = sepal_width, 
                        Petal.Length = petal_length, 
                        Petal.Width = petal_width)
  
  new_data_Json <- toJSON(new_data)
  
  iris_model <- readRDS(file = "ML_model/iris_RF_Model.RDS")
  
  predict_new_data <- as.character(predict(iris_model, newdata = new_data))
  
  predict_id <- paste(Sys.getpid(), Sys.time(), sep = "-")
  
  predict_df <- data.frame(Id = predict_id, 
                           input_param = as.character(new_data_Json), 
                           predict_result = predict_new_data)
  
  
  #write result to DB
  con <- dbConnect(RSQLite::SQLite(), "DB/tempDB.db")
  
  DBI::dbWriteTable(con, "irisPrediction", predict_df, append = TRUE)
  
  dbDisconnect(con)
  
  
  return(predict_df)
  
}


#run function

predict_iris_fun(as.numeric(arguments[1]), as.numeric(arguments[2]), as.numeric(arguments[3]), as.numeric(arguments[4]))

#sink()


