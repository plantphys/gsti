library(spectratrait)
library(here)
path=here()
setwd(file.path(path,'/Datasets/Barnes_et_al_2017'))


spectra=read.csv('9_processed_hyperspectral_wide.csv')
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)

## The unique id is not the same between file so 
## I combine using the values of Vcmax and Jmax..
## Uggly, but, Hey, it works!

spectra$VcmaxJmax=paste(substr(spectra$Vcmax,1,6),substr(spectra$Jmax,1,6))
Bilan$VcmaxJmax=paste(substr(Bilan$Vcmax,1,6),substr(Bilan$Jmax,1,6))

spectra=merge(x=spectra,y=Bilan,by.x = 'VcmaxJmax',by.y='VcmaxJmax')
spectra=data.frame(SampleID=spectra$uniqueID,
                        dataset='Barnes_et_al_2017',
                        Species='Populus deltoides',
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
                        Spectra=I(as.matrix(spectra[,10:2160]*100)))## Reflectance in % (0-100)
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)


save(spectra,file='3_Spectra_traits.Rdata')
