library(here)
library(spectratrait)
path=here()
setwd(paste(path,'/Datasets/Lamour_et_al_2021',sep=''))
spectra=read.csv('PA-SLZ_2020_Reflectance.csv')
leaf_description=read.csv('PA-SLZ_2020_SampleDetails.csv')
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


spectra=merge(x=spectra,y=Bilan,by.x = 'SampleID',by.y='SampleID')
spectra=merge(x=spectra,y=leaf_description,by.x = 'SampleID',by.y='SampleID')

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
                        Vcmax25_JB=spectra$JB_VcmaxRef,
                        Vqmax25_JB=spectra$JB_VqmaxRef,
                        Tp25_JB=spectra$JB_TpRef,
                        Tleaf_ACi=spectra$Tleaf,
                        Spectra=I(as.matrix(spectra[,19:2169])))## Reflectance in % (0-100)
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)


save(spectra,file='3_Spectra_traits.Rdata')
