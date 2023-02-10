
## Dataset accessible at XXXXX (will update when I have a DOI)

library(here)
path <- here()

setwd(file.path(path,'/Datasets/Davidson_et_al_2023'))

original_data <-read.csv('Stomatal_Response_Curve_Data.csv')
curated_data<- original_data[,c("SampleID","A","Ci","Patm","Qin","Tleaf")]

curated_data$SampleID_num <- as.numeric(as.factor(curated_data$SampleID))
curated_data <- curated_data[order(-curated_data$Qin),]


save(curated_data,file='0_curated_data.Rdata')
