library(here)
path=here()
## I downloaded this dataset from :https://doi.org/10.15486/ngt/1866615.  https://doi.org/10.15486/ngt/1905761.  http://dx.doi.org/10.15486/ngt/1508118. and http://dx.doi.org/10.15486/ngt/1411867.

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Wu_et_al_2019'))

original_data=read.csv('2016ENSO_Panama_ACi.csv')
curated_data=original_data
curated_data=curated_data[,c('Barcode','Obs','Photo','Ci','CO2S','CO2R','Cond','Press','PARi','RH_S','Tleaf')]
colnames(curated_data)=ESS_column

original_data=read.csv('2017_SLZ_ACi_comp.csv')
curated_data2=original_data
curated_data2=curated_data2[,c('Sample_ID','Obs','Photo','Ci','CO2S','CO2R','Cond','Press','PARi','RH_S','Tleaf')]
colnames(curated_data2)=ESS_column

curated_data=rbind.data.frame(curated_data,curated_data2)
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
