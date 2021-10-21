library(here)
here()
## I downloaded this dataset from :

source('R/Correspondance_tables_ESS.R')

ls_files=dir(recursive = TRUE)
ls_files_Aci=ls_files[which(grepl(x=ls_files,pattern="RawDataSetPoint",ignore.case = TRUE))]
original_data=do.call("rbind", apply(X = as.matrix(ls_files_Aci),FUN = read.csv,MARGIN = 1))

curated_data=original_data
curated_data=curated_data[,c('Plant','Obs','A','Ci','CO2s','CO2r',"gsw","gsw","Qin","Qin","Tleaf")]
colnames(curated_data)=ESS_column
curated_data$Patm=NA
curated_data$RHs=NA
curated_data$SampleID_num=as.numeric((curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
