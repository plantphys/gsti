library(here)
path <- here()

refit_aci <- FALSE
recombine_spec_trait <- FALSE

## Re-run all the '2_Fit_Aci.R' codes
if(refit_aci) {
  print("**** NOT IMPLEMENTED YET ****")
}
  
## Re-run all the '3_Import_transform_reflectance.R' codes - to update existing data or add new
if(recombine_spec_trait) {
  ls_files <- dir(path = path, recursive = TRUE)
  ls_files <- ls_files[which(grepl(x=ls_files,pattern="3_Import_transform_reflectance.R",ignore.case = TRUE))]
  ls_files <- file.path(path,ls_files)
  for(i in seq_along(ls_files)){
    print(ls_files[i])
    source(ls_files[i])
    Sys.sleep(1)
  }
} else {
  print("**** Skipping re-creation of full spectra-trait dataset **** ")
}


## Re-run all the '4_Import_transform_SampleDetails.R' codes - to update existing data or add new


## Create a curated database
ls_required_data_files=c("2_Fitted_ACi_data.Rdata","3_QC_Reflectance_data.Rdata","4_SampleDetails.Rdata","Site.csv","Description.csv")

ls_folder_dataset=list.dirs(file.path(here(),"Datasets"),recursive = FALSE)
database=data.frame()
for(dataset in ls_folder_dataset){
  print(dataset)
  ls_files=dir(dataset,recursive=FALSE)
  if(all(ls_required_data_files%in%ls_files)){
    print("Including dataset in the database")
    load(file = file.path(dataset,"2_Fitted_ACi_data.Rdata"),verbose=TRUE)
    load(file = file.path(dataset,"3_QC_Reflectance_data.Rdata"),verbose=TRUE)
    load(file = file.path(dataset,"4_SampleDetails.Rdata"),verbose=TRUE)
    Site=read.csv(file.path(dataset,"Site.csv"))
    Description=read.csv(file.path(dataset,"Description.csv"))
    Dataset_data=merge(x=Bilan,y=Reflectance,by="SampleID",all=FALSE)
    Dataset_data=merge(x=Dataset_data,y=SampleDetails,by="SampleID",all=FALSE)
    
    
    
    
    } else (
                                                print(" !!! Dataset not included: missing files"))
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