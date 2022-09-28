library(LeafGasExchange)
library(here)
path=here()
source(paste(path,'/R/fit_Vcmax.R',sep=''))

setwd(paste(path,'/Datasets/Barnes_et_al_2017',sep=''))

load('1_QC_data.Rdata',verbose=TRUE)
curated_data$Tleaf=curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan=f.fit_Aci(measures=curated_data,param = f.make.param())## After manual inspection, those fittings seem fine, at least for Vcmax.

Bilan[Bilan$sigma/Bilan$VcmaxRef>quantile(x = Bilan$sigma/Bilan$VcmaxRef,probs = 0.95),'SampleID_num']
## After manual inspection, those fittings seem fine, at least for Vcmax.

hist(Bilan$VcmaxRef)
plot(x=Bilan$VcmaxRef,y=Bilan$JmaxRef,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)),ylim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(JmaxRef~0+VcmaxRef,data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')




## Comparison with the Authors fitting

Author_fitting=read.csv(file='10_vcmax_jmax_estimates.csv')
Author_fitting=merge(x=Author_fitting,y=Bilan,by.x='fname',by.y='SampleID')
Bilan=merge(x=Bilan,y=Author_fitting[,c('fname','Vcmax','Jmax')],by.x='SampleID',by.y='fname')
save(Bilan,file='2_Result_ACi_fitting.Rdata')

param=f.make.param()
Author_fitting$Vcmax_new=f.modified.arrhenius(PRef = Author_fitting$VcmaxRef,Ha = param$VcmaxHa,Hd = param$VcmaxHd,s = param$VcmaxS,Tleaf = Author_fitting$Tleaf,TRef = 25+273.16)
plot(Author_fitting$Vcmax,Author_fitting$Vcmax_new)
plot(Author_fitting$Vcmax,Author_fitting$VcmaxRef,xlab='Vcmax25_Authors',ylab='Vcmax25_Us',xlim=c(40,150),ylim=c(40,150))
summary(lm(Author_fitting$Vcmax~Author_fitting$VcmaxRef))
abline(c(0,1))
