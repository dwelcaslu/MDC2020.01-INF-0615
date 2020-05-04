library(rpart)
library(rpart.plot)

create_tree_baseline <- function(data){
  #If we want to use Entropy + Gain of Information
  baseline <- rpart(formula=label ~ case_in_country + reporting.date + age + symptom_onset +
                    + If_onset_approximated + hosp_visit_date + international_traveler + domestic_traveler +
                    + exposure_start + exposure_end + traveler + visiting.Wuhan +
                    + from.Wuhan + country_idh + female + male,
                    data=data, method="class",
                    control=rpart.control(minsplit=2, cp=0.0, xval = 10),
                    parms= list(split="information"))
  
  return(baseline)
}

prune_tree <- function(model){
  #Prune the tree based on the complexity parameter that minimizes
  #the error in cross-validation (xerror)
  minCP <- model$cptable[which.min(model$cptable[,"xerror"]),"CP"]
  pruned_model <- prune(model, cp=minCP)
  
  # #Plot the pruned tree
  # rpart.plot(pruned_model,
  #            extra=104, box.palette="GnBu",
  #            branch.lty=3, shadow.col="gray", nn=TRUE)
  
  return(pruned_model)
}

evaluate_baseline <- function(baseline, base_pruned, data){
  #Let's see how we do in the data non-prunned tree:
  treeEval <- predictAndEvaluate(baseline, data)
  print(paste('Norm. ACC Non-pruned tree:', mean(treeEval$STATS[,'Sensitivity'])))
  treeEval$CM
  #prunned tree
  ptreeEval <- predictAndEvaluate(base_pruned, data)
  print(paste('Norm. ACC Pruned tree:', mean(ptreeEval$STATS[,'Sensitivity'])))
  ptreeEval$CM
}

summarize_tree <- function(tree_model){
  
  summary(tree_model)
  
  # # Plot using prp
  # prp(tree_model)
  #Plot using rpart.plot
  rpart.plot(tree_model,
             extra=104, box.palette="GnBu",
             branch.lty=3, shadow.col="gray", nn=TRUE)

}
