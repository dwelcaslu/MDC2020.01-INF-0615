
train_tree_model <- function(trainData, maxdepth){
  model <- rpart(formula=label ~ case_in_country + reporting.date + age + symptom_onset +
                  + If_onset_approximated + hosp_visit_date + international_traveler + domestic_traveler +
                  + exposure_start + exposure_end + traveler + visiting.Wuhan +
                  + from.Wuhan + country_idh + female + male,
                  data=trainData, method="class",
                  control=rpart.control(minsplit=2, cp=0.0, maxdepth=maxdepth, xval = 10),
                  parms= list(split="information"))
  return(model)
}


train_tree_models_bydepth <- function(max_depth, trainData, validData){
  errorPerDepth <- data.frame(depth=numeric(max_depth), error_train=numeric(max_depth),
                              error_valid=numeric(max_depth))
  tree_opt <- NULL
  acc_init <- 0
  for (depth in 1:max_depth){
    treeModel <- train_tree_model(trainData, depth)
    
    trainResults <- predictAndEvaluate(treeModel, trainData)
    valResults <- predictAndEvaluate(treeModel, validData)
    
    errorPerDepth[depth,] = c(depth, 1 - mean(trainResults$STATS[,'Sensitivity']),
                              1 - mean(valResults$STATS[,'Sensitivity']))
  
    if (mean(valResults$STATS[,'Sensitivity']) > acc_init){
      acc_init <- mean(valResults$STATS[,'Sensitivity'])
      tree_opt <- treeModel
    }
  }
  return(list(errors=errorPerDepth, tree_opt=tree_opt))
}
