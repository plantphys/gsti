## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)


# Set the working directory to the 'Davidson_et_al_2023' folder where the data is located
path=here()
setwd(file.path(path,'/Datasets/Davidson_et_al_2023'))

# Importing the author's Rdark data
data_Rdark <- read.csv("Leaf_Trait_Data.csv")

# Creating a Rdark dataframe
Rdark <- data.frame(SampleID=data_Rdark$SampleID,Rdark=data_Rdark$Rdark,Tleaf_Rdark=data_Rdark$T_Rdark)

# Checking data quality
hist(Rdark$Rdark) # No negative values
hist(Rdark$Tleaf_Rdark)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
