library(spectratrait)
library(here)
setwd(file.path(here(),'Datasets/Albert_et_al_2018'))
spectra <- read.csv('Wu_etal_2019_spectra_brazil.csv')
spectra=merge(x=spectra,y=Bilan,by.x = 'BR_UID',by.y='SampleID')
WV=colnames(spectra[,11:2161])
WV=as.numeric(substr(WV,2,10))
spectra$Spectrometer="ASD FieldSpec Pro"
spectra$Leaf_clip="ASD Leaf Clip"
spectra$Reflectance=I(as.matrix(spectra[,11:2161]*100))
spectra$SampleID=spectra$BR_UID
f.plot.spec(Z = spectra$Reflectance,wv = 350:2500)

spectra=spectra[,c("SampleID","Reflectance","Spectrometer","Leaf_clip")]
save(spectra,file='3_QC_Reflectance_data.Rdata')


spectra[spectra$Growth.Environment=="Sunlit","Sun_Shade"]="Sun"
spectra[spectra$Growth.Environment=="Shaded","Sun_Shade"]="Shade"
spectra=data.frame(SampleID=spectra$BR_UID,
                        Dataset='Albert_et_al_2018',
                        Site_name="TNF",
                        Species=spectra$Species,
                        N_pc=NA,
                        Na=NA,
                        LMA=NA,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=spectra$JmaxRef,
                        Tp25=spectra$TpRef,
                        Tleaf_ACi=spectra$Tleaf,
                        Spectra=I(as.matrix(spectra[,11:2161]*100))) ## Reflectance in % (0 - 100)



save(spectra,file='3_Spectra_traits.Rdata')
