library(here)
path <- here()
## Re-run all the '2_Fit_Aci.R' codes

## Re-run all the '3_Combine_spectra_traits' codes
ls_files <- dir(path = path, recursive = TRUE)
ls_files <- ls_files[which(grepl(x=ls_files,pattern="3_Combine_spectra_traits.R",ignore.case = TRUE))]
ls_files <- file.path(path,ls_files)
for(i in seq_along(ls_files)){
  print(ls_files[i])
  source(ls_files[i])
  Sys.sleep(1)
}

## Re-run the PLSR models
#source('C:/Users/jlamour/Documents/GitHub/Global_Vcmax/PLSR/PLSR_models.R')
source(file.path(here(),'PLSR/PLSR_models.R'))

## Re-run the summary and create the maps and tables for the read me
#source('C:/Users/jlamour/Documents/GitHub/Global_Vcmax/R/Datasets_Map_and_resume.R')
source(file.path(here(),'R/Datasets_Map_and_resume.R'))