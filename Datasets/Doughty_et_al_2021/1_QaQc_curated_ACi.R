## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Doughty_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Doughty_et_al_2021'))

# Load the ACi data that were processed in step 0
load('0_curated_data.Rdata',verbose=TRUE)

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the ACi curves in the next step.
curated_data$QC='ok'



# Displaying Ci values to spot bad data
hist(curated_data$Ci) 
hist(curated_data$gsw) ## very low Ci values
hist(curated_data$Tleaf)
hist(curated_data$CO2s)
hist(curated_data$A)

# Flagging low gsw values as bad data
curated_data[curated_data$gsw<0.015,'QC']='bad'

# Flagging the below 0 A value as bad data, folowing Doughty et al. paper
curated_data[curated_data$A<0,'QC']='bad'

# Keeping only the good points and curves
curated_data=curated_data[curated_data$QC=='ok',]

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')