library(here)
path=here()
setwd(file.path(path,'/Datasets/Wu_et_al_2019'))
SampleDetails=read.csv('Wu et al. 2019 spectra panama.csv')
load("2_Fitted_ACi_data.Rdata")
Site_info=read.csv('2017_SLZ_ACi_comp.csv')
Site_info=Site_info[,c('Site','Sample_ID')]

Site_info2=read.csv('2016ENSO_Panama_ACi.csv')
Site_info2$Sample_ID=Site_info2$Barcode
Site_info2=Site_info2[,c('Site','Sample_ID')]

Site_info=rbind.data.frame(Site_info,Site_info2)

Site_info=Site_info[-which(duplicated(Site_info$Sample_ID)),]
SampleDetails=merge(x = SampleDetails,y = Site_info[,c("Sample_ID","Site")],by.x = "BNL_UID",by.y="Sample_ID")

Chem_data=read.csv("2016_ENSO_CHN.csv")
Chem_data$SampleID=Chem_data$BNL_barcode
Chem_data=Chem_data[,c("SampleID","N_pc","N_g_m.2","LMA_g_m.2","H20_pc")]

Chem_data2=read.csv("Panama2017_CHN.csv")
Chem_data2$SampleID=Chem_data2$Sample_ID
Chem_data2=Chem_data2[,c("SampleID","N_pc","N_g_m.2","LMA_gDW_m2","H2O_pc")]
colnames(Chem_data2)=colnames(Chem_data)
Chem_data=rbind.data.frame(Chem_data,Chem_data2)
Chem_data$LMA=Chem_data$LMA_g_m.2
Chem_data$Nmass=Chem_data$N_pc*10 ## conversion from % to per thousand or mg g-1
Chem_data$Narea=Chem_data$N_g_m.2
Chem_data$LWC=Chem_data$H20_pc
Chem_data[!is.na(Chem_data)&Chem_data==-9999]<-NA

SampleDetails=merge(x=SampleDetails,y=Chem_data,by.x="BNL_UID",by.y="SampleID",all.x=TRUE)

SampleDetails$SampleID=SampleDetails$BNL_UID
SampleDetails$Site_name=substr(SampleDetails$Site,4,6)
SampleDetails$Dataset_name="Wu_et_al_2019"
SampleDetails$Species=SampleDetails$Species.1
SampleDetails$Sun_Shade="Sun"
SampleDetails[SampleDetails$Age_adj_final%in%c("Y","YM"),"Phenological_stage"]="Young"
SampleDetails[SampleDetails$Age_adj_final%in%c("M","MO"),"Phenological_stage"]="Mature"
SampleDetails[SampleDetails$Age_adj_final%in%c("O","OS","S"),"Phenological_stage"]="Old"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA
SampleDetails$Narea
SampleDetails$Nmass
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC

SampleDetails=SampleDetails[SampleDetails$SampleID%in%Bilan$SampleID,]
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

## Checking the dataset
source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())