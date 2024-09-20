## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/plantphys/spectratrait
# Load the signal package. The Savitzky-Golay algorithm is used to smooth the spectra
library(signal)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Ogaya_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Ogaya_et_al_2022'))

# load the original reflectance data
Reflectance=read.csv('Reflectance data Guiana-Penuelas.csv')

# Informing the spectrometer model used used (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD FieldSpec 4, ASD FieldSpec 4 Hi-Res,...)
Reflectance$Spectrometer=""
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model=""
Reflectance$Spectra_trait_pairing="Similar"

# Importing the wavelengths from 350 nm to 2500 nm and storing them into a matrix in the Reflectance dataframe
# The matrix needs to be 2151 columns wide. If the reflectance data covers a narrower range than 350 - 2500 nm, you ll need to put NA in the missing wavelengths
# Note that the reflectance has to be expressed in percent from 0 to 100
WV=names(Reflectance[,11:1258])
WV=as.numeric(substr(WV,2,8))
Reflectance$Reflectance=I(as.matrix(Reflectance[,11:1258]))

Processed_Reflectance=data.frame()
for(line in 1: nrow(Reflectance)){
  #plot(y=Reflectance[line,"Reflectance"],x=WV)
  filtered=sgolayfilt(Reflectance[line,"Reflectance"],n=41,p=1)
  #lines(x=WV,y=filtered,col="red")
  interpolated=approx(x = WV,y=filtered,xout = 500:900)
  #lines(x=500:900,y=interpolated$y,col="green")
  Processed_Reflectance=rbind.data.frame(Processed_Reflectance,interpolated$y)
}
colnames(Processed_Reflectance)=paste0("Wave_",500:900)

col_350_499=matrix(data=NA,dimnames = list(1:nrow(Processed_Reflectance),paste0("Wave_",350:499)),nrow = nrow(Processed_Reflectance),ncol = length(350:499))
col_901_2500=matrix(data=NA,dimnames = list(1:nrow(Processed_Reflectance),paste0("Wave_",901:2500)),nrow = nrow(Processed_Reflectance),ncol = length(901:2500))
Processed_Reflectance=cbind.data.frame(col_350_499,Processed_Reflectance,col_901_2500)
Reflectance$Reflectance=I(as.matrix(Processed_Reflectance))

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

# Creating a SampleID compatible with Verryckt et al. 2022 data
# Verryckt et al. 2022 ID is in the form: "Year_season_site-plot_TreeBranchRepetition" Example: 2015_wet_PAR-B1_37D1
#Standardizing the site names
Reflectance[Reflectance$Site=="Nouragues","Site_Verryckt"]="NOU"
Reflectance[Reflectance$Site=="Paracou","Site_Verryckt"]="PAR"

#Standardizing the plot names
# Verryckt data is "PlotNumber" while the reflectance data is "NumberPlot"
Plot_Letter=substr(Reflectance$Plot,start = 2,stop=2)
Plot_Figure=substr(Reflectance$Plot,start = 1,stop=1)
Reflectance$Plot_Verryckt=paste0(Plot_Letter,Plot_Figure)

# Finding the repetition number
for(line in 1: nrow(Reflectance)){
  label=Reflectance[line,"Label"]
  Reflectance[line,"Repetition"]=substr(label,start =nchar(label)-5 ,stop=nchar(label)-5)
}

#Standardizing the branch position name: Verryckt data only has measurement on top of canopy branches (T) or on bottom of canopy (D)
# while reflectance measurements where made on top (up), middle (middle) or down (down)
Reflectance[Reflectance$Branch.canopy.location=="down","BranchPosition"]="D"
Reflectance[Reflectance$Branch.canopy.location=="up","BranchPosition"]="T"


Reflectance$SampleID=paste0(Reflectance$Year,"_",Reflectance$Season,"_",Reflectance$Site_Verryckt,"-",Reflectance$Plot_Verryckt,"_",Reflectance$Plant,Reflectance$BranchPosition,Reflectance$Repetition)

# Keeping only the "SampleID","Reflectance","Spectrometer","Probe_type","Probe_model", and "Spectra_trait_pairing" columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]

# Removing duplicated data
Reflectance[duplicated(Reflectance$SampleID),"SampleID"]
Reflectance=Reflectance[-which(duplicated(Reflectance$SampleID)),]

# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
