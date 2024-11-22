library(here)
path=here()
setwd(file.path(path,'/Datasets/Burnett_et_al_2021_2'))
SampleDetails=read.csv("leaf_traits.csv")
Metadata=read.csv("metadata.csv")

SampleDetails=merge(x=SampleDetails,y=Metadata,by="uniquefield")
SampleDetails$SampleID=SampleDetails$uniquefield
SampleDetails[SampleDetails$Location=="glasshouse","Site_name"]="BNL_greenhouse"
SampleDetails[SampleDetails$Location=="field","Site_name"]="BNL_field"
SampleDetails$Dataset_name="Burnett_et_al_2021_2"
SampleDetails$Species=as.character(factor(SampleDetails$Species,levels = c("CAAN4","CUPE","HEAN3","POCA19","RASA2","SEIT","SOBI2"),labels = c("Capsicum annuum","Cucurbita pepo","Helianthus annuus","Populus canadensis","Raphanus sativus","Setaria italica","Sorghum bicolor")))
SampleDetails$Sun_Shade="Sun"
SampleDetails$Phenological_stage="Mature"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Agricultural"
SampleDetails[SampleDetails$Location=="glasshouse","Soil"]="Pot"
SampleDetails[SampleDetails$Location=="field","Soil"]="Managed"

SampleDetails$LMA
SampleDetails$Narea=SampleDetails$Elemental_N ## Weird. THe unit correspond but the column name let think it would be nmass
SampleDetails$Nmass=SampleDetails$Narea/SampleDetails$LMA*1000
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=SampleDetails$RWC
SampleDetails$Chl=NA

SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
