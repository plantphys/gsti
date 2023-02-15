#--------------------------------------------------------------------------------------------------#
library(spectratrait)
library(dplyr)
library(stringr)
library(here)
path=here()
setwd(file.path(path,'/Datasets/Sexton_et_al_2021'))
getwd()

# options
spec_root <- file.path(path,'/Datasets/Sexton_et_al_2021')
gather_results <- TRUE #TRUE/FALSE
Input_file_basename <- "RawDataSetPoint"
output_spec_filename <- "leaf_spectra_1"

`%notin%` <- Negate(`%in%`)
#--------------------------------------------------------------------------------------------------#

# notes: Sexton et al collected new leaf spectra per plant/leaf
# at each A-Ci CI set point. For the raw spectra we compiled the full set
# but plant/leaf/set_point. However we will need to average these together
# to pair with the fitted data

#--------------------------------------------------------------------------------------------------#
# read in raw data files
if (gather_results) {
  # Create list of spectra folders
  full_file_list <- list.files(spec_root, paste0('^',Input_file_basename,"*.*csv",'$'), 
                               recursive = TRUE)
  full_file_list2 <- full_file_list
  full_file_list2 <- stringr::str_sort(full_file_list2, numeric = TRUE)

  # Grab all results
  input_data <- lapply(file.path(spec_root, full_file_list2), read.csv, header = TRUE) %>% 
    bind_rows(.id = 'file_number')
  head(input_data)[,1:31]
  
  nonspec <- input_data[,1:31]
  spec <- data.frame(SetPoint=input_data[,1], PlantNum=input_data$Plant,
                     input_data[,which(names(input_data) %notin% names(nonspec))])
  orig_wavelengths <- names(spec[,3:dim(spec)[2]])
  orig_wavelengths <- gsub("R","",orig_wavelengths)
  orig_wavelengths_num <- round(as.numeric(orig_wavelengths),5)
  new_waves <- paste0("Wave_",orig_wavelengths)
  
  temp <- spec[,3:dim(spec)[2]]
  colnames(temp) <- new_waves
  head(temp)[,1:10]
  
  spec2 <- data.frame(spec[,1:2],temp)
  rm(orig_wavelengths, temp)
  
  # re-organize data
  spec2$sampleID <- paste0(spec2$SetPoint,"_",spec2$PlantNum)
  spec3 <- spec2 %>%
    select(sampleID, SetPoint, PlantNum, starts_with("Wave_"))
  head(spec3)[,1:10]

}
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# write out raw concatenated spectra before further spectral post-processing
if (gather_results) {
  write.csv(x = spec3, file = file.path(spec_root, paste0(output_spec_filename,".csv")), 
            row.names = F)
} else {
  spec3 <- read.csv(file = file.path(spec_root, paste0(output_spec_filename,".csv")), 
                            header=T)
}
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
### Create spectra summary figure
cexaxis <- 1.5
cexlab <- 1.8
ylim <- 105


waves <- names(spec3[,4:dim(spec3)[2]])
waves_num <- round(as.numeric(gsub("Wave_","",waves)))
plot(waves_num)
spectra <- as.matrix(spec3[4:dim(spec3)[2]])

png(file = file.path(spec_root, paste0(output_spec_filename,".png")),height=3000,
    width=4300, res=340)
par(mfrow=c(1,1), mar=c(4.5,5.0,0.3,0.4), oma=c(0.3,0.9,0.3,0.1)) # B, L, T, R
matplot(waves_num,t(spectra), type = "l", lty = 1, xlab="Wavelength (nm)", ylab = "Reflectance (%)",
        ylim=c(0,95))
box(lwd=2.2)
dev.off()
#--------------------------------------------------------------------------------------------------#


# EOF