library(randomForest)

train_rf_model <- function(trainData, ntree){
  #Train RF model
  # mtry <- sqrt(dim(trainData)[2])
  mtry <- 12
  rfModel <- randomForest(formula=label ~ case_in_country + reporting.date + age + symptom_onset +
                            + If_onset_approximated + hosp_visit_date + international_traveler + domestic_traveler +
                            + exposure_start + exposure_end + traveler + visiting.Wuhan +
                            + from.Wuhan + country_idh + female + male,
                          data= trainData, ntree=ntree, mtry=mtry)
  return(rfModel)
}


train_random_forests <- function(max_ntrees, trainData, validData){
  error_ntree <- data.frame(ntree=numeric(max_ntrees), error_train=numeric(max_ntrees),
                              error_valid=numeric(max_ntrees))
  rf_opt <- NULL
  acc_init <- 0
  for (ntree in 1:max_ntrees){
    rfModel <- train_rf_model(trainData, ntree)
    trainResults <- predictAndEvaluate(rfModel, trainData, isDecisionTree=FALSE)
    valResults <- predictAndEvaluate(rfModel, validData, isDecisionTree=FALSE)
    
    error_ntree[ntree,] = c(ntree, 1 - trainResults$ACC_norm, 1 - valResults$ACC_norm)
    
    if (valResults$ACC_norm > acc_init){
      acc_init <- valResults$ACC_norm
      rf_opt <- rfModel
    }
  }
  return(list(errors=error_ntree, rf_opt=rf_opt))
}
