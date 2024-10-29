## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)


# Set the working directory to the 'Ojo_et_al_2024' folder where the data is located
path=here()
setwd(file.path(path,'/Datasets/Ojo_et_al_2024'))

# Importing the author's Rdark data (in the same file as the reflectance data)

load('3_QC_Reflectance_data.Rdata',verbose=TRUE)
data_Rdark = Reflectance[,c("SampleID","Rdark_25C")]

# Creating a Rdark dataframe
Rdark <- data.frame(SampleID=data_Rdark$SampleID,Rdark=data_Rdark$Rdark_25C,Tleaf_Rdark=25)

# Checking data quality
hist(Rdark$Rdark) # No negative values



# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
