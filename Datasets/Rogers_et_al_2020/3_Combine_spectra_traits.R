library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2020'))
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


############# Code from Shawn Serbin #################
# NGEE Arctic 2019 Leaf Spectral Reflectance Seward Peninsula Alaska
ecosis_id <- "dd3d1e06-9411-4b7a-a3bb-99657e6e9a0c"
spectra <- get_ecosis_data(ecosis_id = ecosis_id)

# clean up
spectra[spectra==-9999]=NA
######################




spectra=merge(x=spectra,y=Bilan,by.x = 'SampleID',by.y='SampleID')

spectra=data.frame(SampleID=spectra$SampleID,
                        dataset='Rogers_et_al_2020',
                        Species=paste(spectra$`Latin Genus`,spectra$`Latin Species`),
                        N_pc=spectra$Nmass/10,
                        Na=spectra$Narea,
                        LMA=spectra$LMA,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=spectra$JmaxRef,
                        Tp25=spectra$TpRef,
                        Tleaf_ACi=spectra$Tleaf,
                        Spectra=I(as.matrix(spectra[,32:2182])))## Reflectance in % (0-100)
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)


save(spectra,file='3_Spectra_traits.Rdata')
