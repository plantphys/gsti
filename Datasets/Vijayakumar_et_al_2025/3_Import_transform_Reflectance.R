library(here)
library(spectratrait)
library(spectrolab)
library(signal)
path=here()

## This dataset was sent by Amrutha Vijayakumar and Onoriode Coast

setwd(file.path(path,'/Datasets/Vijayakumar_et_al_2025'))

ls_files=dir(pattern = ".sig",recursive = TRUE)

## Importing the reflectance datat and correcting for the jumps between sensors
Reflectance=data.frame()
pdf(file="QaQc_Reflectance.pdf")
for(file in ls_files){
  spec=read_spectra(path=file)
  splice_point=guess_splice_at(spec)
  spec_match=match_sensors(x=spec,splice_at = splice_point,interpolate_wvl = c(5,1))
  plot(x=spec$bands,y=spec$value,col="darkgrey",type="l",main=file,ylim=c(0,1))
  lines(spec_match$bands,spec_match$value,main=file)
  spec_interpolated=approx(x = spec_match$bands, y = spec_match$value,xout = 350:2500)
  spec_filtered=sgolayfilt(spec_interpolated$y, 1, 15)
  lines(x=350:2500,y=spec_filtered,type="l",col="red")
  Reflectance_file=as.data.frame(t(spec_filtered)*100,colnames=paste("Wave_",300:2500,sep=""))
  Reflectance_file$file=file
  Reflectance=rbind.data.frame(Reflectance,Reflectance_file)
}
dev.off()

## List of abnormal spectra, most likely reason: there are dark measurements
ls_bad_spectra=c("SVC_Reflectance_Data/HR.100124.0010.sig","SVC_Reflectance_Data/HR.100124.0011.sig","SVC_Reflectance_Data/HR.100124.0025.sig","SVC_Reflectance_Data/HR.100124.0030.sig",
                 "SVC_Reflectance_Data/HR.100124.0041.sig","SVC_Reflectance_Data/HR.100124.0052.sig","SVC_Reflectance_Data/HR.100124.0061.sig","SVC_Reflectance_Data/HR.100224.0000.sig","SVC_Reflectance_Data/HR.100224.0011.sig","SVC_Reflectance_Data/HR.100224.0022.sig","SVC_Reflectance_Data/HR.100224.0033.sig","SVC_Reflectance_Data/HR.100224.0044.sig","SVC_Reflectance_Data/HR.100224.0055.sig","SVC_Reflectance_Data/HR.100224.0056.sig")


## List of weird spectra. I am not sure why they look like that. It seems that the VIS part is distorted, I am not sure this is natural, it looks like a sensor calibration issue
ls_weird_spectra=c("SVC_Reflectance_Data/HR.100124.0015.sig","SVC_Reflectance_Data/HR.100124.0022.sig","SVC_Reflectance_Data/HR.100124.0031.sig","SVC_Reflectance_Data/HR.100224.0004.sig","SVC_Reflectance_Data/HR.100224.0036.sig","SVC_Reflectance_Data/HR.100224.0048.sig")

Reflectance=Reflectance[!Reflectance$file%in%c(ls_bad_spectra,ls_weird_spectra),]

## Finding the SampleID from the gas exchange data
# Importing the gas exhange data
data_Rdark <- read.csv("Amrutha et al 2025-Tomato_Dark respiration and SVC data_combined.csv")
SampleInfo=data_Rdark[,c("Sl.No","Unique.ID","SVC.file.number")]
#Merging data
Reflectance$file_name=sub("\\.sig$", "", basename(Reflectance$file))
Reflectance=merge(x = Reflectance,y=data_Rdark,by.x="file_name",by.y="SVC.file.number",all=TRUE)
Reflectance$SampleID=Reflectance$Unique.ID

Reflectance$Spectrometer="SVC HR-1024i"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="SVC LC-RP"
Reflectance$Spectra_trait_pairing="Same"
Reflectance$Reflectance=I(as.matrix(Reflectance[,2:2152]))
Reflectance=Reflectance[!is.na(Reflectance$SampleID),]
Reflectance=Reflectance[!is.na(Reflectance$V1),]
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500) 


## I remove spectra with a very high reflectance

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
