library(here)
path <- here()

setwd(file.path(path,'/Datasets/Davidson_et_al_2023'))

source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))


load('1_QC_ACi_data.Rdata',verbose=TRUE)
curated_data$Tleaf <- curated_data$Tleaf+273.16 ## Conversion to kelvin

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan <-f.fit_One_Point(measures=curated_data,param = f.make.param())


## Fitting quality check
# Are there particularly low or high Vcmax25?
hist(Bilan$Vcmax25)


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Fitted_ACi_data.Rdata')
