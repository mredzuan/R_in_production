library(caret)
library(e1071)



#Dataset
data_iris <-  iris


#Splitting data to test and training dataset

set.seed(200)

train_index <- createDataPartition(data_iris$Species, p = 0.8, list = FALSE)

train_dataset <- data_iris[train_index, ]
test_dataset <- data_iris[-train_index, ]




#Fit train dataset to RF algorithm

classifier_SVM <- svm(Species ~ .,
                      data = train_dataset)


#saveRDS(classifier_SVM, "Iris_Model/Iris_SVM_model.RDS")




#Predict test result

predict_iris <- predict(classifier_SVM, newdata = test_dataset[-5])


#Predict only 1 sample

only_1Sample <- data.frame(Sepal.Length = 1, Sepal.Width = 1, Petal.Length = 1, Petal.Width = 1)

predict_1sample <- predict(classifier_SVM, newdata = only_1Sample)

only_1Sample_update <- cbind(only_1Sample, Species = paste(predict_1sample, " (Predicted)", sep = ""))

data_irisUpdate <- rbind(data_iris, only_1Sample_update)







#Confusion matrix for predict result from test dataset
confusionMatrix(predict_iris, test_dataset[, 5])




#Plotting scatter plot matrix


pairs(data_irisUpdate[,1:4],col=data_irisUpdate[,5],oma=c(4,4,6,12))
par(xpd=TRUE)
legend(0.90,0.6, as.vector(unique(data_irisUpdate$Species)),fill=c(1,2,3,4))




featurePlot(x = data_irisUpdate[-151 ,1:4], y = data_irisUpdate[-151,5], plot = "ellipse", auto.key = list(columns = 3))

