
library(here)
library(readxl)
path=here()
setwd(file.path(path,'/Datasets/Yan_et_al_2021'))
SampleDetails=read_xlsx(path = 'Yan et al., 2021. NPH. Spectra-Vcmax25 data.xlsx',sheet=2)
SampleDetails$Site=factor(x = SampleDetails$Site,levels = c("Mt Changbai","Mt Dinghu","Xishuangbanna"),labels = c("CB","DH","XSBN"))
SampleDetails$SampleID=SampleDetails$`Leaf Code`
SampleDetails$Site_name=as.character(SampleDetails$Site)
SampleDetails$Dataset_name="Yan_et_al_2021"
SampleDetails$Species=SampleDetails$SpeciesName
SampleDetails$Leaf_match="Same"
SampleDetails$Sun_Shade="Sun"
SampleDetails[SampleDetails$`Leaf age (Y-young; M-mature; O-old)`=="Y","Phenological_stage"]="Young"
SampleDetails[SampleDetails$`Leaf age (Y-young; M-mature; O-old)`=="M","Phenological_stage"]="Mature"
SampleDetails[SampleDetails$`Leaf age (Y-young; M-mature; O-old)`=="O","Phenological_stage"]="Old"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA=NA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA


SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Leaf_match","Sun_Shade","Phenological_stage","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

## Checking the dataset
source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())