library(here)
path=here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2017'))
load('3_QC_Reflectance_data.Rdata',verbose=TRUE)
SampleDetails=Reflectance

SampleDetails$Site_name="Utqiagvik"
SampleDetails$Dataset_name="Rogers_et_al_2017"
SampleDetails$Species=paste(SampleDetails$`Latin Genus`,SampleDetails$`Latin Species`)
SampleDetails$Sun_Shade="Sun"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA=SampleDetails$LMA_g_m2
SampleDetails$Narea=SampleDetails$N_area_g_m2
SampleDetails$Nmass=SampleDetails$N_mass_mg_g
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA

SampleDetails=SampleDetails[SampleDetails$SampleID%in%Bilan$SampleID,]
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")


## Checking the dataset
source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())