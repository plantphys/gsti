## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Doughty et al 2021.
## The dataset is available publicly :https://datadryad.org/stash/dataset/doi:10.5061/dryad.d51c5b01n but Chris Doughty send the raw data


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the package readxl to open .xls files
library(readxl)
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

# Keeping only light saturated gas exchange data
curated_data= curated_data[curated_data$PARi>1000,]

curated_data$SampleID=toupper(sub("\\_.csv$", "", basename(curated_data$file)))
curated_data$SampleID=sub("-S", "", curated_data$SampleID)
curated_data$SampleID=sub("S", "", curated_data$SampleID)
curated_data$Campaign=substr(x = curated_data$file,start = 13,stop = 13)
Metadata=as.data.frame(t(as.data.frame(strsplit(curated_data$SampleID,"-"))))
Metadata$tree_number=paste("T",as.numeric(sub("T", "", Metadata$V2)),sep="") ## Homogenize notation
Metadata$Date=toupper(Metadata$V3)
curated_data$SampleID=paste(Metadata$tree_number,Metadata$Date,Metadata$V4,sep="_")

# Rename the columns of the curated dataset with the ESS standard
colnames(curated_data)=c("A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs","Tleaf","file","SampleID")


curated_data$Record = 1

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
