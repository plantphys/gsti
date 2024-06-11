## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/TESTgroup-BNL/spectratrait
# Load the signal package that I use to filter and interpolated the reflectance

library(signal)
# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Ting_et_al_2023' folder where the data is located
setwd(file.path(path,'/Datasets/Ting_et_al_2023'))

# load the original reflectance data
Reflectance=read.csv('ting_2023_Reflectance.csv')

# Extract the wavelength
WV=colnames(Reflectance[,2:737])
WV=as.numeric(substr(WV,2,5))

# Create a Reflectance matrix
Reflectance$Reflectance_raw=I(as.matrix(Reflectance[,2:737]))

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance_raw,wv = WV)

## Interpolating and filtering the spectra
Reflectance_interpolated=matrix(nrow = nrow(Reflectance),ncol=length(350:2500),dimnames = list(Reflectance$SampleID,350:2500))
pdf("QaQc_Reflectance.pdf")
for(i in 1:nrow(Reflectance)){
  plot(x=WV,y=Reflectance[i,"Reflectance_raw"],xlab="Wavelength (nm)",ylab="Reflectance %",ylim=c(-0.05,1.05),main=Reflectance[i,"SampleID"])
  filtered_R=sgolayfilt(Reflectance[i,"Reflectance_raw"],n=9,p=1)
  lines(x=WV,y=filtered_R,col="red")
  interpolated_R=approx(x = WV,y=filtered_R,xout = 400:2498)$y
  Reflectance_interpolated[i,as.character(400:2498)]=interpolated_R
  lines(x=400:2498,y=interpolated_R,col="green")
  abline(h=c(0,1))
}
dev.off()

f.plot.spec(Z = Reflectance_interpolated[,as.character(400:2498)],wv = 400:2498)

Reflectance$Reflectance=I(100*Reflectance_interpolated)

# Informing the spectrometer model used used (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD FieldSpec 4, ASD FieldSpec 4 Hi-Res,...)
Reflectance$Spectrometer="MSV 500 VNIR Spectral Camera AND Specim"

Reflectance$Probe_type="Imager"
Reflectance$Probe_model=NA
Reflectance$Spectra_trait_pairing="Plant scale"

# Keeping only the "SampleID","Reflectance","Spectrometer","Probe_type","Probe_model", and "Spectra_trait_pairing" columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]


# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
