library(here)
path = here()
setwd(file.path(here(),'Datasets/Albert_et_al_2018'))
load(file='2_Fitted_ACi_data.Rdata')
SampleDetails <- read.csv('Wu_etal_2019_spectra_brazil.csv')

SampleDetails$SampleID=SampleDetails$BR_UID
SampleDetails$Site_name="TNF"
SampleDetails$Dataset_name="Albert_et_al_2018"
SampleDetails$Species
SampleDetails[SampleDetails$Growth.Environment=="Sunlit","Sun_Shade"]="Sun"
SampleDetails[SampleDetails$Growth.Environment=="Shaded","Sun_Shade"]="Shade"
SampleDetails[SampleDetails$Age_class%in%c("Y","YM"),"Phenological_stage"]="Young"
SampleDetails[SampleDetails$Age_class%in%c("M"),"Phenological_stage"]="Mature"
SampleDetails[SampleDetails$Age_class%in%c("O","OS","S"),"Phenological_stage"]="Old"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"

## Finding a unique identifier between files to merge the chemical data with the spectra
## Wow I feel I found a mysterious key for a treasure. That was not simple!
Chem_data <- read.csv("Albert_et_al_2018_TNF_leaf_chem_trait_data.csv")
Chem_data$Date=as.character(Chem_data$Date)
Chem_data[nchar(Chem_data$Date)==7,"Date"]=paste("0",Chem_data[nchar(Chem_data$Date)==7,"Date"],sep="")
Chem_data$Date=paste(substr(Chem_data$Date,start = 1,stop = 4),substr(Chem_data$Date,start = 7,stop = 8),sep="")
Chem_data$Leaf_ID=paste(Chem_data$Unique_Tree_ID,Chem_data$Date,Chem_data$Branch_Light_Environment,Chem_data$Leaf_number,sep="_")
gasex_data<- read.csv("Albert_et_al_2018_TNF_gas_exchange_parameters.csv")
Chem_data=merge(Chem_data,gasex_data,by.x="Leaf_ID",by.y="Leaf_ID")

SampleDetails=merge(SampleDetails,Chem_data,by.x="BR_UID",by.y="code_for_matching",all.x=TRUE)

SampleDetails$LMA=1/as.numeric(SampleDetails$SLA_JW)*10000 ## Conversion from g.cm-2 to g.m-2
hist(SampleDetails$LMA)
SampleDetails$Narea=SampleDetails$percent_N/100*SampleDetails$LMA
hist(SampleDetails$Narea)

SampleDetails$Nmass=SampleDetails$percent_N*10
hist(SampleDetails$Nmass)
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA

SampleDetails=SampleDetails[SampleDetails$SampleID%in%Bilan$SampleID,]
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())

