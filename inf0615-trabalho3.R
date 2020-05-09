#------------------------------------------------#
# INF-0615 Aprendizado de Máquina                #
#          Supervisionado I                      #
#                                                #
# Trabalho Avaliativo 3 - Projeto Final          #
#------------------------------------------------#
# Nome COMPLETO Aluna (o) 1: Karla Fátima Calvoso#
#                            Simões              #
# Nome COMPLETO Aluna (o) 2: Weld Lucas Cunha    #
#                    
#
#------------------------------------------------#


# Limpando o ambiente antes de iniciar a execução do código:
rm(list = ls())

# Configurando a semente:
set.seed(0)

## Loading some R libraries:

## Loading some R files:
source("./rfiles/preprocessing.R")
source("./rfiles/model_evaluation.R")
source("./rfiles/q1_data_inspection.R")
source("./rfiles/q2_tree_baseline.R")
source("./rfiles/q3_tree_size_variations.R")
source("./rfiles/q4_tree_features_eng.R")
source("./rfiles/q5_random_forests.R")
source("./rfiles/q6_metrics_analysis.R")


################ Project main scope #################

#__________________ 1 - Get Data __________________#
# Loadinng the data from .csv file:
data <- read.csv("COVID19_training_validation_set_cleaned.csv", sep=',', header=TRUE)
data_test <- read.csv("COVID19_test_set_cleaned.csv", sep=',', header=TRUE)

# Defining some important variables:
target_col <- ncol(data)
split_prop <- 0.8

# Splitting data into training and validation sets:
m <- split_data(data, split_prop)
data_train <- m[[1]]
data_valid <- m[[2]]

# Questao 1 - Inspecionar os dados de treinamento.
inspect_data(data_train)
inspect_data(data_valid)
inspect_data(data_test)

#______ 2 - Clean, Prepare & Manipulate Data ______#
# Adjust classes imbalance:
dead_class <- data_train[data_train$label == "dead",]
treat_class <- data_train[data_train$label == "onTreatment",]
recov_class <- data_train[data_train$label == "recovered",]
oversampledDeadData <- rebalance_data(dead_class, 10)
oversampledRecovData <- rebalance_data(recov_class, 6)
data_train <- rbind(oversampledDeadData, oversampledRecovData, treat_class)

# Encoding the features:
data_train <- encode_features(data_train)
data_valid <- encode_features(data_valid)
data_test <- encode_features(data_test)

# Normalizing the data:
target_col <- ncol(data_train) # Updating the target_col value.
min_val <- apply(data_train[, -target_col], 2, min)
max_val <- apply(data_train[, -target_col], 2, max)
data_train <- data_normalization(data_train, min_val, max_val, target_col)
data_valid <- data_normalization(data_valid, min_val, max_val, target_col)
data_test <- data_normalization(data_test, min_val, max_val, target_col)


#________________ 3 - Train Models ________________#
# Questao 2 - Treinar uma árvore de decisão como baseline.
baseline <- create_tree_baseline(data_train)
base_pruned <- prune_tree(baseline)
# Evaluating the baseline models:
evaluate_model(baseline, data_train)
evaluate_model(baseline, data_valid)
evaluate_model(base_pruned, data_train)
evaluate_model(base_pruned, data_valid)

# Questao 3 - Treine outras árvores de decisão variando o 
# tamanho das árvores geradas.
max_depth <- 20
response <- train_tree_models_bydepth(max_depth, data_train, data_valid)
error_depth <- response$errors
tree_opt <- response$tree_opt
# Plote o erro no conjunto de treinamento e validação pela profundidade da árvore de decisão.
plot_train_valid_error_trees(error_depth)
evaluate_model(tree_opt, data_train)
evaluate_model(tree_opt, data_valid)

# Questao 4 - Explore pelo menos 2 possíveis subconjuntos de
# features para treinar uma árvore de decisão.
features_correlation_analysis(data_train[-ncol(data_train)])
sub_models <- train_subset_models(data_train)
evaluate_model(sub_models$m1, data_train)
evaluate_model(sub_models$m1, data_valid)
evaluate_model(sub_models$m1, data_test)

evaluate_model(sub_models$m2, data_train)
evaluate_model(sub_models$m2, data_valid)
evaluate_model(sub_models$m2, data_test)

# Questao 5 - Treine várias florestas aleatórias variando o número de árvores.
max_ntrees <- 50
response <- train_random_forests(max_ntrees, data_train, data_valid)
error_ntree <- response$errors
rf_opt <- response$rf_opt
# Plote o erro no conjunto de treinamento e validação pela profundidade da árvore de decisão.
plot_train_valid_error_rfs(error_ntree)
evaluate_model(rf_opt, data_train, isDecisionTree=FALSE)
evaluate_model(rf_opt, data_valid, isDecisionTree=FALSE)
evaluate_model(rf_opt, data_test, isDecisionTree=FALSE)

#_________________ 4 - Test Data _________________#
# Questao 6 - Calcule a matriz de confusão, os verdadeiros positivos
# para cada classe e a acurácia normalizada no teste para os melhores modelos

# Setting the optimal models (from each category) to be evaluated:
baseline_opt <- baseline
tree_depth_opt <- tree_opt
subset_model_opt <- sub_models$m1
rf_ntree_opt <- rf_opt

# Checking the baseline:
train_results_1 <- predictAndEvaluate(baseline_opt, data_train, isDecisionTree=TRUE)
valid_results_1 <- predictAndEvaluate(baseline_opt, data_valid, isDecisionTree=TRUE)
test_results_1 <- predictAndEvaluate(baseline_opt, data_test, isDecisionTree=TRUE)
test_results_1$CM
test_results_1$STATS
test_results_1$ACC

# Checking the best depth tree:
train_results_2 <- predictAndEvaluate(tree_depth_opt, data_train, isDecisionTree=TRUE)
valid_results_2 <- predictAndEvaluate(tree_depth_opt, data_valid, isDecisionTree=TRUE)
test_results_2 <- predictAndEvaluate(tree_depth_opt, data_test, isDecisionTree=TRUE)
test_results_2$CM
test_results_2$STATS
test_results_2$ACC

# Checking the features-subset model:
train_results_3 <- predictAndEvaluate(subset_model_opt, data_train, isDecisionTree=TRUE)
valid_results_3 <- predictAndEvaluate(subset_model_opt, data_valid, isDecisionTree=TRUE)
test_results_3 <- predictAndEvaluate(subset_model_opt, data_test, isDecisionTree=TRUE)
test_results_3$CM
test_results_3$STATS
test_results_3$ACC

# Checking the best random forest:
train_results_4 <- predictAndEvaluate(rf_ntree_opt, data_train, isDecisionTree=FALSE)
valid_results_4 <- predictAndEvaluate(rf_ntree_opt, data_valid, isDecisionTree=FALSE)
test_results_4 <- predictAndEvaluate(rf_ntree_opt, data_test, isDecisionTree=FALSE)
test_results_4$CM
test_results_4$STATS
test_results_4$ACC


#__________________ 5 - Improve __________________#


## Questao 7 - Escreva um relat ório de no máximo 5 páginas.

