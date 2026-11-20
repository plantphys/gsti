library(here)
path <- here()

setwd(file.path(path,'/Datasets/Kyaw_et_al_2024'))

load('0_curated_data.Rdata',verbose=TRUE)

hist(curated_data$Ci) ## No below zero value
hist(curated_data$Qin) 
hist(curated_data$Tleaf)
hist(curated_data$gsw)

curated_data$QC="ok"
save(curated_data,file='1_QC_ACi_data.Rdata')