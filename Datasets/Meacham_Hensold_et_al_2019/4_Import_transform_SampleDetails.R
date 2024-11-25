library(here)
path=here()
setwd(file.path(path,'/Datasets/Meacham_Hensold_et_al_2019'))

load("2_Fitted_ACi_data.Rdata")
SampleDetails=Bilan
SampleDetails$Site_name="Urbana"
SampleDetails$Dataset_name="Meacham_Hensold_et_al_2019"
SampleDetails$Species="Nicotiana tabacum"
SampleDetails$Phenological_stage="Mature"
SampleDetails$Sun_Shade="Sun"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Agricultural"
SampleDetails$Soil="Managed"
SampleDetails$LMA=NA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA
SampleDetails$Chl=NA

SampleDetails=SampleDetails[SampleDetails$SampleID%in%Bilan$SampleID,]
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC","Chl")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
