library(here)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2022'))
SampleDetails=read.csv("PA_2022_SampleDetails.csv")
Biochemistry=read.csv("PA_2022_Foliar_biochemistry.csv")
SampleDetails=merge(x=SampleDetails,y=Biochemistry[,c("SampleID","LMA","N_pc","fresh_mass","dry_mass")],all.x=TRUE)
SampleDetails$Site_name=substr(x = SampleDetails$Site,start = 4,stop = 7)
SampleDetails$Dataset_name="Lamour_et_al_2022"
SampleDetails$Species=SampleDetails$Genus_species
SampleDetails$Leaf_match="Same"
SampleDetails$Phenological_stage="Mature"
SampleDetails[SampleDetails$Vertical_Level%in%c(1,2),"Sun_Shade"]="Sun"
SampleDetails[SampleDetails$Vertical_Level%in%3:10,"Sun_Shade"]="Shade"
SampleDetails[SampleDetails$Site_name=="PNM"&is.na(SampleDetails$Vertical_Level),"Sun_Shade"]="Sun"
SampleDetails[SampleDetails$Site_name=="Gam","Sun_Shade"]="Shade"
SampleDetails[SampleDetails$Site_name=="Gam"&SampleDetails$Species=="Tabebuia rosea","Sun_Shade"]="Sun"
SampleDetails$Plant_type="Wild"
SampleDetails$Soil="Natural"
SampleDetails$LMA=as.numeric(SampleDetails$LMA)
SampleDetails$Narea=SampleDetails$N_pc/100*SampleDetails$LMA
SampleDetails$Nmass=SampleDetails$N_pc*10
SampleDetails$Parea=NA
SampleDetails$Pmass=NA
SampleDetails$LWC=(as.numeric(SampleDetails$fresh_mass)-as.numeric(SampleDetails$dry_mass))/as.numeric(SampleDetails$fresh_mass)*100
SampleDetails[!is.na(SampleDetails$LWC)&SampleDetails$LWC<20,"LWC"]=NA
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Leaf_match","Sun_Shade","Phenological_stage","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

save(SampleDetails,file="4_SampleDetails.Rdata")

source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())
