## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Montes et al 2022.
## The dataset was sent by Chris Montes


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Montes_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Montes_et_al_2022'))

# Import the authors original raw data
original_data=read.csv('Aci_data_2015.csv')

# The headers are present for each ACi curve. I check that they are consistent and delete them
hearder=original_data[original_data$MACHINE=="MACHINE",]
curated_data=original_data[-which(original_data$MACHINE=="MACHINE"),]

# The replicate is only filled in the first row of each curve. I fill the replicate for all the levels of the ACI curves
for (i in 1: nrow(curated_data)){
  if(curated_data[i,"Rep"]!=""){
    Replicate=curated_data[i,"Rep"]}else{curated_data[i,"Rep"]=Replicate}
}

#Adding a SampleID identifier
curated_data$SampleID=paste(curated_data$Cultivar,curated_data$Rep)

#Adding a number for each observation
for(SampleID in curated_data$SampleID){
  curated_data[curated_data$SampleID==SampleID,'Obs']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
}

# Select specific columns from the original data to create the curated data set
curated_data=curated_data[,c("SampleID", "Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf")]

# Rename the columns of the curated dataset with the ESS standard
colnames(curated_data)=c(ESS_column)

# Transform text into numeric

curated_data[,3:11]=matrix(as.numeric(as.matrix(curated_data[,3:11])),ncol=9)

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
