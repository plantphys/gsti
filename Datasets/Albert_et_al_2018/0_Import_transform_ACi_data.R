## I downloaded this dataset from :doi:10.5061/dryad.h83t0
library(here)
path=here()

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Albert_et_al_2018'))


ls_files=dir(recursive = TRUE)
ls_files_Aci=ls_files[which(grepl(x=ls_files,pattern="ACI_curve",ignore.case = TRUE))]

original_data=data.frame()
for(file in ls_files_Aci){
    print(file)
    data=read.csv(file = file)
    if(colnames(data)[3]=='tree_number'|colnames(data)[3]=='tree_'){colnames(data)[3]='Tree'}
    if(colnames(data)[4]=='light_environment'){colnames(data)[4]='sun_or_shade'}
    if(colnames(data)[6]=='leaf_no'){colnames(data)[6]='leaf_number'}
    data$file=strsplit(file, "/")[[1]][2]
   # print(colnames(data))
    original_data=rbind.data.frame(original_data,data)
}

curated_data=original_data
curated_data=curated_data[,c('file','Obs','Photo','Ci','CO2S','CO2R',"Cond","Press","PARi","RH_S","Tleaf")]
colnames(curated_data)=ESS_column
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
