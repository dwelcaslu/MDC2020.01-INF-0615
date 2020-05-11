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
  return(list(CM=cm$table, STATS=cm$byClass, ACC_norm=mean(cm$byClass[, 'Sensitivity'])))
}


evaluate_model <- function(model, data, isDecisionTree = TRUE){
  #Let's see how we do in the data tree:
  treeEval <- predictAndEvaluate(model, data, isDecisionTree=isDecisionTree)
  print(paste('Norm. ACC:', treeEval$ACC_norm))
  print(paste('Error:', 1 - treeEval$ACC_norm))
}


plot_train_valid_error_trees <- function(errorPerDepth){
  errorPerDepth <- melt(errorPerDepth, id="depth")  # convert to long format
  ggplot(data=errorPerDepth, aes(x=depth, y=value, colour=variable)) + geom_line()
}

plot_train_valid_error_rfs <- function(errorPerDepth){
  errorPerDepth <- melt(errorPerDepth, id="ntree")  # convert to long format
  ggplot(data=errorPerDepth, aes(x=ntree, y=value, colour=variable)) + geom_line()
}