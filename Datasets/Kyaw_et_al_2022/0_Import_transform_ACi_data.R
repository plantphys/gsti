## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Kyaw et al. 2022.
## The dataset was sent by Thu-Ya Kiaw


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Kyaw_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Kyaw_et_al_2022'))

# Import the authors original raw data
original_data=read.csv('A-Ci Raw Data.csv')

# Select specific columns from the original data to create the curated data set

curated_data=original_data[,c("SampleID", "Record","A","Ci","CO2s","gsw","Patm","Qin","RHs","Tleaf")]
curated_data$CO2r = NA
curated_data$gsw = curated_data$gsw/1000

curated_data=curated_data[!is.na(curated_data$A),]
# This dataset is already using the ESS standard
# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Populate the 'Record' column with a unique number for each observation of each leaf 'SampleID'
for(SampleID in curated_data$SampleID){
  curated_data[curated_data$SampleID==SampleID,'Record']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
}

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
