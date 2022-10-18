library(here)
path = here()
setwd(file.path(path,'/Datasets/Yan_et_al_2021'))
getwd()

source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))

load('1_QC_data.Rdata',verbose=TRUE)
curated_data$Tleaf=curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan=f.fit_Aci(measures=curated_data,param = f.make.param())## After manual inspection, those fittings seem fine, at least for Vcmax.


## Fitting quality check
# Are there particularly low or high VcmaxRef?
hist(Bilan$VcmaxRef)

# Here, I look at the residual standard error and try to identify bad curves
Bilan[Bilan$sigma/Bilan$VcmaxRef>quantile(x = Bilan$sigma/Bilan$VcmaxRef,probs = 0.95),'SampleID_num']

# I check if the JmaxRef/ VcmaxRef ratio look correct
plot(x=Bilan$VcmaxRef,y=Bilan$JmaxRef,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)),ylim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(JmaxRef~0+VcmaxRef,data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

## Comparison with authors Vcmax
authors=read_xlsx(path = 'Yan et al., 2021. NPH. Spectra-Vcmax25 data.xlsx',sheet=2)
authors=merge(x=authors,y=Bilan,by.x='Leaf Code',by.y='SampleID')
plot(x=authors$VcmaxRef,y=authors$`Vcmax25 (umol m-2 s-1)`,xlab='Vcmax25',ylab='Vcmax25_authors')
abline(a = c(0,1))
save(Bilan,file='2_Result_ACi_fitting.Rdata')
