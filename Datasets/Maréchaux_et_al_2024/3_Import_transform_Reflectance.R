## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/plantphys/spectratrait

# Load the signals library which is used to process the spectra
library(signal)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Maréchaux_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Maréchaux_et_al_2024'))

# Listing all the reflectance files
ls_files=dir(recursive = TRUE) ## This lists all the files that are in the same folder as this R code.

## Only keeping the reflectance files
ls_files=ls_files[which(grepl(x=ls_files,pattern="reflection"))]

## Importing and post processing the reflectance files
Reflectance=c()
#pdf("3_Qa_Qc_Reflectance.pdf")
for (file in ls_files){
  file_reflectance=read.csv(file = file,header = FALSE)
  file_reflectance$file=file
  plot(x=file_reflectance[,1],y=file_reflectance[,2]/100,xlab="Wavelength (nm)",ylab="Reflectance %",ylim=c(-0.05,1.05),main=file)
  ## Removing observations in the range 891.4 : 891.7 which exhibit a clear bias
  file_reflectance=file_reflectance[file_reflectance$V1<891.4|file_reflectance$V1>897.7,]
  WV=file_reflectance$V1
  filtered_R=sgolayfilt(file_reflectance[,2]/100,n=51,p=1)
  lines(x=WV,y=filtered_R,col="red")
  interpolated_R=as.data.frame(t(approx(x = WV,y=filtered_R,xout = 490:950)$y))
  interpolated_R$file=file
  Reflectance=rbind.data.frame(Reflectance,interpolated_R) 
  lines(x=490:950,y=interpolated_R[,1:461],col="green")
}
#dev.off()

# Extracting the SampleID nmae from the file name
Reflectance$SampleID=sub("\\.txt$", "", basename(Reflectance$file))
Reflectance$SampleID=sub("reflection","",Reflectance$SampleID)
Reflectance$Rep=substr(Reflectance$SampleID,1,1)
Reflectance$SampleID=substr(Reflectance$SampleID,3,nchar(Reflectance$SampleID))

# Calculating the mean spectra per leaf
Reflectance=aggregate(Reflectance[,1:461],by=list(Reflectance$SampleID),mean)
colnames(Reflectance)[1]="SampleID"

# Informing the spectrometer model used used (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD FieldSpec 4, ASD FieldSpec 4 Hi-Res,...)
Reflectance$Spectrometer="Ocean Optics JAZ spectrometer"

# Type of probe used to measure the spectra. Is it a "Leaf clip"? "Integrating sphere"? Or an "imager"?
Reflectance$Probe_type="Integrating sphere"

# Reference for the probe used (SVC LC-RP, SVC LC-RP Pro, ASD Leaf Clip, ...)
Reflectance$Probe_model="Ocean Optics SpectroClip-TR"

# a column that explains how the gas exchange information is paired with the spectral data. 
# If the gas exchange and leaf spectra were measured in the same leaf, choose “Same”. 
# If they were measured in similar leaves, choose “Similar”. 
# Finally, if hyperspectral data was measured at the plant scale (and paired to gas exchange at the leaf scale), choose “Plant scale”.
Reflectance$Spectra_trait_pairing="Same"

# Importing the wavelengths from 350 nm to 2500 nm and storing them into a matrix in the Reflectance dataframe
# The matrix needs to be 2151 columns wide. If the reflectance data covers a narrower range than 350 - 2500 nm, you ll need to put NA in the missing wavelengths
# Note that the reflectance has to be expressed in percent from 0 to 100
Reflectance_mat=matrix(data = NA,nrow = nrow(Reflectance),ncol=length(350:2500))
Reflectance_mat[,350:2500%in%490:950]=as.matrix(Reflectance[,2:462]*100)
Reflectance$Reflectance=I(Reflectance_mat)

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance[,350:2500%in%490:950],wv = 490:950)

# Keeping only the SampleID, Spectrometer, Probe_type, Probe_model, and Spectra_trait_pairing columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]

# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
