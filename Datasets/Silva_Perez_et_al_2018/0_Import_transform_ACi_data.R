## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Silva-Perez et al. 2018. https://doi.org/10.1093/jxb/erx421
## The dataset is available publicly : https://github.com/ashwhall/hyperspec-trait-prediction/tree/main but the raw licor data were sent personnaly by
## Viridiana Silva Perez and Robert Furbank

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Load the readxl library to import the Licor excel files
library(readxl)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Silva_Perez_et_al_2018' folder where the data is located
setwd(file.path(path,'/Datasets/Silva_Perez_et_al_2018'))

# Import the ACi file 
##(JL 20240711: I collated the raw files present in the folder "Licor_Files", i.e all the sheets "LCR" from each individual excel file).
## I standardized the file colnames during this process

curated_data=read.csv("Raw_ACi.csv")
curated_data$SampleID=paste(curated_data$File,curated_data$DAE,curated_data$Plot,curated_data$Rep)


# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
