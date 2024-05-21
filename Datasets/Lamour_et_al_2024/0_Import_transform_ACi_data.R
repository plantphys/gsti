library(here)
path=here()
## Dataset not yet available on Ngee tropics

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Lamour_et_al_2024'))

original_data=read.csv('Brazil_2023_Aci_data.csv')
curated_data=original_data[,c("SampleID", "record","A","Ci","CO2s","CO2r","gsw","Patm","Qin","RHs","Tleaf","Remove")]

colnames(curated_data)=c(ESS_column,'Remove')

curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
