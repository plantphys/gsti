## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Dauvissat et al. 2024 (unpublished)


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Dauvissat_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Dauvissat_et_al_2024'))

# Import the authors original raw data
original_data=read.csv('FrenchGuiana_2024_Survey_data.csv')
original_data$record=1 ## Adding the record data (not really useful for one point data, more usefull for full ACi curves)
# Select specific columns from the original data to create the curated data set
curated_data=original_data[,c("SampleID", "record","A","Ci","CO2s","CO2r","gsw","Patm","Qin","RHs","Tleaf")]
curated_data$gsw=curated_data$gsw/1000
# Rename the columns of the curated dataset with the ESS standard
colnames(curated_data)=c(ESS_column)

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
