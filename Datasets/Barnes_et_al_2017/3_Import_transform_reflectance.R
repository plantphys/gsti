library(spectratrait)
library(here)
path=here()
setwd(file.path(path,'/Datasets/Barnes_et_al_2017'))


Reflectance=read.csv('9_processed_hyperspectral_wide.csv')
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)

## The unique id is not the same between file so 
## I combine using the values of Vcmax and Jmax..
## Uggly, but, it works!

Reflectance$VcmaxJmax=paste(substr(Reflectance$Vcmax,1,6),substr(Reflectance$Jmax,1,6))
Bilan$VcmaxJmax=paste(substr(Bilan$Vcmax,1,6),substr(Bilan$Jmax,1,6))

Reflectance=merge(x=Reflectance,y=Bilan,by.x = 'VcmaxJmax',by.y='VcmaxJmax')

Reflectance$Spectrometer="ASD FieldSpec 3"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="ASD Leaf Clip"
Reflectance$Spectra_trait_pairing="Same"

Reflectance$Reflectance=I(as.matrix(Reflectance[,10:2160]))*100

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')