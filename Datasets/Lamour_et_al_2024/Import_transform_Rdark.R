## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Lamour_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Lamour_et_al_2024'))

# Importing the author's Rdark data
data_Rdark=read.csv("Brazil_2023_Rdark_data.csv")

data_Rdark=data_Rdark[data_Rdark$Remove=="NO",]

# Calculating the mean Rdark and Tleaf of each sample
Rdark=aggregate(x=data_Rdark[,c("Tleaf","A")],list(data_Rdark$SampleID),FUN=mean)

# Creating a Rdark dataframe
Rdark=data.frame(SampleID=Rdark$Group.1,Rdark=-Rdark$A,Tleaf_Rdark=Rdark$Tleaf)

# Checking data quality
hist(Rdark$Rdark) # No negative values
hist(Rdark$Tleaf_Rdark)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
