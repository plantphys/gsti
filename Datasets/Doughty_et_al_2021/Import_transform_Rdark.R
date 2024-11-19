## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Doughty_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Doughty_et_al_2021'))

# List all the licor raw data
ls_li6400=dir(recursive = TRUE)
ls_li6400=ls_li6400[which(grepl(x=ls_li6400,pattern="Licor_data",ignore.case = TRUE))]

curated_data=data.frame()
for (file in ls_li6400){
  data_file=read.csv(file,header = FALSE)
  data_header=data_file[data_file$V1=="Obs",]
  colnames(data_file)=data_header
  data_file=data_file[!is.na(as.numeric(data_file$Obs)),]
  nrow_data=nrow(data_file)
  if(nrow_data>0&nrow_data<10){
    aggregated_data=apply(data_file[,c("Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")],MARGIN = 2,FUN = function(x) mean(as.numeric(x)))
    aggregated_data$file=file
    curated_data=rbind.data.frame(curated_data,aggregated_data)
  }else if(nrow_data>0&nrow_data>=10){
    aggregated_data=apply(data_file[(nrow_data-10):nrow_data,c("Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")],MARGIN = 2,FUN = function(x) mean(as.numeric(x)))
    aggregated_data$file=file
    curated_data=rbind.data.frame(curated_data,aggregated_data)
  }
}


# Rename the columns of the curated dataset with the ESS standard
colnames(curated_data)=c("A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs","Tleaf","file")

curated_data=curated_data[curated_data$Qin<5,]
curated_data$SampleID=toupper(sub("\\_.csv$", "", basename(curated_data$file)))
curated_data$SampleID=sub("-S", "", curated_data$SampleID)
curated_data$SampleID=sub("S", "", curated_data$SampleID)
curated_data$Campaign=substr(x = curated_data$file,start = 13,stop = 13)
Metadata=as.data.frame(t(as.data.frame(strsplit(curated_data$SampleID,"-"))))
Metadata$tree_number=paste("T",as.numeric(sub("T", "", Metadata$V2)),sep="") ## Homogenize notation
Metadata$Date=toupper(Metadata$V3)
curated_data$SampleID=paste(Metadata$tree_number,Metadata$Date,Metadata$V4,sep="_")




curated_data=curated_data[curated_data$A<(-0.1),]
curated_data=curated_data[curated_data$gsw>0,]
curated_data=curated_data[curated_data$Ci<1200,]
hist(curated_data$RHs)

# Creating a Rdark dataframe
Rdark=data.frame(SampleID=curated_data$SampleID,Rdark=-curated_data$A,Tleaf_Rdark=curated_data$Tleaf)

# Checking data quality
hist(Rdark$Rdark) # No negative values
hist(Rdark$Tleaf_Rdark)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
