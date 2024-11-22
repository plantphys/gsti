## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)
library(spectrolab)
library(signal)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/plantphys/spectratrait

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Kyaw_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Kyaw_et_al_2024'))

# load the original reflectance data
original_data=read.csv('Leaf spectra data.csv',check.names = FALSE)
original_data=original_data[!is.na(original_data$'350.6'),]
WV=as.numeric(colnames(original_data[,6:983]))


# Convert into the spectrolab format to do the sensor correction
curated_data = as_spectra(original_data,name_idx=1,meta_idxs = 1:5)
curated_data = match_sensors(x=curated_data,splice_at = 993.1,interpolate_wvl = c(5,1))

Reflectance = data.frame()
pdf("3_QaQc_Reflectance.pdf")
for (i in 1:nrow(curated_data)){
  plot(curated_data[i,],ylim=c(0,100),main=curated_data[i,]$meta$SampleID)
  spec_interpolated=approx(x = WV, y = curated_data[i,]$value,xout = 350:2500)
  lines(x=WV,y=original_data[i,6:983])
  lines(x=350:2500,y=spec_interpolated$y,col="red",type="l")
  Reflectance=rbind.data.frame(Reflectance,spec_interpolated$y)
}
dev.off()

Reflectance$Reflectance=I(as.matrix(Reflectance))
Reflectance$SampleID=original_data$SampleID

# Informing the spectrometer model used used (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD FieldSpec 4, ASD FieldSpec 4 Hi-Res,...)
Reflectance$Spectrometer="SVC HR-1024i"

# Type of probe used to measure the spectra. Is it a "Leaf clip"? "Integrating sphere"? Or an "imager"?
Reflectance$Probe_type="Leaf clip"

# Reference for the probe used (SVC LC-RP, SVC LC-RP Pro, ASD Leaf Clip, ...)
Reflectance$Probe_model="SVC LC-RP Pro"

# a column that explains how the gas exchange information is paired with the spectral data. 
# If the gas exchange and leaf spectra were measured in the same leaf, choose “Same”. 
# If they were measured in similar leaves, choose “Similar”. 
# Finally, if hyperspectral data was measured at the plant scale (and paired to gas exchange at the leaf scale), choose “Plant scale”.
Reflectance$Spectra_trait_pairing="Similar"

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

# Keeping only the SampleID, Spectrometer, Probe_type, Probe_model, and Spectra_trait_pairing columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]

# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
