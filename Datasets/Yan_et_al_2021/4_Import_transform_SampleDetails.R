
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
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA=NA
SampleDetails$Narea=NA
SampleDetails$Nmass=NA
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=NA


SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")
