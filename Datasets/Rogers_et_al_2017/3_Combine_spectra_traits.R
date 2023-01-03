library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2017'))
load('2_Result_ACi_fitting.Rdata',verbose=TRUE)


############# Code from Shawn Serbin #################
# NGEE Arctic Leaf Spectral Reflectance and Transmittance Data 2014 to 2016 Utqiagvik (Barrow) Alaska
ecosis_id <- "bf41fff2-8571-4f34-bd7d-a3240a8f7dc8"
spectra <- get_ecosis_data(ecosis_id = ecosis_id)

# clean up
spectra[spectra==-9999]=NA
######################




spectra=merge(x=spectra,y=Bilan,by.x = 'Sample_ID',by.y='SampleID')

spectra=data.frame(SampleID=spectra$SampleID,
                        dataset='Rogers_et_al_2017',
                        Species=paste(spectra$`Latin Genus`,spectra$`Latin Species`),
                        N_pc=spectra$N_mass_g_g,
                        Na=spectra$N_area_g_m2,
                        LMA=spectra$LMA_g_m2,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=spectra$JmaxRef,
                        Tp25=spectra$TpRef,
                        Tleaf_ACi=spectra$Tleaf,
                        Spectra=I(as.matrix(spectra[,36:2186])))## Reflectance in % (0-100)
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)


save(spectra,file='3_Spectra_traits.Rdata')
