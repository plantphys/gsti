library(here)
library(spectratrait)
path=here()

## This dataset was sent by Joy Ojo and Onoriode Coast

setwd(file.path(path,'/Datasets/Ojo_et_al_2024'))

Reflectance=read.csv(file = "Ojo et al 2024 Barley_Corrected.csv",na.strings = "NA")
Reflectance=Reflectance[,c(1,4:2155)]
Reflectance$LMA=NA
Reflectance$Species="Hordeum vulgare"
Reflectance2=read.csv(file = "Ojo et al 2024 Eucalytpus_Corrected.csv",na.strings = "NA")
Reflectance2=Reflectance2[,c(1,14,15,17:2167)]
Reflectance2$LMA=Reflectance2$LMA..gm.2.
Reflectance2$Species="Eucalyptus viminalis"

Reflectance=rbind.data.frame(Reflectance,Reflectance2[,colnames(Reflectance2)%in%colnames(Reflectance)])
Reflectance$SampleID=Reflectance$unique.id
Reflectance$Spectrometer="ASD FieldSpec 4"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="ASD Leaf Clip"
Reflectance$Spectra_trait_pairing="Same"
Reflectance$Reflectance=I(as.matrix(Reflectance[,3:2153])*100)

pdf(file="QaQc_Reflectance.pdf")
for(SampleID in unique(Reflectance$SampleID)){
  plot(y=Reflectance[Reflectance$SampleID==SampleID,2:2152],x=350:2500,type="l",main=SampleID,ylim=c(0,1))
}
dev.off()
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500) 

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing","Species","Rdark_25C","LMA")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
