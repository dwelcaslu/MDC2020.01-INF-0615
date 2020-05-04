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
  
  # Defining some important variables:
  split_prop <- 0.8
  
  # Splitting data into training and validation sets:
  m <- split_data(data, split_prop)
  data_train <- m[[1]]
  data_valid <- m[[2]]
  
  # Questao 1 - Inspecionar os dados de treinamento.
  inspect_data(data_train)
  inspect_data(data_valid)
  
  
  #______ 2 - Clean, Prepare & Manipulate Data ______#
  # Encoding the features:
  data_train <- encode_features(data_train)
  data_valid <- encode_features(data_valid)
  
  # Normalizing the data:
  target_col <- ncol(data_train)
  min_val <- apply(data_train[, -target_col], 2, min)
  max_val <- apply(data_train[, -target_col], 2, max)
  data_train <- data_normalization(data_train, min_val, max_val, target_col)
  data_valid <- data_normalization(data_valid, min_val, max_val, target_col)
  
  
  #________________ 3 - Train Models ________________#
  # Questao 2 - Treinar uma árvore de decisão como baseline.
  baseline <- create_tree_baseline(data_train)
  base_pruned <- prune_tree(baseline)
  # Evaluating the baseline models:
  evaluate_baseline(baseline, base_pruned, data_valid)
  
  # Questao 3 - Treine outras árvores de decisão variando o 
  # tamanho das árvores geradas.
  max_depth <- 20
  error_depth <- train_tree_models_bydepth(max_depth, data_train, data_valid)
  # Plote o erro no conjunto de treinamento e validação pela profundidade da árvore de decisão.
  plot_train_valid_error(error_depth)
  
  # Questao 4 - Explore pelo menos 2 possíveis subconjuntos de
  # features para treinar uma árvore de decisão.
  features_correlation_analysis(data_train[-target_col])
  
  # Questao 5 - Treine várias florestas aleatórias variando o número de árvores.
  max_ntrees <- 100
  error_ntree <- train_random_forests(max_ntrees, data_train, data_valid)
  # Plote o erro no conjunto de treinamento e validação pela profundidade da árvore de decisão.
  plot_train_valid_error(error_ntree)
  
  #_________________ 4 - Test Data _________________#
  # Questao 6 - Calcule a matriz de confusão, os verdadeiros positivos
  # para cada classe e a acurácia normalizada no teste para os melhores modelos
  
  
  #__________________ 5 - Improve __________________#
  
  
  ## Questao 7 - Escreva um relat ório de no máximo 5 páginas.
  
