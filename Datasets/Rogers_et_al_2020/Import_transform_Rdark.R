## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Rogers_et_al_2020' folder where the data is located
setwd(file.path(path,'/Datasets/Rogers_et_al_2020'))

# Importing the author's Rdark data
data_Rdark=read.csv("Seward_2019_Rdark.csv")

# Creating a Rdark dataframe
Rdark=data.frame(SampleID=data_Rdark$SampleID,Rdark=-data_Rdark$Rdark,Tleaf_Rdark=data_Rdark$Tleaf)

# Checking data quality
hist(Rdark$Rdark) # No negative values
hist(Rdark$Tleaf_Rdark)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
