library(here)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2024'))
SampleDetails=read.csv("SampleInfo.csv")
TreeInfo=read.csv("TreeInfo.csv")
SampleDetails=merge(x = SampleDetails,y=TreeInfo,by ="TreeID" )

SampleDetails$Site_name="Bionte"
SampleDetails$Dataset_name="Lamour_et_al_2024"
SampleDetails$Species=SampleDetails$species
SampleDetails$Phenological_stage="Mature"
SampleDetails$Sun_Shade="Sun"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA=NA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA

SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())
