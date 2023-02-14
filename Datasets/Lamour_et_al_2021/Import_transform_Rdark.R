## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Lamour_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Lamour_et_al_2021'))

# Importing the author's Rdark data
data_Rdark=read.csv("PA-SLZ_2020_darkAdaptedRdark_data.csv")

# Averaging the one minute data per SampleID
Rdark=-tapply(X = data_Rdark$A,INDEX = data_Rdark$SampleID,FUN = mean,na.rm=TRUE)
Tleaf=tapply(X=data_Rdark$Tleaf,INDEX = data_Rdark$SampleID,FUN = mean,na.rm=TRUE)

# Creating a Rdark dataframe
Rdark=data.frame(SampleID=names(Rdark),Rdark=Rdark,Tleaf=Tleaf)

# Checking data quality
hist(Rdark$Rdark) # No negative values
hist(Rdark$Tleaf)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
