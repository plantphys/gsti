library(spectratrait)
library(here)
path=here()
setwd(file.path(path,'/Datasets/Burnett_et_al_2021'))

Reflectance=read.csv('leaf_spectra.csv')
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)


#Reflectance=merge(x=Reflectance,y=Bilan,by.x = 'Sample_ID',by.y='SampleID')
Reflectance$Spectrometer="SE PSR+ 3500"
Reflectance$Leaf_clip="SVC LC-RP Pro"
Reflectance$SampleID=Reflectance$Sample_ID

Reflectance$Reflectance=I(as.matrix(Reflectance[,2:2152]))*100

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Leaf_clip")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')