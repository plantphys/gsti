library(here)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2022'))
load(file = "2_Fitted_ACi_data.Rdata",verbose=TRUE)
SampleDetails=read.csv("PA_2022_SampleDetails.csv")

SampleDetails$Site_name=substr(x = SampleDetails$Site,start = 4,stop = 7)
SampleDetails$Dataset_name="Lamour_et_al_2022"
SampleDetails$Species=SampleDetails$Genus_species
SampleDetails$Sun_Shade=NA
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA=NA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA

SampleDetails=SampleDetails[SampleDetails$SampleID%in%Bilan$SampleID,]
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())