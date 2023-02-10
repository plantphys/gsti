library(here)
path = here()
setwd(file.path(path,'/Datasets/Burnett_et_al_2021'))
getwd()

source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))

load('1_QC_ACi_data.Rdata',verbose=TRUE)
curated_data$Tleaf=curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan=f.fit_Aci(measures=curated_data,param = f.make.param())## After manual inspection, those fittings seem fine, at least for Vcmax.


hist(Bilan$Vcmax25)
plot(x=Bilan$Vcmax25,y=Bilan$Jmax25,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)),ylim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)))
abline(a=c(0,1))
reg=lm(Jmax25~0+Vcmax25,data=Bilan)
reg_summary=summary(reg)
abline(reg,col='red')
abline(c(+1.96*reg_summary$sigma,reg$coefficients),col='grey')
abline(c(-1.96*reg_summary$sigma,reg$coefficients),col='grey')

## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Fitted_ACi_data.Rdata')

## Comparison with the Authors fitting
author_fitting=read.csv('seasonal-measurements-of-photosynthesis-and-leaf-traits-in-scarlet-oak.csv')
author_fitting=merge(x=author_fitting,y=Bilan,by.x = 'Sample_ID',by.y = 'SampleID')
plot(x=author_fitting$Vcmax25.x,y=author_fitting$Vcmax25.y,xlab='Author_Vcmax25',ylab='New_Vcmax25')
abline(c(0,1))
summary(lm(author_fitting$Vcmax25.x~author_fitting$Vcmax25.y))
