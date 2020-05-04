library("caret")
library("reshape2")
library("ggplot2")

# Predict data using model and evaluate
predictAndEvaluate <- function(model, data, isDecisionTree = TRUE){
  prediction <- predict(model, data)
  if (isDecisionTree){
    y_pred <- rep('', nrow(prediction))
  
    columns <- colnames(prediction)
    for (i in 1:nrow(data)){
      y_pred[i] = columns[prediction[i , ] == max(prediction[i , ])]
    }
  }
  else{
    y_pred <- prediction
  }
  cm <- confusionMatrix(data = as.factor(y_pred), 
                        reference = as.factor(data$label))
  return(list(CM=cm$table, STATS=cm$byClass, ACC=cm$overall["Accuracy"]))
}


# calculate_errors <- function(cm_matrix){
#   hits <- 0 
#   for (i in 1:nrow(cm_matrix)){
#     hits <- hits + cm_matrix[i,i]
#   }
#   error <- (sum(cm_matrix) - hits)/sum(cm_matrix)
#   return(error)
# }


plot_train_valid_error <- function(errorPerDepth){
  errorPerDepth <- melt(errorPerDepth, id="depth")  # convert to long format
  ggplot(data=errorPerDepth, aes(x=depth, y=value, colour=variable)) + geom_line()
}
