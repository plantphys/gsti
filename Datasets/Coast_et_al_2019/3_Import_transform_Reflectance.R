library(here)
library(spectratrait)
path=here()

## This dataset was sent by O. Atkin and O. Coast

setwd(file.path(path,'/Datasets/Coast_et_al_2019'))

Reflectance=read.csv(file = "Coast_et_al_2019.csv",na.strings = "NA")
Reflectance$SampleID=Reflectance$ID
Reflectance$Spectrometer="ASD FieldSpec 4"
Reflectance$Leaf_clip="ASD Leaf Clip"
Reflectance$Reflectance=I(as.matrix(Reflectance[,9:2159]))

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500) 

## I remove spectra with a very high reflectance

hist(Reflectance$Reflectance[,"Reflectance.X800"])
hist(Reflectance$Reflectance[,"Reflectance.X500"])
f.plot.spec(Z = Reflectance[Reflectance$Reflectance[,"Reflectance.X500"]>11,"Reflectance"],wv = 350:2500) 
Reflectance=Reflectance[Reflectance$Reflectance[,"Reflectance.X500"]<11,]

hist(Reflectance$Reflectance[,"Reflectance.X1000"])


f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500) 
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Leaf_clip")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
