library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Wu_et_al_2019'))
spectra=read.csv('Wu et al. 2019 spectra panama.csv')
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


spectra=merge(x=spectra,y=Bilan,by.x = 'BNL_UID',by.y='SampleID')

spectra=data.frame(SampleID=spectra$BNL_UID,
                        dataset='Wu_et_al_2019',
                        Species=spectra$Species.1,
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
                        Spectra=I(as.matrix(spectra[,11:2161]*100))) ## Reflectance in % (0-100)
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)


save(spectra,file='3_Spectra_traits.Rdata')
