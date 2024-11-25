library(here)
path=here()
setwd(file.path(path,'/Datasets/Ojo_et_al_2024'))


## Importing SampleInfo
load('3_QC_Reflectance_data.Rdata',verbose=TRUE)
SampleDetails=Reflectance

SampleDetails$Dataset_name="Ojo_et_al_2024"
SampleDetails[SampleDetails$Species=="Hordeum vulgare","Site_name"]="Waga_Waga"
SampleDetails[SampleDetails$Species=="Eucalyptus viminalis","Site_name"]="Waga_Waga"
SampleDetails$Phenological_stage="Mature"
SampleDetails$"Sun_Shade"="Sun"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Agricultural"

SampleDetails$Soil="Managed"
SampleDetails$LMA=SampleDetails$LMA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA
SampleDetails$Chl=NA

SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC","Chl")]
save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
