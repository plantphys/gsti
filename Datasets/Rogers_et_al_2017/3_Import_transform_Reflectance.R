library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2017'))
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)


############# Code from Shawn Serbin #################
# NGEE Arctic Leaf Spectral Reflectance and Transmittance Data 2014 to 2016 Utqiagvik (Barrow) Alaska
ecosis_id <- "bf41fff2-8571-4f34-bd7d-a3240a8f7dc8"
Reflectance <- get_ecosis_data(ecosis_id = ecosis_id)

# clean up
Reflectance[Reflectance==-9999]=NA
Reflectance=Reflectance[Reflectance$`Foreoptic Specifications`!="SVC_Integrating_Sphere",]
which(duplicated(Reflectance$BNL_Barcode))
unique(Reflectance$`Foreoptic Specifications`)

######################

Reflectance$Spectrometer="SVC HR-1024i"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="SVC LC-RP Pro"
Reflectance$Spectra_trait_pairing="Same"
Reflectance[Reflectance$`Foreoptic Specifications`=="Fiber_1_LC_RP","Probe_model"]="SVC LC-RP"
Reflectance$SampleID=Reflectance$Sample_ID
Reflectance$Reflectance=I(as.matrix(Reflectance[,36:2186]))
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)
save(Reflectance,file="3_QC_Reflectance_data.Rdata") ## Note that this file is used and modified in 4_Import_transform_SampleDetails.R

