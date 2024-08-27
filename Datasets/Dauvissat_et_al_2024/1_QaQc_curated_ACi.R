## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Dauvissat_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Dauvissat_et_al_2024'))

# Load the ACi data that were processed in step 0
load('0_curated_data.Rdata',verbose=TRUE)

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the ACi curves in the next step.
curated_data$QC='ok'

# Displaying Ci values to spot bad data
hist(curated_data$Ci) ## No below zero value
hist(curated_data$RHs)
hist(curated_data$Tleaf)
hist(curated_data$A)
hist(curated_data$gsw)

#I create a "Quality check" table where I manually inform bad points. 
# When I start the quality check the QC table is empty: QC_table=cbind.data.frame(SampleID_num=c(),Record=c()) 
# I plot the data in the next step (line starting with pdf below). 
# I then manually check the plots and write down the SampleID_num and the Record corresponding to bad points
# This works well if there are few points to remove.
# You can use another method if you need.

QC_table=cbind.data.frame(SampleID_num=c(),
                          Record=c()) 
# Here I flag the bad curves by writing down the SampleID_num of the bad curves.
ls_bad_curve=c()

# Here I flag all the bad curves and bad points
curated_data[paste(curated_data$SampleID_num,curated_data$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'
curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'


# Keeping only the good points and curves
curated_data=curated_data[curated_data$QC=='ok',]

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')

