library(here)
path=here()
## I downloaded this dataset from : 10.5440/1336809

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Rogers_et_al_2017'))

original_data=read.csv('NGEE-Arctic_A-Ci_curves_2012-2015.csv',skip = 8)
curated_data=original_data[,c("Sample_Barcode", "Sample_Barcode","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf","QC","Replicate")]

colnames(curated_data)=c(ESS_column,'QCauthors','Replicate')
curated_data[curated_data$Replicate==-9999,'Replicate']=1
curated_data$Record=NA
## Adding a 'Record' information to the dataset
for(SampleID in curated_data$SampleID){
  curated_data[curated_data$SampleID==SampleID,'Record']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
}

## Adding a numeric SampleID
curated_data$SampleID_num=as.numeric(as.factor(paste(curated_data$SampleID,curated_data$Replicate)))

save(curated_data,file='0_curated_data.Rdata')
