library(here)
path=here()
## I downloaded this dataset from : http://dx.doi.org/10.15486/ngt/1781004

source(paste(path,'/R/Correspondance_tables_ESS.R',sep=''))
setwd(paste(path,'/Datasets/Lamour_et_al_2021',sep=''))

original_data=read.csv('PA-SLZ_2020_Aci_data.csv')
curated_data=original_data[,c("SampleID", "SampleID","A","Ci","CO2s","CO2r","SampleID","Patm","Qin","RHs","Tleaf","Remove")]

colnames(curated_data)=c(ESS_column,'Remove')
curated_data$gsw=NA
curated_data$Obs=NA
for(SampleID in curated_data$SampleID){
  curated_data[curated_data$SampleID==SampleID,'Obs']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
}

curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
