## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Heckman et al. 2017.
## This dataset was sent by Urte Schluter


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)
library(dplyr)
library(tidyverse)
library(stringr)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 
source(file.path(path,'/R/Photosynthesis_tools.R')) 

# Set the working directory to the 'Heckmann_et_al_2017' folder where the data is located
setwd(file.path(path,'/Datasets/Heckmann_et_al_2017'))

# Import the authors original raw data
ls_files= dir(recursive = TRUE)
ls_files_ACi_Li6400=ls_files[which(grepl(x=ls_files,pattern="Raw_Licor_files"))]

### Import all the ACi curves and create a dataframe with all the curves
original_data=data.frame()
for(file in ls_files_ACi_Li6400){
  testline=read.csv(file)
  line_header=which(testline[,1]=="Obs")
  datafile=read.csv(file,skip = line_header)
  datafile=datafile[!is.na(as.numeric(datafile$Obs)),]
  SampleID=strsplit(file,"/")[[1]][2]
  datafile$SampleID=SampleID
  original_data=rbind.data.frame(original_data,datafile)
}


# Select specific columns from the original data to create the curated data set
# Here I selected several times the column SampleID. This is because the Record and gsw columns were missing (column 2 and 7, respectively).
# I then rename this columns and populate them.

curated_data=original_data[,c('SampleID','Obs','Photo','Ci','CO2S','CO2R','Cond','Press','PARi','RH_S','Tleaf')]

# Converting the data into a numeric format
curated_data[,2:11]=sapply(curated_data[, 2:11], function(x) {
  as.numeric(x)})


# Rename the columns of the curated dataset with the ESS standard
colnames(curated_data)=c(ESS_column)

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
