#Modelling Iris dataset

#library-----------

library(caret)
library(randomForest)



#Dataset ---------------
data_iris <- iris


#Splitting dataset to traning and test set------------


set.seed(123)

train_index <- createDataPartition(data_iris$Species, p = 0.8, list = FALSE)

train_dataset <- data_iris[train_index, ]
test_dataset <- data_iris[-train_index, ]


#Fit train dataset to RF algorithm--------------


classifier_RF <- randomForest(x = train_dataset[, -5],
                              y = train_dataset$Species)


#predict the test dataset---------

predict_iris <- predict(classifier_RF, newdata = test_dataset[, -5])


#confusion matrix for test dataset
confusionMatrix(predict_iris, test_dataset$Species)



#save model

#saveRDS(classifier_RF, "ML_model/iris_RF_Model.RDS")



#function to predict new dataset


predict_iris_fun <- function(sepal_length, sepal_width, petal_length, petal_width){
  
  stopifnot(is.numeric(sepal_length) & is.numeric(sepal_width) & is.numeric(petal_length) & is.numeric(petal_width))
  
  
  new_data = data.frame(Sepal.Length = sepal_length, 
                        Sepal.Width = sepal_width, 
                        Petal.Length = petal_length, 
                        Petal.Width = petal_width)
  
  iris_model <- readRDS(file = "ML_model/iris_RF_Model.RDS")
  
  predict_new_data <- predict(iris_model, newdata = new_data)
  

  return(predict_new_data)
  
}



