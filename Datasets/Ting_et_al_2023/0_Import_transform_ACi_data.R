## Data sent by Diane Wang and To-Chia Ting

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Lamour_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Ting_et_al_2023'))

# The data was already processed and put in the correct format
curated_data=read.csv('Aci_data.csv')

# Populate the 'Record' column with a unique number for each observation of each leaf 'SampleID'
# A record column was already included, but for simplicity I modify it so the first observation of each curve starts by one
for(SampleID in curated_data$SampleID){
  curated_data[curated_data$SampleID==SampleID,'Record']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
}

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
