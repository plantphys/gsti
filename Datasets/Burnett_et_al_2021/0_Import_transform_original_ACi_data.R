library(here)
path=here()
## I downloaded this dataset from: https://ecosis.org/package/seasonal-measurements-of-photosynthesis-and-leaf-traits-in-scarlet-oak
source(paste(path,'/R/Correspondance_tables_ESS.R',sep=''))
setwd(paste(path,'/Datasets/Burnett_et_al_2021',sep=''))


original_data=read.csv(file = 'raw_gas_exchange_li6400.csv')
curated_data=original_data
correspondance_table=LICOR6400toESS
colnames(correspondance_table)[1]='Sample_ID'

curated_data=curated_data[,colnames(curated_data)%in%colnames(correspondance_table)]
colnames(curated_data)=correspondance_table[1,colnames(curated_data)]

original_data=read.csv(file = 'raw_gas_exchange_li6800.csv')
colnames(correspondance_table)[1]='SampleID'
curated_data2=original_data
curated_data2=curated_data2[,colnames(curated_data2)%in%colnames(correspondance_table)]
colnames(curated_data2)=correspondance_table[1,colnames(curated_data2)]

curated_data=rbind.data.frame(curated_data,curated_data2)
curated_data$SampleID_num=as.numeric(factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')