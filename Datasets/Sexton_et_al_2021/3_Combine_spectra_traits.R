spectra=read.csv('RawDataSetPoint1.csv')
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


spectra=merge(x=spectra,y=Bilan,by.x = 'Plant',by.y='SampleID')
WV=colnames(spectra[,31:1054])
WV=as.numeric(substr(WV,2,10))

############################
### I stopped here, the raw reflectance are given. Need to reprocess the spectra
####
spectra=data.frame(SampleID=spectra$Plant,
                        dataset='Sexton_et_al_2021',
                        Species='Nicotiana tabacum',
                        N_pc=NA,
                        Na=NA,
                        LMA=NA,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=spectra$JmaxRef,
                        Tp25=spectra$TpRef,
                        Spectra=I(as.matrix(spectra[,10:2160])))
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)
library(spectratrait)

save(spectra,file='3_Spectra_traits.Rdata')
