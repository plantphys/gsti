## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)


# Set the working directory to the 'Davidson_et_al_2023' folder where the data is located
path=here()
setwd(file.path(path,'/Datasets/Coast_et_al_2019'))

# Importing the author's Rdark data
data_Rdark <- read.csv("Coast_et_al_2019.csv")

# Creating a Rdark dataframe
Rdark <- data.frame(SampleID=data_Rdark$ID,Rdark=data_Rdark$Rd_LA,Tleaf_Rdark=25)

# Checking data quality
hist(Rdark$Rdark) # No negative values



# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
