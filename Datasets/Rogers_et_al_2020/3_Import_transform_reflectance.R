library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2020'))
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)


############# Code from Shawn Serbin #################
# NGEE Arctic 2019 Leaf Spectral Reflectance Seward Peninsula Alaska
ecosis_id <- "dd3d1e06-9411-4b7a-a3bb-99657e6e9a0c"
Reflectance <- get_ecosis_data(ecosis_id = ecosis_id)

# clean up
Reflectance[Reflectance==-9999]=NA
######################

Reflectance$Spectrometer="SVC HR-1024i"
Reflectance$Leaf_clip="SVC LC-RP Pro"
Reflectance$Reflectance=I(as.matrix(Reflectance[,32:2182]))

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500) ## Checking if the reflectance looks correct

save(Reflectance,file='3_QC_Reflectance_data.Rdata') ## Note that this file is used and modified in 4_Import_transform_SampleDetails.R


