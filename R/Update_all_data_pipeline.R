library(here)
path <- here()

refit_aci <- FALSE
recombine_spec_trait <- FALSE
check_pipeline <- FALSE
update_database <-TRUE

## Re-run all the '2_Fit_Aci.R' codes

if(refit_aci) {
  ls_files <- dir(path = path, recursive = TRUE)
  ls_files <- ls_files[which(grepl(x=ls_files,pattern="2_Fit_ACi.R",ignore.case = TRUE))]
  ls_files <- file.path(path,ls_files)
  for(i in seq_along(ls_files)){
    print(ls_files[i])
    source(ls_files[i])
    Sys.sleep(1)
  }
} else {
  print("**** Skipping fitting of gas exchange data **** ")
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


## Re-run all the '4_Import_transform_SampleDetails.R' codes - This checks the overall pipeline!
if(check_pipeline) {
  ls_files <- dir(path = path, recursive = TRUE)
  ls_files <- ls_files[which(grepl(x=ls_files,pattern="4_Import_transform_SampleDetails.R",ignore.case = TRUE))]
  ls_files <- file.path(path,ls_files)
  for(i in seq_along(ls_files)){
    print(ls_files[i])
    source(ls_files[i])
    Sys.sleep(1)
  }
} else {
  print("**** Skipping checking the whole pipeline **** ")
}



## Update the curated database
if(update_database){
  ls_required_data_files=c("3_QC_Reflectance_data.Rdata","4_SampleDetails.Rdata","Site.csv","Description.csv")
  ls_ACi_files=c("0_curated_data.Rdata","1_QC_ACi_data.Rdata","2_Fitted_ACi_data.Rdata")
  ls_Rdark_files=c("Rdark_data.Rdata")
  #Bilan colnames with Rdark and Tleaf_Rdark included
  Bilan_colnames=c("Vcmax25","Jmax25","TPU25","Rday25","StdError_Vcmax25","StdError_Jmax25","StdError_TPU25","StdError_Rday25","Tleaf","sigma","AIC","Model","Fitting_method","SampleID","Rdark","Tleaf_Rdark") 
  Reflectance_colnames=c("SampleID","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing","Reflectance")
  SampleDetails_colnames=c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")
  Description_colnames=c("Authors","Acknowledgment","Dataset_DOI","Publication_DOI","Email")
  
  ls_folder_dataset=list.dirs(file.path(here(),"Datasets"),recursive = FALSE)
  database=data.frame()
  for(dataset in ls_folder_dataset){
    print(dataset)
    ls_files=dir(dataset,recursive=FALSE)
    if(all(ls_required_data_files%in%ls_files)&(all(ls_ACi_files%in%ls_files)|ls_Rdark_files%in%ls_files)){
      print("Including dataset in the database")
      
      load(file = file.path(dataset,"3_QC_Reflectance_data.Rdata"),verbose=TRUE)
      colnames(Reflectance$Reflectance)=paste("Wave_",350:2500)
      load(file = file.path(dataset,"4_SampleDetails.Rdata"),verbose=TRUE)
      Site=read.csv(file.path(dataset,"Site.csv"))
      Description=read.csv(file.path(dataset,"Description.csv"))
      
      if(all(ls_ACi_files%in%ls_files)){load(file = file.path(dataset,"2_Fitted_ACi_data.Rdata"),verbose=TRUE)}else{Bilan = data.frame(matrix(ncol = length(Bilan_colnames), nrow = 0))
      colnames(Bilan)=Bilan_colnames}
      if(ls_Rdark_files%in%ls_files){
        load(file = file.path(dataset,"Rdark_data.Rdata"))
        Bilan=merge(x=Bilan[,Bilan_colnames[-which(Bilan_colnames%in%c("Rdark","Tleaf_Rdark"))]],y=Rdark,all.y=TRUE)} else ({Bilan$Rdark=NA
                                              Bilan$Tleaf_Rdark=NA})
      Dataset_data=merge(x=SampleDetails[,SampleDetails_colnames],y=Bilan[,Bilan_colnames],by="SampleID",all=FALSE)
      Dataset_data=merge(x=Dataset_data,y=Reflectance[,Reflectance_colnames],by="SampleID",all=FALSE)
      Dataset_data=merge(x=Dataset_data,y=Site,by="Site_name")
      Dataset_data=cbind.data.frame(Dataset_data,Description)
      database=rbind.data.frame(database,Dataset_data)
    } else (print(" !!! Dataset not included: missing files"))
  }
  #Detach the matrix reflectance:
  Reflectance_matrix=database$Reflectance
  database=cbind.data.frame(database[,!colnames(database)%in%"Reflectance"],Reflectance_matrix)
  
  write.csv(database,file=file.path(path,"Database/Database.csv"),row.names = FALSE)
  print("Database successfully updated")
  
}

## Re-run the PLSR models
#print("**** Re-fitting PLSR models **** ")
#source(file.path(here(),'PLSR/PLSR_models.R'))

## Re-run the summary and create the maps and tables for the read me

print("**** Creating dataset information and study map **** ")
source(file.path(here(),'R/Datasets_Map_and_resume.R'))


### EOF