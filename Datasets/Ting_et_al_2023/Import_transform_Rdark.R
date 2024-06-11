## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Ting_et_al_2023' folder where the data is located
setwd(file.path(path,'/Datasets/Ting_et_al_2023'))

# Importing the author's Rdark data
Rdark=read.csv("ting_2023_predawn_assimilation_data.csv")

# Renaming the columns
colnames(Rdark)=c("SampleID","Rdark","Tleaf_Rdark")

# Converting from assimilation to respiration values
Rdark$Rdark=-Rdark$Rdark

# Checking data quality
hist(Rdark$Rdark) # No negative values
hist(Rdark$Tleaf_Rdark)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
