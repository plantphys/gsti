library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2024'))
Reflectance=read.csv('Brazil_2023_Reflectance_data.csv')
Reflectance$Spectrometer="ASD FieldSpec 3"
Reflectance$Leaf_clip="ASD Leaf Clip"
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)
Reflectance=merge(Reflectance,Bilan,by.x="SampleID",by.y="SampleID")
Reflectance$Reflectance=I(as.matrix(Reflectance[,17:2167]))*100

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

save(Reflectance,file='3_QC_Reflectance_data.Rdata')
