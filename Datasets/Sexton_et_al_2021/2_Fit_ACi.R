library(here)
path = here()
setwd(file.path(path,'/Datasets/Sexton_et_al_2021'))
getwd()

source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))


load('1_QC_ACi_data.Rdata',verbose=TRUE)
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),] ## Sorting the points in the Aci curves so the ci are in an increasing order. It helps with the plots

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan=f.fit_Aci(measures=curated_data,param = f.make.param())## 

## I suspect that a lof of the curves where measured at subsaturating irradiance
## It is difficult to select the one that worked and the one that didnt. I decided to only keep the one where PU was limiting at high Ci
Bilan=Bilan[!is.na(Bilan$TPU25),]

hist(Bilan$Vcmax25)

## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Fitted_ACi_data.Rdata')