
features_correlation_analysis <- function(data){
  # Print the correlation between features:
  correlation <- cor(data)
  for (n in rownames(cor(data))){
    max_cor <- max(abs(correlation[correlation[, n] < 1, n]))
    max_cor_var <- row.names(correlation)[abs(correlation[, n]) == max_cor]
    print(paste(n, '- max feat_cor (abs.):', round(max_cor, 6), '- with', max_cor_var))
  }
}


train_subset_models <- function(data){

    #If we want to use Entropy + Gain of Information
    m1 <- rpart(formula=label ~ case_in_country + reporting.date + age,
                data=data, method="class",
                control=rpart.control(minsplit=2, cp=0.0, xval = 10),
                parms= list(split="information"))

    #If we want to use Entropy + Gain of Information
    m2 <- rpart(formula=label ~ case_in_country + reporting.date + age
                + international_traveler + domestic_traveler
                + exposure_start + exposure_end + traveler,
                data=data, method="class",
                control=rpart.control(minsplit=2, cp=0.0, xval = 10),
                parms= list(split="information"))
    return(list(m1=m1, m2=m2))
}
