## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/plantphys/spectratrait

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Heckmann_et_al_2017' folder where the data is located
setwd(file.path(path,'/Datasets/Heckmann_et_al_2017'))

# Import the authors original reflectance raw data

original_data=t(read.csv("ASD_splice_corrected.csv",skip = 1,header = FALSE)) ## JL 20240903 Note that I opened the raw asd data with the ASD software ViewSpecPro to correct the biases between sensors and export the data
SampleID_spec=t(read.csv("ASD_splice_corrected.csv",header = FALSE)[1,])

Reflectance=data.frame(SampleID_spec=SampleID_spec[2:256],Reflectance=I(original_data[2:256,]*100))
ls_bad_spectra=c("ExpUrteAugust201400116.asd.sco")

Reflectance=Reflectance[!Reflectance$SampleID_spec%in%ls_bad_spectra,]
# Informing the spectrometer model used used (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD FieldSpec 4, ASD FieldSpec 4 Hi-Res,...)
Reflectance$Spectrometer="ASD FieldSpec 4 Hi-Res"

# Type of probe used to measure the spectra. Is it a "Leaf clip"? "Integrating sphere"? Or an "imager"?
Reflectance$Probe_type="Leaf clip"

# Reference for the probe used (SVC LC-RP, SVC LC-RP Pro, ASD Leaf Clip, ...)
Reflectance$Probe_model="ASD Leaf Clip"

# a column that explains how the gas exchange information is paired with the spectral data. 
# If the gas exchange and leaf spectra were measured in the same leaf, choose “Same”. 
# If they were measured in similar leaves, choose “Similar”. 
# Finally, if hyperspectral data was measured at the plant scale (and paired to gas exchange at the leaf scale), choose “Plant scale”.
Reflectance$Spectra_trait_pairing="Same"

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

# Adding the identifier of the gas exchange curve
SampleDetails=read.csv("table_heckmann2017.csv")
Reflectance=merge(x=Reflectance,y=SampleDetails[,c("FieldSpec_original_splice_corrected","Li6400.file")],by.x="SampleID_spec",by.y="FieldSpec_original_splice_corrected")
Reflectance$SampleID=Reflectance$Li6400.file

# Keeping only the SampleID, Spectrometer, Probe_type, Probe_model, and Spectra_trait_pairing columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]



# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
