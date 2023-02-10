library(here)
path=here()
## I downloaded this dataset from : https://doi.org/10.15486/ngt/1896884 and https://doi.org/10.15486/ngt/1896889

source(paste(path,'/R/Correspondance_tables_ESS.R',sep=''))
setwd(paste(path,'/Datasets/Lamour_et_al_2022',sep=''))

original_data=read.csv('PA_2022_Aci_data.csv')
curated_data=original_data[,c("SampleID", "record","A","Ci","CO2s","CO2r","SampleID","Patm","Qin","RHs","Tleaf","Remove")]

colnames(curated_data)=c(ESS_column,'Remove')
curated_data$gsw=NA

curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
