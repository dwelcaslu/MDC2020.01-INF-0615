
inspect_data <- function(data){
  print(paste('Dimensions:', dim(data)[1], 'rows and', dim(data)[2], 'columns'))
  print('Summary:')
  print(summary(data))
}
