library(here)
library(readxl)
path=here()
## I downloaded this dataset from : 

source(paste(path,'/R/Correspondance_tables_ESS.R',sep=''))
setwd(paste(path,'/Datasets/Rogers_et_al_2020',sep=''))

original_data=read_xlsx('Seward_2019_Aci_raw_data.xlsx',sheet=2)
curated_data=original_data[,c("Sample_ID", "Sample_ID","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf","QC")]

colnames(curated_data)=c(ESS_column,'QCauthors')

curated_data$Obs=NA
curated_data=as.data.frame(curated_data)
## Adding a 'Obs' information to the dataset
for(SampleID in curated_data$SampleID){
  curated_data[curated_data$SampleID==SampleID,'Obs']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
}

## Adding a numeric SampleID
curated_data$SampleID_num=as.numeric(as.factor(paste(curated_data$SampleID,curated_data$Replicate)))

save(curated_data,file='0_curated_data.Rdata')
