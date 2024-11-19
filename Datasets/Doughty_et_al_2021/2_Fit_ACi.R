## This code is used to do the step 2 of the data curation process.
## It is used to fit the ACi curves and estimate the photosynthetic parameters


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Doughty_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Doughty_et_al_2021'))

# Load various functions that are used to fit, plot and analyse the ACi curves
source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))

# Load the quality checked ACi curves processed in step 1
load('1_QC_ACi_data.Rdata',verbose=TRUE)

# Estimation of Vcmax using the one point method
Bilan=f.fit_One_Point(measures = curated_data,param=f.make.param())

# I manually check the fitting ("2_ACi_fitting_best_model.pdf").
# If some fittings are bad, I go back to step 1 and remobve the bad points or bad curves
# Here, the fittings looked ok, at least for Vcmax.


## Fitting quality check
# Are there particularly low or high Vcmax25?
hist(Bilan$Vcmax25)

# Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

# Removing aberrant estimates
Bilan=Bilan[Bilan$Vcmax25>0&Bilan$Vcmax25<500,]
# Saving the Bilan dataframe that contains the fitted parameters for each curve
save(Bilan,file='2_Fitted_ACi_data.Rdata')
