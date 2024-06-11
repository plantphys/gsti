library(spectratrait)
library(here)
path=here()
setwd(file.path(path,'/Datasets/Burnett_et_al_2021'))

Reflectance=read.csv('leaf_spectra.csv')
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)


#Reflectance=merge(x=Reflectance,y=Bilan,by.x = 'Sample_ID',by.y='SampleID')
Reflectance$Spectrometer="SE PSR+ 3500"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="SVC LC-RP Pro"
Reflectance$Spectra_trait_pairing="Same"

Reflectance$SampleID=Reflectance$Sample_ID

Reflectance$Reflectance=I(as.matrix(Reflectance[,2:2152]))*100

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')