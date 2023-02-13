library(spectratrait)
library(here)
setwd(file.path(here(),'Datasets/Albert_et_al_2018'))
Reflectance <- read.csv('Wu_etal_2019_spectra_brazil.csv') ## I found the spectra in Wu's paper, this is not a mistake
load("2_Fitted_ACi_data.Rdata")
Reflectance=merge(x=Reflectance,y=Bilan,by.x = 'BR_UID',by.y='SampleID')
WV=colnames(Reflectance[,11:2161])
WV=as.numeric(substr(WV,2,10))
Reflectance$Spectrometer="ASD FieldSpec Pro"
Reflectance$Leaf_clip="ASD Leaf Clip"
Reflectance$Reflectance=I(as.matrix(Reflectance[,11:2161]*100))
Reflectance$SampleID=Reflectance$BR_UID
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Leaf_clip")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')

