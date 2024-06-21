#--------------------------------------------------------------------------------------------------#
library(here)
library(dplyr)
path <- here()
setwd(file.path(path,'/Datasets/Serbin_et_al_2015'))

source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
load('1_QC_ACi_data.Rdata',verbose=TRUE)
head(curated_data)

curated_data <- curated_data[order(curated_data$SampleID_num,curated_data$Ci),]
head(curated_data)

# Print how many samples there are to fit
print(unique(curated_data$SampleID_num))
print(length(unique(curated_data$SampleID_num)))
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan <- f.fit_Aci(measures=curated_data,param = f.make.param())
## After manual inspection, those fittings seem fine, at least for Vcmax.
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
## Fitting quality check
# Are there particularly low or high Vcmax25?
hist(Bilan$Vcmax25)
range(Bilan$Vcmax25, na.rm=T)

# DROP bad curves here:
drop_rows <- which(Bilan$sigma/Bilan$Vcmax25 > quantile(x = Bilan$sigma/Bilan$Vcmax25, 
                                                        probs = 0.95, na.rm=T))

drop_rows
Bilan[drop_rows,'SampleID_num']
Bilan2 <- Bilan[-drop_rows,]
Bilan <- Bilan2
rm(Bilan2)

# I check if the Jmax25/ Vcmax25 ratio look correct
plot(x=Bilan$Vcmax25,y=Bilan$Jmax25,xlab='Vcmax25',ylab='Jmax25',
     xlim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE), 
            max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)), 
     ylim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),
            max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(Jmax25~0+Vcmax25,data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID <- curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
## Adding the SampleID column
Bilan <- merge(x=Bilan, y=Table_SampleID, by.x='SampleID_num', by.y='SampleID_num')
head(Bilan)

Bilan2 <- Bilan %>%
  select(SampleID_num, SampleID, Vcmax25, Jmax25, TPU25, Rday25, StdError_Vcmax25, 
         StdError_Jmax25, StdError_TPU25, StdError_Rday25, Tleaf, sigma, 
         AIC, Model, Fitting_method)
head(Bilan2)
Bilan <- Bilan2
head(Bilan)
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
# Output results
save(Bilan,file='2_Fitted_ACi_data.Rdata')
#--------------------------------------------------------------------------------------------------#

# 
# 
# 
# 
# 
# 
# 
# ## Comparison with previous fitting approach NEEDS UPDATING!!
# 
# old_fitted_data.1 <- read.csv(file = file.path(path,'/Datasets/Serbin_et_al_2015/LiCor_data/ag_sites/fitted/NASA_HyspIRI_Ag_Fitted_Gas_Exchange_Data.csv'),
#                               header = T)
# head(old_fitted_data.1)
# 
# sampID <- paste0(old_fitted_data.1$Sample_Name, "_", old_fitted_data.1$Rep, "_", 
#                  as.Date(as.character(old_fitted_data.1$Date), format = "%d/%m/%y"))
# old_fitted_data.1$Sample_ID_Name <- sampID
# old_fitted_data.1$SampleID <- as.numeric(as.factor(sampID))
# 
# 
# # Compare - Need to either standardize old data or convert Bilan Vcmax to Tleaf Vcmax
# # but the results are close!
# #comparison_data <- merge(x=old_fitted_data.1,y=Bilan,by='SampleID')
# #names(comparison_data)
# 
# comparison_data <- merge(x=old_fitted_data.1,y=Bilan,by.x='Sample_ID_Name', by.y="SampleID")
# names(comparison_data)
# 
# plot(x=comparison_data$Vcmax25,y=comparison_data$Fitted.Vcmax,xlab='Vcmax25',ylab='Vcmax25_authors',
#      xlim=c(30,400), ylim=c(30,400))
# abline(a = c(0,1))









# # Here, I look at the residual standard error and try to identify bad curves
# Bilan[Bilan$sigma/Bilan$Vcmax25>quantile(x = Bilan$sigma/Bilan$Vcmax25,probs = 0.95),'SampleID_num']
# # 6, 28
# 
# # I check if the Jmax25/ Vcmax25 ratio look correct
# plot(x=Bilan$Vcmax25,y=Bilan$Jmax25,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE), 
#                                                                           max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)), 
#      ylim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)))
# abline(a=c(0,1))
# abline(lm(Jmax25~0+Vcmax25,data=Bilan),col='red')
# 
# ## Adding the SampleID column
# Table_SampleID <- curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num','Sample_ID_Name')]
# Bilan <- merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')
# head(Bilan)
# 
# 
# 
# ## Comparison with previous fitting approach NEEDS UPDATING!!
# 
# old_fitted_data.1 <- read.csv(file = file.path('LiCor_data/ag_sites/fitted/CVARS_Compiled_ACi_Data_June2013.processed.csv'),
#                               header = T)
# head(old_fitted_data.1)
# 
# sampID <- paste0(old_fitted_data.1$Sample_Name, "_", old_fitted_data.1$Rep, "_", 
#                  as.Date(as.character(old_fitted_data.1$Date), format = "%d/%m/%y"))
# old_fitted_data.1$Sample_ID_Name <- sampID
# old_fitted_data.1$SampleID <- as.numeric(as.factor(sampID))
# 
# 
# # Compare - Need to either standardize old data or convert Bilan Vcmax to Tleaf Vcmax
# # but the results are close!
# comparison_data <- merge(x=old_fitted_data.1,y=Bilan,by='SampleID')
# names(comparison_data)
# plot(x=comparison_data$Vcmax25,y=comparison_data$Fitted.Vcmax,xlab='Vcmax25',ylab='Vcmax25_authors',
#      xlim=c(30,400), ylim=c(30,400))
# abline(a = c(0,1))
# 
# 
# # Output results
# save(Bilan,file='2_Fitted_ACi_data.Rdata')
