library(here)
library(readxl)
library(spectratrait)

path=here()
setwd(file.path(path,'/Datasets/Meacham_Hensold_et_al_2019'))
load("2_Fitted_ACi_data.Rdata")
Reflectance <- read.csv("Reflectance_data.csv")

Reflectance$Spectrometer="ASD FieldSpec 4 Hi-Res"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="ASD Leaf Clip"
Reflectance$Spectra_trait_pairing="Same"
Reflectance$SampleID=paste(Reflectance$Year, Reflectance$Date, Reflectance$Name, sep = " ")
Reflectance$Reflectance=I(as.matrix(as.data.frame(Reflectance[,6:2156])))*100

f.plot.spec(Z = Reflectance$Reflectance, wv = 350:2500)


save(Reflectance,file = '3_QC_Reflectance_data.Rdata')
