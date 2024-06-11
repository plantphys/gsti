library(here)
library(spectratrait)
library(readxl)
path=here()
setwd(file.path(path,'/Datasets/Yan_et_al_2021'))
Reflectance=read_xlsx(path = 'Yan et al., 2021. NPH. Spectra-Vcmax25 data.xlsx',sheet=2)
Reflectance$SampleID=Reflectance$`Leaf Code`
Reflectance$Spectrometer="SVC HR-1024i"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="SVC LC-RP Pro"
Reflectance$Spectra_trait_pairing="Same"
Reflectance$Reflectance=I(as.matrix(cbind(matrix(data = NA,nrow = nrow(Reflectance),ncol = 50),Reflectance[,10:2110])))

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

save(Reflectance,file='3_QC_Reflectance_data.Rdata')

