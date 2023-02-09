library(here)
path=here()
source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))
setwd(file.path(path,'/Datasets/Albert_et_al_2018'))


load('1_QC_ACi_data.Rdata',verbose=TRUE)
curated_data$Tleaf=curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan=f.fit_Aci(measures=curated_data,param = f.make.param())## After manual inspection, those fittings seem fine, at least for Vcmax.

#
# After seeing the pdf, I removed a lot of curves: 
## 8,12,15,17,18,20,21,32,47,48,56,58,68,86.
## Some were very noisy, or probably measured at a too low light irradiance

## Finding the curves with the highest standard deviation of the residuals
Bilan[Bilan$sigma>quantile(x = Bilan$sigma,probs = 0.95),'SampleID_num']
## After manual inspection, those fittings seem fine, at least for Vcmax.

hist(Bilan$Vcmax25) ## Checking the distribution of Vcmax25
plot(x=Bilan$Vcmax25,y=Bilan$Jmax25,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)),ylim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(Jmax25~0+Vcmax25,data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Fitted_ACi_data.Rdata')



