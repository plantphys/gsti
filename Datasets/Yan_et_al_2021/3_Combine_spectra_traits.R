library(here)
library(spectratrait)
library(readxl)
path=here()
setwd(paste(path,'/Datasets/Yan_et_al_2021',sep=''))
spectra=read_xlsx(path = 'Yan et al., 2021. NPH. Spectra-Vcmax25 data.xlsx',sheet=2)
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


spectra=merge(x=spectra,y=Bilan,by.x = 'Leaf Code',by.y='SampleID')
spectra=data.frame(SampleID=spectra$SampleID,
                        dataset='Yan_et_al_2021',
                        Species=spectra$SpeciesName,
                        N_pc=NA,
                        Na=NA,
                        LMA=NA,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=spectra$JmaxRef,
                        Tp25=spectra$TpRef,
                        Spectra=I(as.matrix(spectra[,10:2110])))
f.plot.spec(Z = spectra$Spectra,wv = 400:2500)


save(spectra,file='3_Spectra_traits.Rdata')
