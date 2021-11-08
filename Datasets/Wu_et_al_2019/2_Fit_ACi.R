library(LeafGasExchange)
library(here)
path=here()
source(paste(path,'/R/fit_Aci.R',sep=''))
source(paste(path,'/R/fit_Aci_JB.R',sep=''))
setwd(paste(path,'/Datasets/Wu_et_al_2019',sep=''))

load('1_QC_data.Rdata',verbose=TRUE)
curated_data$Tleaf=curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan=f.fit_Aci(measures=curated_data,param = f.make.param(RdHd = 0,RdS = 0))## After manual inspection, those fittings seem fine, at least for Vcmax.
Bilan_JB=f.fit_Aci_JB(measures=curated_data,param = f.make.param_JB(RdHd = 0,RdS = 0))## After manual inspection, those fittings seem fine, at least for Vcmax.

Bilan=cbind.data.frame(Bilan,Bilan_JB)
Bilan[Bilan$sigma/Bilan$VcmaxRef>quantile(x = Bilan$sigma/Bilan$VcmaxRef,probs = 0.95),'SampleID_num']
## After manual inspection, those fittings seem fine, at least for Vcmax.

hist(Bilan$VcmaxRef)
plot(x=Bilan$VcmaxRef,y=Bilan$JmaxRef,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)),ylim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(JmaxRef~0+VcmaxRef,data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Result_ACi_fitting.Rdata')


## Comparison with the Authors fitting

Author_fitting=read.csv(file='Traits.csv')
Author_fitting=merge(x=Author_fitting,y=Bilan,by.x='BNL_UID',by.y='SampleID')
plot(Author_fitting$Vcmax25,Author_fitting$VcmaxRef)
abline(c(0,1))

