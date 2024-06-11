library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Burnett_et_al_2021_2'))
Reflectance=read.csv('leaf_spectra.csv')
Metadata=read.csv('metadata.csv')
LeafGasex=read.csv('leaf_gas_exchange.csv')
Reflectance=merge(x=Reflectance,y=Metadata,by="uniquefield")
Reflectance=Reflectance[Reflectance$Paired_Spectra=="leaf",]
unique(Reflectance$Instrument)

Reflectance$SampleID=Reflectance$uniquefield
Reflectance$Spectrometer="SE PSR+ 3500"
Reflectance$Probe_type="Leaf clip"
Reflectance$Probe_model="SVC LC-RP Pro"
Reflectance$Spectra_trait_pairing="Same"
Reflectance=Reflectance[Reflectance$SampleID%in%LeafGasex$uniquefield,]

Reflectance$Reflectance=I(as.matrix(Reflectance[,2:2152]))*100

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)
## I remove some weird spectra
pdf(file = "QaQc_reflectance.pdf")
for(SampleID in unique(Reflectance$SampleID)){
  Spectra=Reflectance[Reflectance$SampleID==SampleID,]
  plot(y=Spectra$Reflectance,x=350:2500,main=SampleID,ylim=c(0,100),type="l")
  abline(h=0,col="grey")
}
dev.off()
ls_bad=c("2018-04-18_40","2018-04-18_41","2018-04-18_42","2018-04-18_43","2018-04-18_45")
Reflectance=Reflectance[-which(Reflectance$SampleID%in%ls_bad),]
f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)
Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing")]

save(Reflectance,file='3_QC_Reflectance_data.Rdata')








