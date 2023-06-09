library(here)
library(spectratrait)
path=here()

## This dataset was sent by O. Atkin and O. Coast

setwd(file.path(path,'/Datasets/Coast_et_al_2019'))


cols=paste("X",350:2500,sep="")
ls_files=dir(pattern = "Jump")

LMA=read.csv(ls_files[1])
LMA$Reflectance=I(as.matrix(LMA[,cols]*100))
LMA=LMA[,c("ID","Place","Measurement","Q2_LMA","Reflectance")]

f.plot.spec(Z = LMA$Reflectance,wv = 350:2500)
f.plot.spec(Z = LMA[LMA$Reflectance[,"X800"]>60,"Reflectance"],wv = 350:2500)

Narea=read.csv(ls_files[2])
Narea$Reflectance=I(as.matrix(Narea[,cols]*100))
LMA=merge(x=LMA,y=Narea[,c("ID","N_area")],by="ID",all=TRUE)

Nmg=read.csv(ls_files[3])
Nmg$Reflectance=I(as.matrix(Nmg[,cols]*100))
LMA=merge(x=LMA,y=Nmg[,c("ID","N_mg")],by="ID",all=TRUE)

RdLa=read.csv(ls_files[5])
RdLa$Reflectance=I(as.matrix(RdLa[,cols]*100))
LMA=merge(x=LMA,y=RdLa[,c("ID","Rd_LA")],by="ID",all=TRUE)
LMA$Experiment=="NA"

LMA[LMA$ID==4168,c("Place","Measurement","Reflectance")]=Narea[Narea$ID==4168,c("Place","Measurement","Reflectance")]
LMA[LMA$Measurement%in%c("Low Light" , "High Light"),"Experiment"]=1
LMA[LMA$Measurement%in%c("Flag leaf", "Flagminus1", "Third leaf"),"Experiment"]=2
LMA[LMA$Measurement%in%c("Vegetative", "Anthesis"),"Experiment"]=3

LMA=LMA[,c("ID","Place","Experiment","Measurement","N_area","N_mg","Rd_LA","Q2_LMA","Reflectance")]

write.csv(file="Coast_et_al_2019.csv",LMA,row.names=FALSE)

Reflectance=read.csv(file = "Coast_et_al_2019.csv",na.strings = "NA")
Reflectance$SampleID=Reflectance$ID
Reflectance$Spectrometer="ASD FieldSpec 4"
Reflectance$Leaf_clip="ASD Leaf Clip"
Reflectance$Reflectance=I(as.matrix(Reflectance[,9:2159]))

f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500) 

## I remove spectra with a very high reflectance

hist(Reflectance$Reflectance[,"Reflectance.X800"])
Reflectance=Reflectance[Reflectance$Reflectance[,"Reflectance.X800"]<100,]

Reflectance=Reflectance[,c("SampleID","Reflectance","Spectrometer","Leaf_clip")]
save(Reflectance,file='3_QC_Reflectance_data.Rdata')
