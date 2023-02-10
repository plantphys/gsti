path=here()
setwd(file.path(path,'Datasets/Kumagai_et_al_2022'))
load("3_Reflectance_data.Rdata")

SampleDetails=Reflectance
SampleDetails$SampleID=SampleDetails$ID
SampleDetails$Site_name="Urbana"
SampleDetails$Dataset_name="Kumagai_et_al_2022"
SampleDetails$Species="Glycine max"
SampleDetails$Sun_Shade="Sun"
SampleDetails$Plant_type="Agricultural"
SampleDetails$Soil="Managed"
SampleDetails$LMA=NA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA

SampleDetails=SampleDetails[SampleDetails$SampleID%in%Bilan$SampleID,]
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")
