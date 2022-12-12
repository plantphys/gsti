fpath <- "~/Global_Vcmax/"
setwd(fpath)
source('R/fit_Vcmax.R')
source('R/Photosynthesis_tools.R')
outfile <- 'Datasets/Kumagai_et_al_2022/2_Result_ACi_fitting.Rdata'


load('Datasets/Kumagai_et_al_2022/1_QC_data.Rdata',verbose = TRUE)
curated_data$Tleaf <- curated_data$Tleaf + 273.16 ## Conversion to kelvin
curated_data <- curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan <- f.fit_Aci(measures=curated_data,param = f.make.param())

Bilan[Bilan$sigma > quantile(x = Bilan$sigma, probs = 0.95), 'SampleID_num']
## After manual inspection, those fittings seem fine, at least for Vcmax.

hist(Bilan$VcmaxRef)
plot(x=Bilan$VcmaxRef,
     y=Bilan$JmaxRef,xlab='Vcmax25',
     ylab='Jmax25',
     xlim=c(min(c(Bilan$VcmaxRef, Bilan$JmaxRef), na.rm=TRUE), max(c(Bilan$VcmaxRef, Bilan$JmaxRef), na.rm = TRUE)),
     ylim=c(min(c(Bilan$VcmaxRef, Bilan$JmaxRef), na.rm=TRUE), max(c(Bilan$VcmaxRef, Bilan$JmaxRef), na.rm = TRUE)))
abline(a=c(0,1))
abline(lm(JmaxRef ~ 0 + VcmaxRef, data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID <- curated_data[!duplicated(curated_data$SampleID), c('SampleID','SampleID_num')]
Bilan <- merge(x = Bilan,y = Table_SampleID,by.x = 'SampleID_num',by.y = 'SampleID_num')

## SSuDouble would not have Jmax values per Meacham-Hensold's paper


save(Bilan,file = paste0(fpath, outfile))



