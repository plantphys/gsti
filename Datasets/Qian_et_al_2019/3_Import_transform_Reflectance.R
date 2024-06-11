library(here)
library(spectratrait)
path=here()

setwd(file.path(path,'/Datasets/Qian_et_al_2019'))
Reflectance=read.csv('Reflectance_data.csv')

Reflectance$Spectrometer="ASD FieldSpec Pro"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="ASD Leaf Clip"
Reflectance$Spectra_trait_pairing="Same"
Reflectance$SampleID=tolower(paste(Reflectance$Species_JL," c",Reflectance$Samples.ID_JL,sep=""))

Reflectance$Reflectance=I(as.matrix(Reflectance[,10:2160]))*100

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

# Keeping only the "SampleID","Reflectance","Spectrometer","Probe_type","Probe_model", and "Spectra_trait_pairing" columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
