## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)


# Set the working directory to the 'Vijayakumar_et_al_2025' folder where the data is located
path=here()
setwd(file.path(path,'/Datasets/Vijayakumar_et_al_2025'))

# Importing the author's Rdark data
data_Rdark <- read.csv("Amrutha et al 2025-Tomato_Dark respiration and SVC data_combined.csv")

# Creating a Rdark dataframe
Rdark <- data.frame(SampleID=data_Rdark$Unique.ID,Rdark=data_Rdark$Rdark,Tleaf_Rdark=data_Rdark$Tleaf)

# Checking data quality
hist(Rdark$Rdark) # No negative values



# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
