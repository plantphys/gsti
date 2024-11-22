library(spectratrait)
library(here)
path=here()
setwd(file.path(path,'/Datasets/Barnes_et_al_2017'))


Reflectance=read.csv('9_processed_hyperspectral_wide.csv')
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)

## The unique id is not the same between file so 
## I combine using the values of Vcmax and Jmax..
## Uggly, but, Hey, it works!

Reflectance$VcmaxJmax=paste(substr(Reflectance$Vcmax,1,6),substr(Reflectance$Jmax,1,6))
Bilan$VcmaxJmax=paste(substr(Bilan$Vcmax,1,6),substr(Bilan$Jmax,1,6))

SampleDetails=merge(x=Reflectance,y=Bilan,by.x = 'VcmaxJmax',by.y='VcmaxJmax')

SampleDetails$Site_name="Biosphere 2"
SampleDetails$Dataset_name="Barnes_et_al_2017"
SampleDetails$Species="Populus deltoides"
SampleDetails$Sun_Shade="Sun"
SampleDetails$Phenological_stage="Mature"
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
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
