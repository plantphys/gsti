## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/plantphys/spectratrait

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Cui_et_al_2025' folder where the data is located
setwd(file.path(path,'/Datasets/Cui_et_al_2025'))

# load the original reflectance data
Original_data=read.csv('Reflectance.csv')
Reflectance=data.frame()
for(SampleID in unique(Original_data$SampleID)){
  Wavelength_line=(Original_data[Original_data$SampleID==SampleID,"Wavelength"])
  Reflectance_line=(Original_data[Original_data$SampleID==SampleID,"pc_Reflectance"])
  #plot(x=Wavelength_line,y=Reflectance_line,ylim=c(0,100))
  interpolated_R=approx(x = Wavelength_line,y=Reflectance_line,xout = 350:2500)$y
  #lines(x=350:2500,y=interpolated_R,col="green")
  Reflectance=rbind.data.frame(Reflectance,cbind.data.frame(SampleID,matrix(data = interpolated_R,nrow = 1,dimnames = list(SampleID,350:2500))))
}
 
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
Reflectance$Spectra_trait_pairing="Same"


# Importing the wavelengths from 350 nm to 2500 nm and storing them into a matrix in the Reflectance dataframe
# The matrix needs to be 2151 columns wide. If the reflectance data covers a narrower range than 350 - 2500 nm, you ll need to put NA in the missing wavelengths
# Note that the reflectance has to be expressed in percent from 0 to 100
Reflectance$Reflectance=I(as.matrix(Reflectance[,2:2152]))

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

# Keeping only the SampleID, Spectrometer, Probe_type, Probe_model, and Spectra_trait_pairing columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]

# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
