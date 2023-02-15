library(here)
path = here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2017'))
getwd()

source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))

load('1_QC_ACi_data.Rdata',verbose=TRUE)
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan=f.fit_Aci(measures=curated_data,param = f.make.param())## After manual inspection, those fittings seem fine, at least for Vcmax.

## Fitting quality check
# Are there particularly low or high Vcmax25?
hist(Bilan$Vcmax25)

Bilan[Bilan$sigma>quantile(x = Bilan$sigma,probs = 0.95),'SampleID_num']
## After manual inspection, those fittings seem fine, at least for Vcmax.


plot(x=Bilan$Vcmax25,y=Bilan$Jmax25,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)),ylim=c(min(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE),max(c(Bilan$Vcmax25,Bilan$Jmax25),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(Jmax25~0+Vcmax25,data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Fitted_ACi_data.Rdata')
