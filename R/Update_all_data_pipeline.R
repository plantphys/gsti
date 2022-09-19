library(here)
path <- here()

refit_aci <- FALSE
recombine_spec_trait <- FALSE

## Re-run all the '2_Fit_Aci.R' codes
if(refit_aci) {
  print("**** NOT IMPLEMENTED YET ****")
}
  
## Re-run all the '3_Combine_spectra_traits' codes - to update existing data or add new
if(recombine_spec_trait) {
  ls_files <- dir(path = path, recursive = TRUE)
  ls_files <- ls_files[which(grepl(x=ls_files,pattern="3_Combine_spectra_traits.R",ignore.case = TRUE))]
  ls_files <- file.path(path,ls_files)
  for(i in seq_along(ls_files)){
    print(ls_files[i])
    source(ls_files[i])
    Sys.sleep(1)
  }
} else {
  print("**** Skipping re-creation of full spectra-trait dataset **** ")
}


## Re-run the PLSR models
#source('C:/Users/jlamour/Documents/GitHub/Global_Vcmax/PLSR/PLSR_models.R')
print("**** Re-fitting PLSR models **** ")
source(file.path(here(),'PLSR/PLSR_models.R'))

## Re-run the summary and create the maps and tables for the read me
#source('C:/Users/jlamour/Documents/GitHub/Global_Vcmax/R/Datasets_Map_and_resume.R')
print("**** Creating dataset information and study map **** ")
source(file.path(here(),'R/Datasets_Map_and_resume.R'))


### EOF