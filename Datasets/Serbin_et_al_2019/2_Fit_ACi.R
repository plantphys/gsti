library(LeafGasExchange)
library(here)
path <- here()
setwd(file.path(path,'/Datasets/Serbin_et_al_2019'))
getwd()

source(file.path(path,'/R/fit_Aci.R'))
#source(file.path(path,'/R/fit_Aci_JB.R'))

load('1_QC_data.Rdata',verbose=TRUE)
head(curated_data)

curated_data$Tleaf <- curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data <- curated_data[order(curated_data$SampleID_num,curated_data$Ci),]
head(curated_data)

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan <- f.fit_Aci(measures=curated_data,param = f.make.param(RdHd = 0,RdS = 0))
## After manual inspection, those fittings seem fine, at least for Vcmax.
#Bilan_JB <- f.fit_Aci_JB(measures=curated_data,param = f.make.param_JB(RdHd = 0,RdS = 0))
## After manual inspection, those fittings seem fine, at least for Vcmax.

#Bilan <- cbind.data.frame(Bilan,Bilan_JB)

## Fitting quality check
# Are there particularly low or high VcmaxRef?
hist(Bilan$VcmaxRef)
range(Bilan$VcmaxRef)

# Here, I look at the residual standard error and try to identify bad curves
Bilan[Bilan$sigma/Bilan$VcmaxRef>quantile(x = Bilan$sigma/Bilan$VcmaxRef,probs = 0.95),'SampleID_num']
# 6, 28

# I check if the JmaxRef/ VcmaxRef ratio look correct
plot(x=Bilan$VcmaxRef,y=Bilan$JmaxRef,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE), 
                                                                          max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)), 
     ylim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(JmaxRef~0+VcmaxRef,data=Bilan),col='red')

## Adding the SampleID column
Table_SampleID <- curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num','Sample_ID_Name')]
Bilan <- merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')
head(Bilan)



## Comparison with previous fitting approach NEEDS UPDATING!!

old_fitted_data.1 <- read.csv(file = file.path('LiCor_data/ag_sites/fitted/CVARS_Compiled_ACi_Data_June2013.processed.csv'),
                              header = T)
head(old_fitted_data.1)

sampID <- paste0(old_fitted_data.1$Sample_Name, "_", old_fitted_data.1$Rep, "_", 
                 as.Date(as.character(old_fitted_data.1$Date), format = "%d/%m/%y"))
old_fitted_data.1$Sample_ID_Name <- sampID
old_fitted_data.1$SampleID <- as.numeric(as.factor(sampID))


# Compare - Need to either standardize old data or convert Bilan Vcmax to Tleaf Vcmax
# but the results are close!
comparison_data <- merge(x=old_fitted_data.1,y=Bilan,by='SampleID')
names(comparison_data)
plot(x=comparison_data$VcmaxRef,y=comparison_data$Fitted.Vcmax,xlab='Vcmax25',ylab='Vcmax25_authors',
     xlim=c(30,400), ylim=c(30,400))
abline(a = c(0,1))


# Output results
save(Bilan,file='2_Result_ACi_fitting.Rdata')
