library(here)
library(readxl)
path=here()
## Dataset sent by Liangynu Liu

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Qian_et_al_2019'))

## I import successively the data for each species
chinese_redbud=read.csv('Gasexchangedata_Chinese_redbud.csv')
chinese_redbud=chinese_redbud[,c("Curve","Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")]
chinese_redbud$Species="Chinese_redbud"
colnames(chinese_redbud)=c(ESS_column,"Species")

cotton=read.csv('Gasexchangedata_Cotton.csv')
cotton=cotton[,c("Curve","Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")]
cotton$Species="Cotton"
colnames(cotton)=c(ESS_column,"Species")

Forsythia_Piemarker=read.csv('Gasexchangedata_Forsythia_Piemarker.csv')
Forsythia_Piemarker=Forsythia_Piemarker[,c("Curve","obs","A","Ci","CO2_s","CO2_s","gsw","Pa","Qin","RHcham","Tleaf")]
Forsythia_Piemarker$Species="Forsythia_Piemarker"
colnames(Forsythia_Piemarker)=c(ESS_column,"Species")

Honeysuckle=read.csv('Gasexchangedata_Honeysuckle.csv')
Honeysuckle=Honeysuckle[,c("Curve","Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")]
Honeysuckle$Species="Honeysuckle"
colnames(Honeysuckle)=c(ESS_column,"Species")

White_ash=read.csv('Gasexchangedata_White_ash.csv')
White_ash=White_ash[,c("Curve","Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")]
White_ash$Species="White_ash"
colnames(White_ash)=c(ESS_column,"Species")

## Combining the data from all species
curated_data=rbind.data.frame(chinese_redbud,cotton,Forsythia_Piemarker,Honeysuckle,White_ash)

## Creating a unique sample identifier
curated_data$SampleID=tolower(paste(curated_data$Species,curated_data$SampleID))

## Creating a numerical unique sample identifier
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
