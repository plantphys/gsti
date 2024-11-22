## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)
library(readxl)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Wu_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Wu_et_al_2024'))

# The Respiration data is stored in several excel files that have multiple sheets with different formats
data_XSBN=data.frame()
for (sheet in 1:6){
  data_sheet=read_xlsx("Figshare_data/Rdark_summary_XSBN.xlsx",sheet=sheet)
  if (ncol(data_sheet) == 64){
    data_sheet=data_sheet[-1,]
    data_sheet=data_sheet[,c("Name","Species","Date", "Photo", "Ci", "CO2S", "CO2R", "Cond", "Press", "PARi", "RH_S", "Tleaf")]
    colnames(data_sheet)=c("Name","Species","Date", "A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")
  } else { 
    colnames(data_sheet)[9:ncol(data_sheet)]=data_sheet[1,9:ncol(data_sheet)]
    data_sheet=data_sheet[-c(1,2),]
    data_sheet=data_sheet[,c("Name","Species","Date", "A", "Ci", "CO2_s", "CO2_r", "gsw", "Pa", "Qin", "RHcham", "Tleaf")]
    colnames(data_sheet)=c("Name","Species","Date", "A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")
  }
  data_XSBN=rbind.data.frame(data_XSBN,data_sheet)
}

data_GT=data.frame()
for (sheet in 1:4){
  data_sheet=read_xlsx("Figshare_data/Rdark_summary_GT.xlsx",sheet=sheet)
  if (ncol(data_sheet) == 64){
    data_sheet=data_sheet[-1,]
    data_sheet=data_sheet[,c("Name","Species","Date", "Photo", "Ci", "CO2S", "CO2R", "Cond", "Press", "PARi", "RH_S", "Tleaf")]
    colnames(data_sheet)=c("Name","Species","Date", "A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")
  } else { 
    colnames(data_sheet)[9:ncol(data_sheet)]=data_sheet[1,9:ncol(data_sheet)]
    data_sheet=data_sheet[-c(1,2),]
    data_sheet=data_sheet[,c("Name","Species","Date", "A", "Ci", "CO2_s", "CO2_r", "gsw", "Pa", "Qin", "RHcham", "Tleaf")]
    colnames(data_sheet)=c("Name","Species","Date", "A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")
  }
  data_GT=rbind.data.frame(data_GT,data_sheet)
}

data_CB=data.frame()
for (sheet in 1:6){
  data_sheet=read_xlsx("Figshare_data/Rdark_summary_CB.xlsx",sheet=sheet)
  if (ncol(data_sheet) < 70){
    data_sheet=data_sheet[-1,]
    data_sheet=data_sheet[,c("Name","Species","Date", "Photo", "Ci", "CO2S", "CO2R", "Cond", "Press", "PARi", "RH_S", "Tleaf")]
    colnames(data_sheet)=c("Name","Species","Date", "A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")
  } else { 
    colnames(data_sheet)[9:ncol(data_sheet)]=data_sheet[1,9:ncol(data_sheet)]
    data_sheet=data_sheet[-c(1,2),]
    data_sheet=data_sheet[,c("Name","Species","Date", "A", "Ci", "CO2_s", "CO2_r", "gsw", "Pa", "Qin", "RHcham", "Tleaf")]
    colnames(data_sheet)=c("Name","Species","Date", "A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")
  }
  data_CB=rbind.data.frame(data_CB,data_sheet)
}
data_GT$Site="GT"
data_CB$Site="CB"
data_XSBN$Site="XSBN"

data_GT=data_GT[-which(data_GT$Name=="TR67-B1-Rd1_0"),] ## Measured at Ca = 1700 ppm
data_GT[data_GT$Name=="TR19-B1-Rd1-2","Name"]="TR19-B1-Rd2"
data_XSBN[data_XSBN$Name=="TR94-B1-Rd2-1","Name"]="TR94-B1-Rd1"


Rdark=rbind.data.frame(data_GT,data_CB,data_XSBN)
Rdark$SampleID=paste(Rdark$Site,Rdark$Name,sep="_")
Rdark$SampleID=gsub("-Rd","-L",Rdark$SampleID)
Rdark=Rdark[-which(duplicated(Rdark$SampleID)),]

Rdark[as.numeric(Rdark$CO2s)<350,"A"]=NA

# Creating a Rdark dataframe# Creating a Rdark dataframe 
Rdark=data.frame(SampleID=Rdark$SampleID,Rdark=-as.numeric(Rdark$A),Tleaf_Rdark=as.numeric(Rdark$Tleaf))

# Checking data quality
hist(Rdark$Rdark)
hist(Rdark$Tleaf_Rdark)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
