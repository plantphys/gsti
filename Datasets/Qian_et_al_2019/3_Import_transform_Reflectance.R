library(here)
library(spectratrait)
path=here()

setwd(file.path(path,'/Datasets/Qian_et_al_2019'))
Reflectance=read.csv('Reflectance_data.csv')

Reflectance$Spectrometer="ASD FieldSpec Pro"
Reflectance$Leaf_clip="ASD Leaf Clip"
Reflectance$SampleID=tolower(paste(Reflectance$Species_JL," c",Reflectance$Samples.ID_JL,sep=""))

Reflectance$Reflectance=I(as.matrix(Reflectance[,9:2159]))*100

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

save(Reflectance,file='3_QC_Reflectance_data.Rdata')
