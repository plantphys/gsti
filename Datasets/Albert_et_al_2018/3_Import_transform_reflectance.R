library(spectratrait)
library(here)
setwd(file.path(here(),'Datasets/Albert_et_al_2018'))
Reflectance <- read.csv('Wu_etal_2019_spectra_brazil.csv') ## I found the spectra in Wu's paper, this is not a mistake
load("2_Fitted_ACi_data.Rdata")
Reflectance=merge(x=Reflectance,y=Bilan,by.x = 'BR_UID',by.y='SampleID')
WV=colnames(Reflectance[,11:2161])
WV=as.numeric(substr(WV,2,10))
Reflectance$Spectrometer="ASD FieldSpec Pro"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="ASD Leaf Clip"
Reflectance$Spectra_trait_pairing="Same"
Reflectance$Reflectance=I(as.matrix(Reflectance[,11:2161]*100))
Reflectance$SampleID=Reflectance$BR_UID
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')

