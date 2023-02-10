library(spectratrait)
library(here)
path <- here()

setwd(file.path(path,'/Datasets/Davidson_et_al_2023'))

Reflectance <- read.csv('Spec_Data.csv')

Reflectance$Spectrometer="SVC XHR-1024i"
Reflectance$Leaf_clip="SVC LC-RP Pro"

Reflectance$Reflectance=I(as.matrix(Reflectance[,4:2154]))

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Leaf_clip")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')