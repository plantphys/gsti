library(here)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2021'))

SampleDetails=read.csv("PA-SLZ_2020_SampleDetails.csv")
Chem_data=read.csv("PA-SLZ_2020_CHN_LMA_data.csv")
SampleDetails=merge(x=SampleDetails,y=Chem_data,by.x="SampleID",by.y="SampleID")

SampleDetails$Site_name="SLZ"
SampleDetails$Dataset_name="Lamour_et_al_2021"
SampleDetails$Species=SampleDetails$Species_Name
SampleDetails$Sun_Shade=NA
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA
SampleDetails$Narea
SampleDetails$Nmass
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC

SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())