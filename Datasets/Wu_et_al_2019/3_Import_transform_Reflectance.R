library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Wu_et_al_2019'))
Reflectance=read.csv('Wu et al. 2019 spectra panama.csv')

Reflectance$SampleID=Reflectance$BNL_UID
Reflectance$Spectrometer="SVC HR-1024i"
Reflectance$Leaf_clip="SVC LC-RP Pro"
Reflectance$Reflectance=I(as.matrix(Reflectance[,11:2161]*100))
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)


save(Reflectance,file='3_QC_Reflectance_data.Rdata')

