
#Iris predict function script

library(randomForest)
library(caret)
library(jsonlite)
library(DBI)
library(RSQLite)


predict_iris_fun <- function(sepal_length, sepal_width, petal_length, petal_width){
  
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





