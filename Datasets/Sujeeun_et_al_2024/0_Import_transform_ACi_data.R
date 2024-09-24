## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Sujeeun_et_al_2024
## The dataset was sent by Lutchmee Sujeeun


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Sujeeun_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Sujeeun_et_al_2024'))

# Import the authors original raw data
original_data=read.csv('ACi_data.csv')


# Select specific columns from the original data to create the curated data set
# Here I selected several times the column SampleID. This is because the Record and gsw columns were missing (column 2 and 7, respectively).
# I then rename this columns and populate them.

curated_data=original_data[,c("SampleID_num","SampleID", "Record","A","Ci","CO2s","CO2r","gsw","Patm","Qin","RHs","Tleaf")]

# Rename the columns of the curated dataset with the ESS standard
# I also kept the column "Remove" which is not part of the standard and that will be usefull to analyse the
# data quality. It corresponds to the author flagging of bad data. THis column doesnt have to be included
# in other datasets.
colnames(curated_data)=c("SampleID_num",ESS_column)

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
