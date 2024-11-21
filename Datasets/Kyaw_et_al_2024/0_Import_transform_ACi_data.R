## This dataset was sent by Josh Caplan and Thu Ya Kyaw

library(here)
path <- here()

setwd(file.path(path,'/Datasets/Kyaw_et_al_2024'))

original_data =read.csv('Leaf gas exchange.csv')
curated_data =original_data[,c("SampleID","A","Ci","Patm","Qin","Tleaf","gsw")]

curated_data$SampleID_num = as.numeric(as.factor(curated_data$SampleID))
curated_data = curated_data[order(-curated_data$Qin),]


save(curated_data,file='0_curated_data.Rdata')
