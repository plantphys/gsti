library(here)
library(spectratrait)
path <- here()
setwd(file.path(path,'/Datasets/Serbin_et_al_2019'))
## !! TODO CREATE FITTED ACI DATA
#load('2_Result_ACi_fitting.Rdata',verbose=TRUE) 


############# Code from Shawn Serbin #################
# UW-BNL NASA HyspIRI Airborne Campaign Leaf and Canopy Spectra and Trait Data
ecosis_id <- "dd94f09c-1794-44f4-82e9-a7ca707a1ec0"
spectra <- get_ecosis_data(ecosis_id = ecosis_id)

# clean up
spectra[spectra==-9999]=NA
######################

# save temp spec data as an Rdata file then load that file to merge with gasex data
#save()