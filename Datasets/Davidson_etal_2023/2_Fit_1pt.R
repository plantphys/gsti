setwd("~/Global_Vcmax-main/Datasets/Davidson_etal_2023")

source(file.path('~/Global_Vcmax-main/R/fit_Vcmax.R'))
source(file.path('~/Global_Vcmax-main/R/Photosynthesis_tools.R'))

load('1_QC_data.Rdata',verbose=TRUE)
curated_data$Tleaf <- curated_data$Tleaf+273.16 ## Conversion to kelvin

## Fitting of the ACi curves using Ac, Ac+Aj or Ac+Aj+Ap limitations
Bilan <-f.fit_One_Point(measures=curated_data,param = f.make.param())
Bilan$StdError_VcmaxRef <- "NA" # No St Error when only one point of fitting


## Fitting quality check
# Are there particularly low or high VcmaxRef?
hist(Bilan$VcmaxRef)


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Result_1pt_fitting.Rdata')
