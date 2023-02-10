library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2021'))
Reflectance=read.csv('PA-SLZ_2020_Reflectance.csv')
load('2_Fitted_Aci_data.Rdata',verbose=TRUE)


Reflectance=merge(x=Reflectance,y=Bilan,by.x = 'SampleID',by.y='SampleID')
Reflectance$Spectrometer="PSR+ 3500"
Reflectance$Leaf_clip="SVC LC-RP Pro"
Reflectance$Reflectance=I(as.matrix(Reflectance[,19:2169]))
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)
Reflectance=Reflectance[,c("SampleID","Spectrometer","Leaf_clip","Reflectance")]
save(Reflectance,file='3_Reflectance_data.Rdata')

spectra=merge(x=spectra,y=leaf_description,by.x = 'SampleID',by.y='SampleID')
leaf_description=read.csv('PA-SLZ_2020_SampleDetails.csv')
spectra=data.frame(SampleID=spectra$SampleID,
                        dataset='Lamour_et_al_2021',
                        Species=spectra$Species_Name,
                        N_pc=NA,
                        Na=NA,
                        LMA=NA,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=spectra$JmaxRef,
                        Tp25=spectra$TpRef,
                        Tleaf_ACi=spectra$Tleaf,
                        Spectra=I(as.matrix(spectra[,19:2169])))## Reflectance in % (0-100)




