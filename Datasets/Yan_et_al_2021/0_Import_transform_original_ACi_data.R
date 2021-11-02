library(here)
library(readxl)
path=here()
## Data from Jin Wu and Zhengbing Yan

source(paste(path,'/R/Correspondance_tables_ESS.R',sep=''))
setwd(paste(path,'/Datasets/Yan_et_al_2021',sep=''))

original_data=read_xlsx('Yan et al. 2021. NPH. ACi curve data_LiCor1_LiCor2_Licor4.xlsx',sheet = 2)
curated_data=original_data[,c("Leaf Code", "Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")]
colnames(curated_data)=c(ESS_column)
curated_data=curated_data[!is.na(curated_data$SampleID),]

original_data2=read_xlsx('Yan et al. 2021. NPH. ACi curve data_LiCor3.xlsx',sheet = 2)
curated_data2=original_data2[,c("Leaf Code", "Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")]
colnames(curated_data2)=c(ESS_column)
curated_data2=curated_data2[!is.na(curated_data2$SampleID),]

curated_data=rbind.data.frame(curated_data,curated_data2)

curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))
curated_data=as.data.frame(curated_data)
str(curated_data)
save(curated_data,file='0_curated_data.Rdata')
