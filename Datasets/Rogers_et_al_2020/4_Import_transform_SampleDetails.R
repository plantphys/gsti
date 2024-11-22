library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2020'))
load('3_QC_Reflectance_data.Rdata',verbose=TRUE)

SampleDetails=Reflectance

SampleDetails$Site_name=SampleDetails$`Location Name`
SampleDetails$Dataset_name="Rogers_et_al_2020"
SampleDetails$Species=paste(SampleDetails$`Latin Genus`,SampleDetails$`Latin Species`)
SampleDetails$Sun_Shade="Sun"
SampleDetails$Phenological_stage="Mature"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA
SampleDetails$Narea
SampleDetails$Nmass
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA
SampleDetails$Chl=NA

SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

## Checking the dataset
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
