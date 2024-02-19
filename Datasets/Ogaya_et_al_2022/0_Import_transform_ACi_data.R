## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Verryckt et al 2022.
## The dataset is available publicly : https://doi.org/10.5194/essd-14-5-2022


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Ogaya_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Ogaya_et_al_2022'))

# Import the authors original raw data
original_data=read.csv('GasEx_Verryckt_et_al_2022.csv')

# Select specific columns from the original data to create the curated data set
# Here I selected several times the column SampleID. This is because the Record and gsw columns were missing (column 2 and 7, respectively).
# I then rename this columns and populate them.

curated_data=original_data[,c("ID", "ID","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf","Tair")]

# Rename the columns of the curated dataset with the ESS standard
# I also kept the column "Remove" which is not part of the standard and that will be usefull to analyse the
# data quality. It corresponds to the author flagging of bad data. THis column doesnt have to be included
# in other datasets.
colnames(curated_data)=c(ESS_column,"Tair")

# The column Record was still filled with SampleID info. I replace by NA values
curated_data$Record = NA

# Populate the 'Record' column with a unique number for each observation of each leaf 'SampleID'
for(SampleID in curated_data$SampleID){
  curated_data[curated_data$SampleID==SampleID,'Record']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
}

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
