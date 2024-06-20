#--------------------------------------------------------------------------------------------------#
library(here)
library(spectratrait)
library(dplyr)
path <- here()
setwd(file.path(path,'/Datasets/Serbin_et_al_2019_hyspiri'))
getwd()
load('2_Fitted_ACi_data.Rdata',verbose=TRUE)

# download the spectra or load from saved file?
download_spec <- FALSE # TRUE/FALSE
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
if (download_spec) {
  print("*** Downloading spectra from Ecosis ***")
  ############# Get spectra! #################
  # UW-BNL NASA HyspIRI Airborne Campaign Leaf and Canopy Spectra and Trait Data
  ecosis_id <- "dd94f09c-1794-44f4-82e9-a7ca707a1ec0"
  spectra <- spectratrait::get_ecosis_data(ecosis_id = ecosis_id)
  
  # clean up
  spectra[spectra==-9999]=NA
  ######################
  
  # save the raw spec download to avoid downloading for testing
  save(spectra,file='3_raw_ecosis_spectra.Rdata')
  
} else {
  print("*** Loading saved spectra ***")
  load('3_raw_ecosis_spectra.Rdata',verbose=TRUE)
}
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# prepare spectra data for merging with gasex
temp_spec <- spectra %>%
  select("GasExchange_Leaf",contains("GE_"),contains("Latin"), 
         contains("Fitted_"),"CN_Ratio", "C_mass_g_g","N_mass_g_g",
         "LMA_gDW_m2",`350`:`2500`)

sampID <- paste0(temp_spec$GE_Sample_Name, "_", temp_spec$GE_Rep, "_", 
                 as.Date(as.character(temp_spec$GE_Measurement_Date), 
                         format = "%m/%d/%y"))
#as.Date(as.character("6/7/13"), format = "%m/%d/%y")
sampID[41]

# test
print(sampID[41])
Bilan$SampleID[which(as.character(Bilan$SampleID) %in% as.character(sampID[41]))]

# re-organize and clean up spectra info
spec_info <- temp_spec[,names(temp_spec) %notin% seq(350,2500,1)]
head(spec_info)

# insert matching sample ID field
spec_info$SampleID <- sampID

# re-organize
spec_info <- spec_info %>%
  select("SampleID",contains("Latin"),"GasExchange_Leaf",contains("GE_"), 
         contains("Fitted_"),"CN_Ratio", "C_mass_g_g","N_mass_g_g",
         "LMA_gDW_m2")

# get just the spectra - add wavelength names
spec_data <- temp_spec %>% 
  select(`350`:`2500`) %>%
  setNames(paste0('Wave_', names(.)))
head(spec_data)[1:10]

rm(temp_spec)

# put the spec data back together
spec_data_2 <- data.frame(spec_info, spec_data)
head(spec_data_2)[1:10]

# drop non gasex leaves
#drop_rows <- which(spec_data_2$GasExchange_Leaf=="no")
drop_rows <- which(spec_data_2$SampleID=="NA_NA_NA")
spec_data_3 <- spec_data_2[-drop_rows,]

# cleanup before merge
names(spec_data_3)[1:19]

spec_data_4 <- spec_data_3[,-c(4,10)]
head(spec_data_4)[1:20]

## MERGE - MAYBE THIS IS SUPPOSED TO HAPPEN SOMEWHERE ELSE??
Reflectance <- merge(spec_data_4,Bilan,by.x="SampleID",by.y="SampleID")
head(Reflectance)[1:20]

Reflectance <- Reflectance %>%
  select("SampleID_num","SampleID",contains("Latin"),contains("GE_"), 
         contains("Fitted_"),"CN_Ratio", "C_mass_g_g","N_mass_g_g",
         "LMA_gDW_m2","Vcmax25","Jmax25","TPU25","Rday25","StdError_Vcmax25",
         "StdError_Jmax25","StdError_TPU25","StdError_Rday25","Tleaf",
         "sigma","AIC","Model","Fitting_method",contains('Wave_'))
head(Reflectance)[1:20]

plot(Reflectance$Fitted_Vcmax,Reflectance$Vcmax25,xlim=c(40,400),
     ylim=c(40,400))
abline(0,1,lty=2)

plot(Reflectance$N_mass_g_g,Reflectance$Vcmax25, xlim=c(0,5),
     ylim=c(40,300))
plot(Reflectance$LMA_gDW_m2,Reflectance$Vcmax25)


plot(Reflectance$Vcmax25,Reflectance$Jmax25,xlim=c(40,400),
     ylim=c(40,400))
abline(0,1,lty=2)

# jvratio <- lm(formula = Reflectance$Jmax25~Reflectance$Vcmax25)
# summary(jvratio)
# 
# predict(jvratio)
# hist(residuals(jvratio))
# 
# remove <- which(as.vector(residuals(jvratio)) > 100 | 
#                   as.vector(residuals(jvratio)) < -100)
# remove
# 
# Reflectance2 <- Reflectance[-remove,]
# 
# plot(Reflectance2$Vcmax25,Reflectance2$Jmax25,xlim=c(40,400),
#      ylim=c(40,400))
# abline(0,1,lty=2)
# 
# jvratio <- lm(formula = Reflectance2$Jmax25~Reflectance2$Vcmax25)
# summary(jvratio)
# hist(residuals(jvratio))
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# TEMPORARY - NEED TO DO MORE QA/QC checks
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
#--------------------------------------------------------------------------------------------------#




# save(Reflectance,file='3_QC_Reflectance_data.Rdata')
# 
# load('2_Fitted_ACi_data.Rdata',verbose=TRUE)
# Reflectance=merge(Reflectance,Bilan,by.x="SampleID",by.y="SampleID")
# Reflectance$Reflectance=I(as.matrix(Reflectance[,18:2168]))
# 
# f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)
# 
# save(Reflectance,file='3_QC_Reflectance_data.Rdata')



#plot(seq(350,2500,1), nga_2013_barrow_leaf_spec_out[1,5:dim(nga_2013_barrow_leaf_spec_out)[2]])

# write.csv(nga_2013_barrow_leaf_spec_out, 
#           file = file.path(output_dir,"NGEE-Arctic_Utqiagvik_2013_Leaf_Spectral_Reflectance.csv"), 
#           row.names = F)
# rm(spec_info,spectra)


# save temp spec data as an Rdata file then load that file to merge with gasex data
#save()