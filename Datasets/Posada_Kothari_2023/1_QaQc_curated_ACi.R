## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Posada_Kothari_2023' folder where the data is located
setwd(file.path(path,'/Datasets/Posada_Kothari_2023'))

# Load the ACi data that were processed in step 0
load('0_curated_data.Rdata',verbose=TRUE)

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the ACi curves in the next step.
curated_data$QC='ok'

# Displaying Ci values to spot bad data
hist(curated_data$Ci) ## No below zero value
hist(curated_data$gsw) ## Some very low values
hist(curated_data$Qin)
hist(curated_data$Tleaf)
hist(curated_data$RHs)

# Flagging the gsw below 0.01 as bad data (this is somehow subjective)
curated_data[curated_data$gsw<0.01&!is.na(curated_data$gsw),'QC']='bad'
curated_data[curated_data$Ci>400&!is.na(curated_data$Ci),'QC']='bad'
curated_data[is.na(curated_data$A),'QC']='bad'

# Also removing the C4 species for now
curated_data[curated_data$SampleID_num%in%c(1,2,34,35),'QC']='bad'


# Keeping only the good points and curves
curated_data=curated_data[curated_data$QC=='ok',]

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')