
tree_base <- rpart(formula=estado~case_in_country + reporting.date + 
                     age + symptom_onset + If_onset_approximated +
                     hosp_visit_date + international_traveler + domestic_traveler +
                     exposure_start + exposure_end + traveler + visiting.Wuhan +
                     from.Wuhan + male + female + idh, 
                   data=covid_treino, method="class",
                   control=rpart.control(minsplit=2, cp=0.0, xval = 10),
                   parms= list(split="information"))

printcp(tree_base)
summary(tree_base)






