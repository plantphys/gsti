library(spectratrait)
library(here)
path <- here()

setwd(file.path(path,'/Datasets/Davidson_et_al_2023'))

Reflectance <- read.csv('Spec_Data.csv')

Reflectance$Spectrometer="SVC HR-1024i"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="SVC LC-RP Pro"
Reflectance$Spectra_trait_pairing="Same"


Reflectance$Reflectance=I(as.matrix(Reflectance[,4:2154]))

#I remove the duplicated sample
SampleID_duplicated=Reflectance[which(duplicated(Reflectance$SampleID)),"SampleID"]
Reflectance=Reflectance[!Reflectance$SampleID%in%SampleID_duplicated,]

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')