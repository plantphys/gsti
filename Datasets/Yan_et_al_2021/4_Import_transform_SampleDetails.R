
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
SampleDetails$Sun_Shade="Sun"
SampleDetails[SampleDetails$`Leaf age (Y-young; M-mature; O-old)`=="Y","Phenological_stage"]="Young"
SampleDetails[SampleDetails$`Leaf age (Y-young; M-mature; O-old)`=="M","Phenological_stage"]="Mature"
SampleDetails[SampleDetails$`Leaf age (Y-young; M-mature; O-old)`=="O","Phenological_stage"]="Old"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"

Leaf_traits=read_xlsx(path = 'Yan et al., 2021. NPH. Leaf traits data.xlsx',sheet=2)
any(duplicated(Leaf_traits$`Vcmax25 (umol m-2 s-1)`))## We can use the Vcmax25 column to merge the info between SampleDetails ad Leaf_traits
SampleDetails=merge(x=SampleDetails,y=Leaf_traits[,c("Tree ID","Leaf ID","Vcmax25 (umol m-2 s-1)","LMA (g/m2)", "LWC (%)","Leaf N (g/m2)")],by="Vcmax25 (umol m-2 s-1)")
SampleDetails$LMA=SampleDetails$`LMA (g/m2)`
SampleDetails$Narea=SampleDetails$`Leaf N (g/m2)`
SampleDetails$Nmass=SampleDetails$`Leaf N (g/m2)`*1000/SampleDetails$`LMA (g/m2)`
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=SampleDetails$`LWC (%)`*100
SampleDetails$Chl=NA


SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC","Chl")]

save(SampleDetails,file="4_SampleDetails.Rdata")

## Checking the dataset
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
