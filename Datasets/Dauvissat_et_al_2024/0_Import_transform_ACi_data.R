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
original_data=read.csv('FrenchGuiana_2024_Aq_data.csv')

# Select specific columns from the original data to create the curated data set

curated_data=original_data[,c("SampleID", "record","A","Ci","CO2s","CO2r","gsw","Patm","Qin","RHs","Tleaf","Remove")]

# Rename the columns of the curated dataset with the ESS standard
# I also kept the column "Remove" which is not part of the standard and that will be usefull to analyse the
# data quality. It corresponds to the author flagging of bad data. THis column doesnt have to be included
# in other datasets.
colnames(curated_data)=c(ESS_column,'Remove')

# I only keep the first point of the curves with the light level above 700 mumolm-2s-1 to estimate Vcmax with the one point method
curated_data=curated_data[curated_data$Qin>700&curated_data$Remove=="NO",]

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
