library(here)
path=here()
## Re-run all the '2_Fit_Aci.R' codes

## Re-run all the '3_Combine_spectra_traits' codes
ls_files=dir(path = path,recursive = TRUE)
ls_files=ls_files[which(grepl(x=ls_files,pattern="3_Combine_spectra_traits.R",ignore.case = TRUE))]
ls_files=paste(path,ls_files,sep='/')
for(file in ls_files){
  print(file)
  source(file)
}

## Re-run the PLSR models
source('C:/Users/jlamour/Documents/GitHub/Global_Vcmax/PLSR/PLSR_models.R')


## Re-run the summary and create the maps and tables for the read me
source('C:/Users/jlamour/Documents/GitHub/Global_Vcmax/R/Datasets_Map_and_resume.R')
