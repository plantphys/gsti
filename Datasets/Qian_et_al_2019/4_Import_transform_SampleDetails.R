library(here)
path=here()
setwd(file.path(path,'/Datasets/Qian_et_al_2019'))

SampleDetails=read.csv("Reflectance_data.csv")
SampleDetails$SampleID=tolower(paste(SampleDetails$Species_JL," c",SampleDetails$Samples.ID_JL,sep=""))
SampleDetails$Site_name="CAS"
SampleDetails[SampleDetails$Species=="cotton","Site"]="Baoding"
SampleDetails$Dataset_name="Qian_et_al_2019"
SampleDetails$Species=SampleDetails$Species_full_JL
SampleDetails$Phenological_stage="Mature"
SampleDetails$Sun_Shade="Sun"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild"
SampleDetails[SampleDetails$Species=="cotton","Plant_type"]="Agricultural"
SampleDetails$Soil="Managed"
SampleDetails$LMA=NA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA
SampleDetails$Chl=NA

SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
