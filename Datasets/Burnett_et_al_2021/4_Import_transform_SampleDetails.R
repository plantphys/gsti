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
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA
SampleDetails$Narea
SampleDetails$Nmass
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA


SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())
