library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2020'))
load('3_QC_Reflectance_data.Rdata',verbose=TRUE)

SampleDetails=Reflectance

SampleDetails$Site_name=SampleDetails$`Location Name`
SampleDetails$Dataset_name="Rogers_et_al_2020"
SampleDetails$Species=paste(SampleDetails$`Latin Genus`,SampleDetails$`Latin Species`)
SampleDetails$Sun_Shade="Sun"### ????????????????? Is that correct Kim or Alistair???????????????????
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Wild"
SampleDetails$LMA
SampleDetails$Narea
SampleDetails$Nmass
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA

SampleDetails=SampleDetails[SampleDetails$SampleID%in%Bilan$SampleID,]
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")
Reflectance=Reflectance[,c("SampleID","Spectrometer","Leaf_clip","Reflectance")]
save(Reflectance,file="3_QC_Reflectance_data.Rdata")