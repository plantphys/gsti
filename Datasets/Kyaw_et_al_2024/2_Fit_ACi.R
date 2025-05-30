library(here)
path <- here()

setwd(file.path(path,'/Datasets/Kyaw_et_al_2024'))

source(file.path(path,'/R/fit_Vcmax.R'))
source(file.path(path,'/R/Photosynthesis_tools.R'))


load('1_QC_ACi_data.Rdata',verbose=TRUE)

## Estimation of Vcmax using the one point method
Bilan = f.fit_One_Point(measures=curated_data,param = f.make.param())


## Fitting quality check
# Are there particularly low or high Vcmax25?
hist(Bilan$Vcmax25)
Bilan[Bilan$Vcmax25>250,]

## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Fitted_ACi_data.Rdata')
