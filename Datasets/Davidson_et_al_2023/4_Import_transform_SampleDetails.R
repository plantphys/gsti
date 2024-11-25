library(spectratrait)
library(here)
path <- here()

setwd(file.path(path,'/Datasets/Davidson_et_al_2023'))

SampleDetails <- read.csv("Leaf_Trait_Data.csv")
SampleDetails$USDA_Code <- as.factor(SampleDetails$USDA_Code)
levels(SampleDetails$USDA_Code) <- c("Acer rubrum","Acer saccharum","Betula alleghaniensis","Quercus alba","Quercus montana","Quercus rubra")

SampleDetails$Site_name="BRF"
SampleDetails$Dataset_name="Davidson_et_al_2023"
SampleDetails$Species=SampleDetails$USDA_Code
SampleDetails$Sun_Shade="Sun"
SampleDetails$Phenological_stage="Mature"
SampleDetails[substr(SampleDetails$date,5,6)=="05","Phenological_stage"]="Young"
SampleDetails[substr(SampleDetails$date,5,6)=="10","Phenological_stage"]="Old"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA
SampleDetails$Narea=SampleDetails$Na/1000
SampleDetails$Nmass=SampleDetails$Narea/SampleDetails$LMA*1000
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=(1-SampleDetails$LDMC)*100
SampleDetails$Chl=NA


SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
