## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/plantphys/spectratrait
library(spectacles) # Available on cran
library(asdreader) #Available on cran

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Vilas_Boas_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Vilas_Boas_et_al_2024'))

# Looking for all the .asd files within the folder
ls_files=dir(recursive = TRUE)
ls_asd_files=ls_files[which(grepl(x=ls_files,pattern=".asd",fixed=TRUE))]

# Extraction the leaf SampleID and measurement repetition from the file names
SampleID_rep=sub("\\.asd$", "", basename(ls_asd_files))
SampleID=sapply(strsplit(SampleID_rep,split = '_'),'[[', 1)
rep=sapply(strsplit(SampleID_rep,split = '_'),'[[', 2)

# Changing the SampleID to uppercase so is is consistent for all Samples
SampleID=toupper(SampleID)

#Importing the .asd files using the package library(spectacles)
ls_issue=c()
spectra=matrix(ncol = 2151,nrow = length(ls_asd_files))
#pdf(file='0_QA_QC_Reflectance.pdf')
for(i in 1:length(ls_asd_files)){
  print(ls_asd_files[i])
  #try({get_metadata(ls_asd_files[i])})
  test=try({spectra[i,]=get_spectra(ls_asd_files[i])
          leaf_spec=Spectra(wl = 350:2500,nir =spectra[i,],id = ls_asd_files[i])
          leaf_spec_corrected=splice(leaf_spec)
           plot(leaf_spec,main=ls_asd_files[i],ylim=c(0,1),ylab='Reflectance',col="black")
           lines(y=leaf_spec_corrected@nir[1,],x=350:2500,col="red")})
  if(is.null(dim(test))){ls_issue=c(ls_issue,ls_asd_files[i])}
}
#dev.off()
spectra=Spectra(wl = 350:2500,nir = spectra,id = ls_asd_files)
spectra$File=ls_asd_files
spectra$SampleID=SampleID
spectra$Repetition=rep
ls_bad_spectra=c("LMF24050", "LMF24051", "LMF24150","LMF24151")
spectra=spectra[!spectra$SampleID%in%ls_bad_spectra,]

## Using the spectacles library to do a splice correction
## i.e to correct the "jumps" on the reflectance that are due to small differences between the internal sensors of the ASD
spectra_jump_corrected=splice(spectra)


## Displaying all the spectra, without and with correction
f.plot.spec(Z = spectra@nir,wv = spectra@wl) # A small jump should be visible around 1000 nm
f.plot.spec(Z = spectra_jump_corrected@nir,wv = spectra_jump_corrected@wl) # The jump should not be visible anymore

## Averaging the spectra by leaf
spectra_leaf=aggregate_spectra(obj = spectra_jump_corrected,fun = mean,id='SampleID')

## Creating a dataframe with the GSTI format

Reflectance=spectra_leaf@data
Reflectance=cbind.data.frame(Reflectance,spectra_leaf@nir)

# Informing the spectrometer model used used (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD FieldSpec 4, ASD FieldSpec 4 Hi-Res,...)
Reflectance$Spectrometer="ASD FieldSpec 3"

# Type of probe used to measure the spectra. Is it a "Leaf clip"? "Integating sphere"? Or an "imager"?
Reflectance$Probe_type="Leaf clip"

# Reference for the probe used (SVC LC-RP, SVC LC-RP Pro, ASD Leaf Clip, ...)
Reflectance$Probe_model="ASD Leaf Clip"

# a column that explains how the gas exchange information is paired with the spectral data. 
# If the gas exchange and leaf spectra were measured in the same leaf, choose “Same”. 
# If they were measured in similar leaves, choose “Similar”. 
# Finally, if hyperspectral data was measured at the plant scale (and paired to gas exchange at the leaf scale), choose “Plant scale”.
Reflectance$Spectra_trait_pairing="Same"


# Importing the wavelengths from 350 nm to 2500 nm and storing them into a matrix in the Reflectance dataframe
# The matrix needs to be 2151 columns wide. If the reflectance data covers a narrower range than 350 - 2500 nm, you ll need to put NA in the missing wavelengths
# Note that the reflectance has to be expressed in percent from 0 to 100
Reflectance$Reflectance=I(as.matrix(Reflectance[,4:2154]*100))

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

# Keeping only the SampleID, Spectrometer, Probe_type, Probe_model, and Spectra_trait_pairing columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]

# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
