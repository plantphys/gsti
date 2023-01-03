library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2022'))
spectra=read.csv('PA_2022_LeafReflectance.csv')
leaf_description=read.csv('PA_2022_SampleDetails.csv')
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


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
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)


save(spectra,file='3_Spectra_traits.Rdata')
