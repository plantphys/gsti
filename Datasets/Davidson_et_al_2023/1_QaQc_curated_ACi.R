library(here)
path <- here()

setwd(file.path(path,'/Datasets/Davidson_et_al_2023'))

load('0_curated_data.Rdata',verbose=TRUE)

curated_data <- curated_data[curated_data$Qin<2000,]
curated_data <- curated_data[match(unique(curated_data$SampleID_num), curated_data$SampleID_num),]

hist(curated_data$Ci) ## No below zero value
hist(curated_data$Qin) 
hist(curated_data$Tleaf)

save(curated_data,file='1_QC_ACi_data.Rdata')