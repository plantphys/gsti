## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Vilas Boas et al. 2024.
## The dataset was sent by Marcelo Vila boas


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 
source(file.path(path,'/R/Photosynthesis_tools.R'))
library(dplyr)
library(purrr)
library(readr)
# Set the working directory to the 'Vilas_Boas_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Vilas_Boas_et_al_2024'))

# Import the authors original raw data
ls_files=dir(recursive = TRUE) ## This lists all the files that are in the same folder as this R code.

## This remove a lot of files that are not LICOR6400 files. You can change the filters as you want.
ls_files_ACi_Li6400=ls_files[which(grepl(x=ls_files,pattern="Aci")&!grepl(x=ls_files,pattern=".pdf"))]

### Import all the ACi curves and create a dataframe with all the curves
li6400_colnames=c("SampleID","Obs", "Photo", "Ci", "CO2S", "CO2R", "Cond", "Press" ,"PARi", "RH_S", "Tleaf","file")
data_6400=data.frame()
for(file in ls_files_ACi_Li6400){
  file_data=f.import_licor6400(file = file,column_display =c("Photo", "Cond","PARi", "Ci","file"))
  file_data=file_data[,li6400_colnames]
  data_6400=rbind.data.frame(data_6400,file_data)
}

#Convert the data with the ESS standard
curated_data=data_6400
colnames(curated_data)=c(ESS_column,'file')
curated_data$Method='ACi'

## The authors also measured Asat that we now import
## This remove a lot of files that are not LICOR6400 files. You can change the filters as you want.
ls_files_survey_Li6400=ls_files[which(grepl(x=ls_files,pattern="_m_"))]

### Import all the ACi curves and create a dataframe with all the curves
li6400_colnames=c("SampleID","Obs", "Photo", "Ci", "CO2S", "CO2R", "Cond", "Press" ,"PARi", "RH_S", "Tleaf","file")
data_6400=data.frame()
for(file in ls_files_survey_Li6400){
  file_data=f.import_licor6400(file = file,column_display =c("Photo", "Cond","PARi", "Ci","file"))
  file_data=file_data[,li6400_colnames]
  data_6400=rbind.data.frame(data_6400,file_data)
}
colnames(data_6400)=c(ESS_column,'file')
data_6400$Method='Survey'
curated_data=rbind.data.frame(curated_data,data_6400)

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))
curated_data$SampleID=toupper(curated_data$SampleID)
# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
