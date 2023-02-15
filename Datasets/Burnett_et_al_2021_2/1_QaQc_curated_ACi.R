## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Burnett_et_al_2021_2' folder where the data is located
setwd(file.path(path,'/Datasets/Burnett_et_al_2021_2'))

# Load the data that were processed in step 0
# Note that this dataset coresponds to one point Vcmax
load('0_curated_data.Rdata',verbose=TRUE)

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the ACi curves in the next step.
curated_data$QC='ok'

# Displaying Ci values to spot bad data
hist(curated_data$Ci)

# Flagging the below 0 Ci as bad data
curated_data[curated_data$Ci<0,'QC']='bad'

# Displaying Ci values to spot bad data
hist(curated_data$gsw) # No below 0 gsw

hist(curated_data$A)
curated_data[curated_data$A<0,'QC']='bad'
hist(curated_data$Ci/curated_data$CO2s,breaks=20) ## I remove very low Ci/ca values
curated_data[curated_data$Ci/curated_data$CO2s<0.4,'QC']='bad'
curated_data[curated_data$Ci/curated_data$CO2s>0.9,'QC']='bad'
hist(curated_data$CO2s)
hist(curated_data$Tleaf)

plot(curated_data$gsw,curated_data$A*curated_data$RHs/curated_data$CO2s)

# Keeping only the good points and curves
curated_data=curated_data[curated_data$QC=='ok',]

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')