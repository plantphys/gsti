## This code is used to do the step 3 of the data curation process.
## It is used to import the reflectance data and save it using a standard format


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the spectratrait package that is used to plot the Reflectance data
library(spectratrait) # https://github.com/plantphys/spectratrait
library(spectacles) # Available on cran
library(readxl)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Doughty_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Doughty_et_al_2021'))

# list the reflectance files

ls_files=dir(recursive=TRUE)
ls_files=ls_files[which(grepl(x=ls_files,pattern="Spectral_data",ignore.case = TRUE))]

Reflectance=data.frame()
for(file in ls_files){
  data_file=read_xlsx(file,col_types = c("text",rep("numeric",2151)))
  Reflectance=rbind.data.frame(Reflectance,data_file)
}

# The reflectance is uncorrected, so it is corrected here. 
Reflectance_splice_corrected=matrix(data = NA,nrow = nrow(Reflectance),ncol = length(350:2500))
pdf("3_QaQc_Reflectance_splice.pdf")
for (i in 1 : nrow(Reflectance)){
  leaf_spec=Spectra(wl = 350:2500,nir =Reflectance[i,2:2152],id = Reflectance[i,"leaf code"])
  leaf_spec_corrected=splice(leaf_spec,locations=list(c(720, 970), c(1760, 1880)))
  Reflectance_splice_corrected[i,]=leaf_spec_corrected@nir[1,]
  plot(leaf_spec,main=Reflectance[i,"leaf code"],ylim=c(0,1),ylab='Reflectance',col="black")
  lines(y=leaf_spec_corrected@nir[1,],x=350:2500,col="red")
}
dev.off()

# Flagging spectra with a strong jump between sensors
jump_970=(Reflectance$'971'-Reflectance$'970')*100
jump_1760=(Reflectance$'1761'-Reflectance$'1760')*100
hist(jump_1760)

# Only keeping spectra with a below 2% Jump
Reflectance=Reflectance[which(abs(jump_970)<2&abs(jump_1760)<2),]
Reflectance_splice_corrected=Reflectance_splice_corrected[which(abs(jump_970)<2&abs(jump_1760)<2),]

Reflectance$Reflectance=I(Reflectance_splice_corrected)
Reflectance=Reflectance[Reflectance$'1000'*100>20&Reflectance$'1000'*100<80&!is.na(Reflectance$'1000'),]

Reflectance$SampleID=substr(x = Reflectance$`leaf code`,start = 1,stop = (nchar(Reflectance$`leaf code`)-5))
Reflectance$Rep=as.numeric(substr(x = Reflectance$`leaf code`,start = (nchar(Reflectance$`leaf code`)-4),stop =(nchar(Reflectance$`leaf code`))))

## Averaging the spectra per leaf
curated_data=data.frame()
pdf("3_QaQc_Reflectance.pdf")
for (SampleID in unique(Reflectance$SampleID)){
  leaf_spec=Reflectance[Reflectance$SampleID==SampleID,]
  #matplot(y=t(leaf_spec[,"Reflectance"]),main=SampleID,ylim=c(0,1),ylab='Reflectance',col="black",type="l")
  leaf_average=as.data.frame(t(apply(leaf_spec$Reflectance,MARGIN = 2,FUN = mean)))
  leaf_average$SampleID=SampleID
  curated_data=rbind.data.frame(curated_data,leaf_average)
  plot(y=t(leaf_average[1,1:2151]),x=350:2500, main=SampleID,ylim=c(0,1),ylab='Reflectance',col="black",type="l")
}
dev.off()

ls_bad=c("CON-1436-JAN22-L4","GRD_T331_JAN23_L5","GRD_T1477_JAN23_L2","GRD_T1477_JAN23_L1","CON-T134-APR03-L1","CON-T134-APR03-L2","CON-T134-APR03-L3","CON-T134-APR03-L4","CON-T134-APR03-L5","CON-T119-APR02-L3","CON-T119-APR02-L4","CON-T119-APR02-L5","CON-T1436-APR02-L4","CON-T1436-APR02-L5")
# Importing the wavelengths from 350 nm to 2500 nm and storing them into a matrix in the Reflectance dataframe
# The matrix needs to be 2151 columns wide. If the reflectance data covers a narrower range than 350 - 2500 nm, you ll need to put NA in the missing wavelengths
# Note that the reflectance has to be expressed in percent from 0 to 100
Reflectance=curated_data
Reflectance$Reflectance=I(as.matrix(Reflectance[,1:2151])*100)
Reflectance=Reflectance[-which(Reflectance$SampleID%in%ls_bad),]

Reflectance$SampleID=gsub(pattern = "-",replacement = "_",x = toupper(Reflectance$SampleID))
Metadata=as.data.frame(t(as.data.frame(strsplit(Reflectance$SampleID,"_"))))
Metadata$tree_number=paste("T",as.numeric(sub("T", "", Metadata$V2)),sep="") ## Homogenize notation
Reflectance$SampleID=paste(Metadata$tree_number,Metadata$V3,Metadata$V4,sep="_")
Reflectance=Reflectance[-which(duplicated(Reflectance$SampleID)),]

# Plot of the reflectance data. If this doenst work, the most likely reason is that the format is not correct
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)

# Informing the spectrometer model used used (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD FieldSpec 4, ASD FieldSpec 4 Hi-Res,...)
Reflectance$Spectrometer="ASD FieldSpec 4"

# Type of probe used to measure the spectra. Is it a "Leaf clip"? "Integating sphere"? Or an "imager"?
Reflectance$Probe_type="Leaf clip"

# Reference for the probe used (SVC LC-RP, SVC LC-RP Pro, ASD Leaf Clip, ...)
Reflectance$Probe_model="ASD Leaf Clip"

# a column that explains how the gas exchange information is paired with the spectral data. 
# If the gas exchange and leaf spectra were measured in the same leaf, choose “Same”. 
# If they were measured in similar leaves, choose “Similar”. 
# Finally, if hyperspectral data was measured at the plant scale (and paired to gas exchange at the leaf scale), choose “Plant scale”.
Reflectance$Spectra_trait_pairing="Same"

# Keeping only the SampleID, Spectrometer, Probe_type, Probe_model, and Spectra_trait_pairing columns
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]

# Saving the standardized reflectance data
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
