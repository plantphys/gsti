## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/plantphys/spectratrait

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Montes_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Montes_et_al_2022'))

# load the original reflectance data
Reflectance=read.csv('ReflectanceFromAci.csv')

# Informing the spectrometer model used used (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD FieldSpec 4, ASD FieldSpec 4 Hi-Res,...)
Reflectance$Spectrometer="ASD FieldSpec 4"

# Type of probe used to measure the spectra. Is it a "Leaf clip"? "Integrating sphere"? Or an "imager"?
Reflectance$Probe_type="Leaf clip"

# Reference for the probe used (SVC LC-RP, SVC LC-RP Pro, ASD Leaf Clip, ...)
Reflectance$Probe_model="ASD Leaf Clip"

# a column that explains how the gas exchange information is paired with the spectral data. 
# If the gas exchange and leaf spectra were measured in the same leaf, choose “Same”. 
# If they were measured in similar leaves, choose “Similar”. 
# Finally, if hyperspectral data was measured at the plant scale (and paired to gas exchange at the leaf scale), choose “Plant scale”.
Reflectance$Spectra_trait_pairing="Same"

Reflectance$SampleID=paste(Reflectance$Cultivar,Reflectance$Rep)

# Importing the wavelengths from 350 nm to 2500 nm and storing them into a matrix in the Reflectance dataframe
# The matrix needs to be 2151 columns wide. If the reflectance data covers a narrower range than 350 - 2500 nm, you ll need to put NA in the missing wavelengths
# Note that the reflectance has to be expressed in percent from 0 to 100
Reflectance$Reflectance=I(as.matrix(Reflectance[,14:2164]))*100

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

# Keeping only the SampleID, Spectrometer, Probe_type, Probe_model, and Spectra_trait_pairing columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]

# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
