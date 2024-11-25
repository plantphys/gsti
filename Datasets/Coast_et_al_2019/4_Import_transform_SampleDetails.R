library(here)
path=here()
setwd(file.path(path,'/Datasets/Coast_et_al_2019'))

## Importing SampleInfo
SampleDetails=read.csv("SampleInfo.csv")
Reflectance=read.csv("Coast_et_al_2019.csv")
#Merging Reflectance and SampleInfo to gather information not present in both files
SampleDetails=merge(x=Reflectance[,1:8],y=SampleDetails,by="ID",all.x=TRUE)
SampleDetails$SampleID=SampleDetails$ID
SampleDetails$Site_name=SampleDetails$Place.x

SampleDetails$Dataset_name="Coast_et_al_2019"
SampleDetails$Species="Triticum aestivum"

  
SampleDetails$Phenological_stage
SampleDetails$"Sun_Shade"="Sun"
SampleDetails[SampleDetails$Measurement=="Low Light","Sun_Shade"]="Shade"

SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Agricultural"

SampleDetails$Soil="Pot"
SampleDetails[SampleDetails$Experiment==3,"Soil"]="Managed"

SampleDetails$LMA=SampleDetails$Q2_LMA
SampleDetails$Narea=SampleDetails$N_area
SampleDetails$Nmass=SampleDetails$N_mg
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA
SampleDetails$Chl=NA

SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]
SampleDetails=SampleDetails[-which(is.na(SampleDetails$Phenological_stage)),]
save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
