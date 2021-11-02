library(LeafGasExchange)
library(here)
path=here()
setwd(paste(path,'/Datasets/Albert_et_al_2018',sep=''))
spectra=read.csv('Copy of Wu et al. 2019 spectra brazil.csv')
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


spectra=merge(x=spectra,y=Bilan,by.x = 'BR_UID',by.y='SampleID')
WV=colnames(spectra[,11:2161])
WV=as.numeric(substr(WV,2,10))


spectra=data.frame(SampleID=spectra$BR_UID,
                        dataset='Albert_et_al_2028',
                        Species=spectra$Species,
                        N_pc=NA,
                        Na=NA,
                        LMA=NA,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=spectra$JmaxRef,
                        Tp25=spectra$TpRef,
                        Spectra=I(as.matrix(spectra[,11:2161]*100))) ## Reflectance in % (0 - 100)
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)
library(spectratrait)

save(spectra,file='3_Spectra_traits.Rdata')
