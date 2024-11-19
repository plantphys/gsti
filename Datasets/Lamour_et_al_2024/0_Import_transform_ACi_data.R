library(here)
path=here()
## Dataset not yet available on Ngee tropics

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Lamour_et_al_2024'))

original_data=read.csv('Brazil_2023_Aci_data.csv')
curated_data=original_data[,c("SampleID", "record","A","Ci","CO2s","CO2r","gsw","Patm","Qin","RHs","Tleaf","Remove")]
curated_data$gsw=curated_data$gsw/1000
mean_gsw=tapply(curated_data$gsw,curated_data$SampleID,mean)
ls_sampleID_mmol=names(mean_gsw>10)
curated_data[curated_data$SampleID%in%ls_sampleID_mmol,"gsw"]=curated_data[curated_data$SampleID%in%ls_sampleID_mmol,"gsw"]/1000
colnames(curated_data)=c(ESS_column,'Remove')

curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
