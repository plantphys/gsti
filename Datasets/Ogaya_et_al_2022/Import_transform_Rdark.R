## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Ogaya_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Ogaya_et_al_2022'))

# Importing the author's Rdark data that we imported in step 1
load("1_Raw_Respiration_data.Rdata",verbose=TRUE)
data_Rdark=Respiration_data
hist(data_Rdark$gsw)
hist(data_Rdark$RHs)
hist(data_Rdark$Tleaf)
data_Rdark=data_Rdark[data_Rdark$gsw>0&data_Rdark$gsw<1,]
data_Rdark=data_Rdark[data_Rdark$Tleaf<40,]
data_Rdark=data_Rdark[data_Rdark$RHs<95&data_Rdark$RHs>40,]


# Averaging the data per SampleID
Rdark=-tapply(X = data_Rdark$A,INDEX = data_Rdark$SampleID,FUN = mean,na.rm=TRUE)
Tleaf_Rdark=tapply(X=data_Rdark$Tleaf,INDEX = data_Rdark$SampleID,FUN = mean,na.rm=TRUE)

# Creating a Rdark dataframe
Rdark=data.frame(SampleID=names(Rdark),Rdark=Rdark,Tleaf_Rdark=Tleaf_Rdark)

# Checking data quality
hist(Rdark$Rdark) # No negative values
hist(Rdark$Tleaf_Rdark)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
