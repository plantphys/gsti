library(here)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2022'))
SampleDetails=read.csv("PA_2022_SampleDetails.csv")

SampleDetails$Site_name=substr(x = SampleDetails$Site,start = 4,stop = 7)
SampleDetails$Dataset_name="Lamour_et_al_2022"
SampleDetails$Species=SampleDetails$Genus_species
SampleDetails$Phenological_stage="Mature"
SampleDetails[SampleDetails$Vertical_Level%in%c(1,2),"Sun_Shade"]="Sun"
SampleDetails[SampleDetails$Vertical_Level%in%3:10,"Sun_Shade"]="Shade"
SampleDetails[SampleDetails$Site_name=="PNM"&is.na(SampleDetails$Vertical_Level),"Sun_Shade"]="Sun"
SampleDetails[SampleDetails$Site_name=="Gam","Sun_Shade"]="Shade"
SampleDetails[SampleDetails$Site_name=="Gam"&SampleDetails$Species=="Tabebuia rosea","Sun_Shade"]="Sun"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA=NA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA

SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
