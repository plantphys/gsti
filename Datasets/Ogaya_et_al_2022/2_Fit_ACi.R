## This code is used to do the step 2 of the data curation process.
## It is used to fit the ACi curves and estimate the photosynthetic parameters


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Ogaya_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Ogaya_et_al_2022'))

# Load various functions that are used to fit, plot and analyse the ACi curves
source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))

# Load the quality checked ACi curves processed in step 1
load('1_QC_ACi_data.Rdata',verbose=TRUE)


# Sorting the points in the Aci curves so the ci are in an increasing order. It helps with the plots
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),] 


# Automatic fitting of the ACi curves. This function generates several pdf in the dataset folder
Bilan=f.fit_Aci(measures=curated_data,param = f.make.param())

# I manually check the fitting ("2_ACi_fitting_best_model.pdf").
# If some fittings are bad, I go back to step 1 and remobve the bad points or bad curves
# Here, the fittings looked ok, at least for Vcmax.


## Fitting quality check
# Are there particularly low or high Vcmax25?
hist(Bilan$Vcmax25)

# Here, I look at the residual standard error and try to identify bad curves.
Bilan[Bilan$sigma/Bilan$Vcmax25>quantile(x = Bilan$sigma/Bilan$Vcmax25,probs = 0.95),'SampleID_num']

# I check if the Jmax25/ Vcmax25 ratio look correct
plot(x=Bilan$Vcmax25,y=Bilan$Jmax25,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)),ylim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(Jmax25~0+Vcmax25,data=Bilan),col='red')

Bilan[Bilan$SampleID_num%in%c(66,68,76,133,148,160,232,405,406,721,724,746),"Jmax25"]=NA ## Removing Jmax25 in the curves where TPU was limiting before Jmax25

# Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

# Saving the Bilan dataframe that contains the fitted parameters for each curve
save(Bilan,file='2_Fitted_ACi_data.Rdata')
