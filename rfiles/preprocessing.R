
split_data <- function(data, split_prop){
  
  indexes <- sample(1:nrow(data))
  p_split <- as.integer(split_prop * nrow(data))

  idx1 <- indexes[1:p_split]
  data_1 <- data[idx1, ]
  idx2 <- indexes[(p_split+1):nrow(data)]
  data_2 <- data[idx2, ]

  return(list(data_1, data_2))
}


encode_features <- function(data){
  
  # Country-idh-encoding:
  country_list <- c("Switzerland", "Germany", "Hong Kong", "Australia", "Singapore", "Canada", "USA",
                    "UK", "Japan", "Taiwan", "South Korea", "Spain", "France", "Italy",
                    "UAE", "Bahrain", "Malaysia", "Iran", "Thailand", "China", "Vietnam")
  idh_list <- c(0.946, 0.939, 0.939, 0.938, 0.935, 0.922, 0.920,
                0.920, 0.915, 0.911, 0.906, 0.893, 0.891, 0.883,
                0.866, 0.838, 0.804, 0.797, 0.765, 0.758, 0.693)

  country_idh <- rep(0, nrow(data))
  for (c in unique(data$country)){
    idh <- idh_list[country_list == c][1]
    country_idh[data$country == c] = idh
  }
  data$country_idh <- country_idh
  data$country <- NULL
    
  # One-hot encode:
  data$female <- as.numeric(data$gender == "female")
  data$male <- as.numeric(data$gender == "male")
  data$gender <- NULL
  
  # Re-adjusting the label columns for organization purposes:
  x <- data$label
  data$label <- NULL
  data$label <- x

  return(data)
}


data_normalization <- function(data, min_val, max_val, target_col){
  
  minmax_val <- (max_val - min_val)
  data[, -target_col] <- sweep(data[, -target_col], 2, min_val, "-")
  data[, -target_col] <- sweep(data[, -target_col], 2, minmax_val, "/")
  
  return(data)
}
