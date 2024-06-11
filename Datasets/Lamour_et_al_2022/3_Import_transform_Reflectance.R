library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2022'))
Reflectance=read.csv('PA_2022_LeafReflectance.csv')
Reflectance$Spectrometer="SVC HR-1024i"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="SVC LC-RP Pro"
Reflectance$Spectra_trait_pairing="Same"
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)
Reflectance=merge(Reflectance,Bilan,by.x="SampleID",by.y="SampleID")
Reflectance$Reflectance=I(as.matrix(Reflectance[,18:2168]))

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
