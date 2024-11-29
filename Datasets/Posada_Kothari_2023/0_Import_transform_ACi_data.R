## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Posada and Kothari 2023.
## The dataset was sent directly by Juan and Shan


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Posada_Kothari_2023' folder where the data is located
setwd(file.path(path,'/Datasets/Posada_Kothari_2023'))

# Import the authors original raw data
curated_data=read.csv('Asat.csv')

# The columns gsw and Record were still filled with SampleID info. I replace by NA values
curated_data$CO2r=NA

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
