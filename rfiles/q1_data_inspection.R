dim(dados_covid)
summary(dados_covid)

any(is.na(dados_covid))


dados_covid$male <- as.numeric(dados_covid$gender == "male")
dados_covid$female <- as.numeric(dados_covid$gender == "female")

dados_covid$idh <- 0
dados_covid[dados_covid$country == "Switzerland", "idh"] <- 0.946
dados_covid[dados_covid$country == "Germany", "idh"] <- 0.939
dados_covid[dados_covid$country == "Hong Kong", "idh"] <- 0.939
dados_covid[dados_covid$country == "Australia", "idh"] <- 0.938
dados_covid[dados_covid$country == "Singapore", "idh"] <- 0.935
dados_covid[dados_covid$country == "Canada", "idh"] <- 0.922
dados_covid[dados_covid$country == "USA", "idh"] <- 0.920
dados_covid[dados_covid$country == "UK", "idh"] <- 0.920
dados_covid[dados_covid$country == "Japan", "idh"] <- 0.915
dados_covid[dados_covid$country == "Taiwan", "idh"] <- 0.911
dados_covid[dados_covid$country == "South Korea", "idh"] <- 0.906
dados_covid[dados_covid$country == "Spain", "idh"] <- 0.893
dados_covid[dados_covid$country == "France", "idh"] <- 0.891
dados_covid[dados_covid$country == "Italy", "idh"] <- 0.883
dados_covid[dados_covid$country == "UAE", "idh"] <- 0.866
dados_covid[dados_covid$country == "Bahrain", "idh"] <- 0.838
dados_covid[dados_covid$country == "Malaysia", "idh"] <- 0.804
dados_covid[dados_covid$country == "Iran", "idh"] <- 0.797
dados_covid[dados_covid$country == "Thailand", "idh"] <- 0.765
dados_covid[dados_covid$country == "China", "idh"] <- 0.758
dados_covid[dados_covid$country == "Vietnam", "idh"] <- 0.693

dados_covid$estado <- 0
dados_covid[dados_covid$label == "onTreatment", "estado"] <- 1
dados_covid[dados_covid$label == "recovered", "estado"] <- 2

dados_covid$gender <- NULL
dados_covid$country <- NULL
dados_covid$label <- NULL
# Identificando a coluna que contém o target:
target_col = 17
correlation <- cor(dados_covid); correlation
max_cor_y <- sort(abs(correlation[correlation[, target_col] < 1, target_col]), decreasing=TRUE); print(max_cor_y)
# Analisando as correlações entre as features:
feat_cor <- correlation[-target_col, -target_col]
for (n in names(max_cor_y)){
  max_cor <- max(abs(feat_cor[feat_cor[, n] < 1, n]))
  max_cor_var <- row.names(feat_cor)[abs(feat_cor[, n]) == max_cor]
  print(paste(n, '- max feat_cor (abs.):', round(max_cor, 6), '- with', max_cor_var))
}


# Treino-Validação 80% / Validação 20%
random_Indexes <- sample(1:nrow(dados_covid), size=0.8*nrow(dados_covid))
covid_treino <- dados_covid[random_Indexes, ]
covid_Val  <- dados_covid[-random_Indexes, ] 

any(is.na(covid_treino))
any(is.na(covid_Val))
#------------------------------------------------#
# Questao 1 - Inspecione os dados.               #
#------------------------------------------------#
# Quantos exemplos de cada classe
# dead = 56
# 0nTreatment = 1065
# recorvered = 138
dim(covid_treino)
summary(covid_treino)

dim(covid_Val)
summary(covid_Val)


############ Inspecionando os dados ############
head(covid_treino)
summary(covid_treino)
dim(covid_treino)


# Inspecionando as frequências de cada classe no treino e na validação:
deadData_t <- covid_treino[covid_treino$estado == "0",]
ontreatData_t <- covid_treino[covid_treino$estado == "1",]
recoverData_t <- covid_treino[covid_treino$estado == "2",]
dim(deadData_t)
dim(ontreatData_t)
dim(recoverData_t)

deadData_v <- covid_Val[covid_Val$estado == "0",]
ontreatData_v <- covid_Val[covid_Val$estado == "1",]
recoverData_v <- covid_Val[covid_Val$estado == "2",]
dim(deadData_v)
dim(ontreatData_v)
dim(recoverData_v)

############ Lidando com o desbalanceamento entre as classes ############
##################################
####### Oversampling #############
##################################


adjust_prop <- as.integer(dim(ontreatData_t)[1]/dim(recoverData_t)[1])
selectedIndex <- sample(1:nrow(deadData_t), adjust_prop*nrow(deadData_t), replace=TRUE)
oversampledDeadData <- deadData_t[selectedIndex,]
dim(oversampledDeadData)

covid_treino <- rbind(covid_treino,oversampledDeadData)
dim(covid_treino)

selectedIndex <- sample(1:nrow(recoverData_t), adjust_prop/2*nrow(recoverData_t), replace=TRUE)
oversampledRecData <- recoverData_t[selectedIndex,]
dim(oversampledRecData)

head(covid_treino)
covid_treino <- rbind(covid_treino,oversampledRecData)
dim(covid_treino)

# Normalização Min-Max
# Min-Max:
maxcovid_treino <- apply(covid_treino[, -target_col], 2, max)
mincovid_treino <- apply(covid_treino[, -target_col], 2, min)

maxcovid_treino
mincovid_treino

minMaxDifTreino <- (maxcovid_treino - mincovid_treino)
minMaxDifTreino

covid_treino[, -target_col] <- sweep(covid_treino[, -target_col], 2, mincovid_treino, "-")
covid_treino[, -target_col] <- sweep(covid_treino[, -target_col], 2, minMaxDifTreino, "/")

covid_Val[, -target_col] <- sweep(covid_Val[, -target_col], 2, mincovid_treino, "-")
covid_Val[, -target_col] <- sweep(covid_Val[, -target_col], 2, minMaxDifTreino, "/")

#covid_test[, -target_col] <- sweep(covid_test[, -target_col], 2, mindados_treino, "-")
#covid_test[, -target_col] <- sweep(covid_test[, -target_col], 2, minMaxDifTreino, "/")

summary(covid_treino)
summary(covid_Val)









