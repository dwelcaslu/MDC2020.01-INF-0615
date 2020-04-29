#------------------------------------------------#
# INF-0615 Aprendizado de Máquina                #
#          Supervisionado I                      #
#                                                #
# Trabalho Avaliativo 1                          #
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

# Load libraries
library(glmnet)   #for logreg with regularization
library(caret)  #for cm

