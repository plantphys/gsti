library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2022'))
Reflectance=read.csv('PA_2022_LeafReflectance.csv')
Reflectance$Spectrometer="SVC XHR-1024i"
Reflectance$Leaf_clip="SVC LC-RP Pro"
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)
Reflectance=merge(Reflectance,Bilan,by.x="SampleID",by.y="SampleID")
Reflectance$Reflectance=I(as.matrix(Reflectance[,18:2168]))

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

save(Reflectance,file='3_QC_Reflectance_data.Rdata')


leaf_description=read.csv('PA_2022_SampleDetails.csv')



spectra=merge(x=spectra,y=Bilan,by.x = 'SampleID',by.y='SampleID')
spectra=merge(x=spectra,y=leaf_description,by.x = 'SampleID',by.y='SampleID')

spectra=data.frame(SampleID=spectra$SampleID,
                        dataset='Lamour_et_al_2022',
                        Species=spectra$Genus_species,
                        N_pc=NA,
                        Na=NA,
                        LMA=NA,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=spectra$JmaxRef,
                        Tp25=spectra$TpRef,
                        Tleaf_ACi=spectra$Tleaf,
                        Spectra=I(as.matrix(spectra[,18:2168])))## Reflectance in % (0-100)




