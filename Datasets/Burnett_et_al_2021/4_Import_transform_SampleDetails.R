library(spectratrait)
library(here)
path=here()
setwd(file.path(path,'/Datasets/Burnett_et_al_2021'))

SampleDetails=read.csv("seasonal-measurements-of-photosynthesis-and-leaf-traits-in-scarlet-oak.csv")


SampleDetails$SampleID=SampleDetails$Sample_ID
SampleDetails$Site_name="BNL"
SampleDetails$Dataset_name="Burnett_et_al_2021"
SampleDetails$Species="Quercus coccinea"
SampleDetails$Sun_Shade="Sun"
SampleDetails[SampleDetails$Measurement.Date=="20190529","Phenological_stage"]="Young"
SampleDetails[SampleDetails$Measurement.Date%in%c("20190614","20190626","20190725","20190821","20190911","20190925"),"Phenological_stage"]="Mature"
SampleDetails[SampleDetails$Measurement.Date=="20191030","Phenological_stage"]="Old"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA
SampleDetails$Narea
SampleDetails$Nmass
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=SampleDetails$RWC
SampleDetails$Chl=NA


SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC","Chl")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
