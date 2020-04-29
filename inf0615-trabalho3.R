#------------------------------------------------#
# INF-0615 Aprendizado de Máquina                #
#          Supervisionado I                      #
#                                                #
# Trabalho Avaliativo 3 - Projeto Final          #
#------------------------------------------------#
# Nome COMPLETO Aluna (o) 1: Karla Fátima Calvoso#
#                            Simões              #
# Nome COMPLETO Aluna (o) 2: Weld Lucas Cunha    #
#                                                #
#------------------------------------------------#


# Limpando o ambiente antes de iniciar a execução do código:
rm(list = ls())

# Configurando a semente:
set.seed(0)

# Loading some R libraries:
library(glmnet)   #for logreg with regularization
library(caret)  #for cm
# Loading some personal libraries:
source("./rfiles/q1_data_inspection.R")
source("./rfiles/q2_tree_baseline.R")
source("./rfiles/q3_tree_size_variations.R")
source("./rfiles/q4_tree_features_eng.R")
source("./rfiles/q5_random_forests.R")
source("./rfiles/q6_metrics_analysis.R")


################ Project main scope #################
## Questao 1 - Inspecionar os dados de treinamento.

## Questao 2 - Treinar uma árvore de decisão como baseline.

## Questao 3 - Treine outras árvores de decisão variando o 
## tamanho das árvores geradas.

## Questao 4 - Explore pelo menos 2 possíveis subconjuntos de
## features para treinar uma árvore de decisão.

## Questao 5 - Treine várias florestas aleatórias variando o número de árvores.

## Questao 6 - Calcule a matriz de confusão, os verdadeiros positivos
# para cada classe e a acurácia normalizada no teste para os melhores modelos

## Questao 7 - Escreva um relatório de no máximo 5 páginas.

