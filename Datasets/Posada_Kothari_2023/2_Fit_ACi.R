## This code is used to do the step 2 of the data curation process.
## It is used to fit the ACi curves and estimate the photosynthetic parameters


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Posa' folder where the data is located
setwd(file.path(path,'/Datasets/Posada_Kothari_2023'))

# Load various functions that are used to fit, plot and analyse the ACi curves
source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))

# Load the quality checked ACi curves processed in step 1
load('1_QC_ACi_data.Rdata',verbose=TRUE)


# Automatic fitting of the ACi curves. This function generates several pdf in the dataset folder
Bilan=f.fit_One_Point(measures=curated_data,param = f.make.param())

## Fitting quality check
# Are there particularly low or high Vcmax25?
hist(Bilan$Vcmax25)


# Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

# Saving the Bilan dataframe that contains the fitted parameters for each curve
save(Bilan,file='2_Fitted_ACi_data.Rdata')
