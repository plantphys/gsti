library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Burnett_et_al_2021_2'))
Reflectance=read.csv('leaf_spectra.csv')
Metadata=read.csv('metadata.csv')
Reflectance=merge(x=Reflectance,y=Metadata,by="uniquefield")
Reflectance=Reflectance[Reflectance$Paired_Spectra=="leaf",]
unique(Reflectance$Instrument)

Reflectance$SampleID=Reflectance$uniquefield
Reflectance$Spectrometer="SE PSR+ 3500"
Reflectance$Leaf_clip="SVC LC-RP Pro"


Reflectance$Reflectance=I(as.matrix(Reflectance[,2:2152]))*100

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

save(Reflectance,file='3_QC_Reflectance_data.Rdata')








