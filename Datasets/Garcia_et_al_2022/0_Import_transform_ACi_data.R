## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Garcia et al 2022.
## The dataset was sent by Loren Albert


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Garcia_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Garcia_et_al_2022'))

# Import the authors original raw data
li6400=read.csv('aci_df6400_clean.csv')
li6400=li6400[,c("SampleID", "Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf","data_qc")]
li6400$SampleID=toupper(li6400$SampleID)

li6800=read.csv('aci_df6800_clean.csv')
li6800=li6800[,c("SampleID", "obs","A","Ci","CO2_s","CO2_r","gsw","Pa","Qin","RHcham","Tleaf","data_qc")]
li6800$SampleID=toupper(substr(li6800$SampleID,12,nchar(li6800$SampleID)))

# Rename the columns of the curated dataset with the ESS standard
# I also kept the column "data_qc" which is not part of the standard and that will be usefull to analyse the
# data quality. It corresponds to the author flagging of bad data. THis column doesnt have to be included
# in other datasets.
colnames(li6400)=c(ESS_column,'Remove')
colnames(li6800)=c(ESS_column,'Remove')
curated_data=rbind.data.frame(li6400,li6800)
curated_data$Remove=toupper(curated_data$Remove)

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
