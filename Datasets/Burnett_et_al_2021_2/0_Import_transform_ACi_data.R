library(here)
path=here()
## I downloaded this dataset from : https://ecosis.org/package/hyperspectral-leaf-reflectance--biochemistry--and-physiology-of-droughted-and-watered-crops

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Burnett_et_al_2021_2'))

original_data=read.csv('leaf_gas_exchange.csv')
curated_data=original_data[,c("uniquefield", "uniquefield","Asat","Ci","CO2s","CO2s","gs","gs","Qin","RHs","Tleaf")]

colnames(curated_data)=c(ESS_column)
curated_data$Record=NA
curated_data$CO2r=NA
curated_data$Patm=NA

curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
