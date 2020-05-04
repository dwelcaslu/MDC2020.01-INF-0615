library(randomForest)

train_rf_model <- function(trainData, ntree){
  #Train RF model
  rfModel <- randomForest(formula=label ~ case_in_country + reporting.date + age + symptom_onset +
                            + If_onset_approximated + hosp_visit_date + international_traveler + domestic_traveler +
                            + exposure_start + exposure_end + traveler + visiting.Wuhan +
                            + from.Wuhan + country_idh + female + male,
                          data= trainData, ntree=ntree)
  return(rfModel)
}


train_random_forests <- function(max_ntrees, trainData, validData){
  error_ntree <- data.frame(depth=numeric(max_ntrees), error_train=numeric(max_ntrees),
                              error_valid=numeric(max_ntrees))
  for (ntree in 1:max_ntrees){
    rfModel <- train_rf_model(trainData, ntree)
    
    trainResults <- predictAndEvaluate(rfModel, trainData, isDecisionTree=FALSE)
    valResults <- predictAndEvaluate(rfModel, validData, isDecisionTree=FALSE)
    
    error_ntree[ntree,] = c(ntree, 1 - mean(trainResults$STATS[,'Sensitivity']),
                              1 - mean(valResults$STATS[,'Sensitivity']))
  }
  return(error_ntree)
}
