dim(dados_covid)
summary(dados_covid)

dados_covid$estado <- 0
dados_covid[dados_covid$label == "onTreatment", "estado"] <- 1
dados_covid[dados_covid$label == "recovered", "estado"] <- 2

dados_covid$label <- NULL
dados_covid$estado <- as.factor(dados_covid$estado)

# Treino-Validação 80% / Validação 20%
random_Indexes <- sample(1:nrow(dados_covid), size=0.8*nrow(dados_covid))
covid_treino <- dados_covid[random_Indexes, ]
covid_Val  <- dados_covid[-random_Indexes, ] 

#------------------------------------------------#
# Questao 1 - Inspecione os dados.               #
# Quantos exemplos você tem?                     #
# Qual o intervalo de valores de cada feature?   #
#------------------------------------------------#
dim(covid_treino)
summary(covid_treino)

dim(covid_Val)
summary(covid_Val)

# Identificando a coluna que contém o target:
target_col = 16

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


adjust_prop <- as.integer(dim(ontreatData_v)[1]/dim(recoverData_v)[1])
selectedIndex <- sample(1:nrow(deadData_t), adjust_prop*nrow(deadData_t), replace=TRUE)
oversampledDeadData <- deadData_t[selectedIndex,]
dim(oversampledDeadData)

covid_treino <- rbind(covid_treino,oversampledDeadData)
dim(covid_treino)

selectedIndex <- sample(1:nrow(recoverData_t), adjust_prop/2*nrow(recoverData_t), replace=TRUE)
oversampledRecData <- recoverData_t[selectedIndex,]
dim(oversampledRecData)

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

covid_treino[, -target_col] <- sweep(covid_treino[, -target_col], 2, maxcovid_treino, "-")
covid_treino[, -target_col] <- sweep(covid_treino[, -target_col], 2, mincovid_treino, "/")

covid_Val[, -target_col] <- sweep(covid_Val[, -target_col], 2, mindados_treino, "-")
covid_Val[, -target_col] <- sweep(covid_Val[, -target_col], 2, minMaxDifTreino, "/")

#covid_test[, -target_col] <- sweep(covid_test[, -target_col], 2, mindados_treino, "-")
#covid_test[, -target_col] <- sweep(covid_test[, -target_col], 2, minMaxDifTreino, "/")

summary(covid_treino)
summary(covid_Val)








