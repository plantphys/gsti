library(LeafGasExchange)
library(spectratrait)
library(here)
path=here()
setwd(paste(path,'/Datasets/Burnett_et_al_2021',sep=''))


spectra=read.csv('leaf_spectra.csv')
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


spectra=merge(x=spectra,y=Bilan,by.x = 'Sample_ID',by.y='SampleID')
spectra=data.frame(SampleID=spectra$Sample_ID,
                        dataset='Burnett_et_al_2019',
                        Species='Quercus coccinea',
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
                        Spectra=I(as.matrix(spectra[,2:2152]*100))) ## Reflectance in % (0-100)
library(spectratrait)
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)


save(spectra,file='3_Spectra_traits.Rdata')
