

f.Check_data=function(folder_path=NA){
  setwd(folder_path)
  library(spectratrait)
  ls_R_files=c("0_Import_transform_ACi_data.R","1_QaQc_curated_ACi.R","2_Fit_ACi.R","3_Import_transform_Reflectance.R","4_Import_transform_SampleDetails")
  ls_data_files=c("0_curated_data.Rdata","1_QC_ACi_data.Rdata","2_Fitted_ACi_data.Rdata","3_QC_Reflectance_data.Rdata","4_SampleDetails.Rdata","Site.csv","Description.csv")
  ls_files=dir()
  
  ## Are all the required Rdata files present in the folder?
  if(all(ls_data_files%in%ls_files))("All the required Rdata files were included") else (paste("Missing Rdata files:",ls_data_files[which(!ls_data_files%in%ls_files)]))
  
  ## Checking the Site and Description metadata
  Site=read.csv("Site.csv")
  Description=read.csv("Description.csv")
  load("4_SampleDetails.Rdata")
  if(any(is.na(c(Site$Site_name,Site$Latitude,Site$Longitude,Site$Biome_number))))("!!! You did not provide the Site_name, Latitude, Longitude or Biome number")else("The Site.csv file looks ok")
  print(paste("Your dataset",unique(SampleDetails$Dataset_name),"includes",nrow(Site),"site(s):"))
  print(Site)
  if(any(is.na(c(Description$Authors,Description$Email,Description$Acknowledgment))))("!!! You did not provide the author list, the acknowledgements or the contact email in the description file")else("The Description.csv file looks ok")
  invisible(readline(prompt="Press [enter] to continue"))
  
  ## Checking Vcmax data
  load(file ="2_Fitted_ACi_data.Rdata")
  if(any(duplicated(Bilan$SampleID)))("!!! You have duplicated SampleID names in your Bilan dataframe")
  n_sampleID=nrow(Bilan[!is.na(Bilan$Vcmax25),])
  n_Vcmax25=nrow(Bilan[!is.na(Bilan$Vcmax25),])
  print("Is the histogram of Vcmax25 value correct? If not revise steps 0, 1, and 2")
  hist(Bilan$Vcmax25)
  invisible(readline(prompt="Press [enter] to continue"))
  
  ## Checking Reflectance data
  load(file ="3_QC_Reflectance_data.Rdata")
  f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)
  
  if(any(duplicated(Reflectance$SampleID)))("!!! You have duplicated SampleID names in your Reflectance dataframe")
  ls_SampleID_not_in_Reflectance=Bilan[!Bilan$SampleID%in%Reflectance$SampleID,"SampleID"]
  ls_SampleID_not_in_Bilan=Reflectance[!Reflectance$SampleID%in%Bilan$SampleID,"SampleID"]
  if(length(ls_SampleID_not_in_Reflectance)>0){paste("Some leaves in 2_Fitted_ACi_data.Rdata file do not have an associated Reflectance data, correct if necessary :",paste(ls_SampleID_not_in_Reflectance,collapse=" "))}
  if(length(ls_SampleID_not_in_Bilan)>0){paste("Some Reflectance spectra do not have an associated leaf fitted ACi data in 2_Fitted_ACi_data.Rdata, correct if necessary :",paste(ls_SampleID_not_in_Bilan,collapse=" "))}
  if(mean(Reflectance$Reflectance,na.rm=TRUE)<1)("Your reflectance data are expressed in 0-1. They should be expressed in percent from 0 to 100, please correct")
  invisible(readline(prompt="Press [enter] to continue"))
  
  ## Checking SampleDetails data
  load(file ="4_SampleDetails.Rdata")
  ls_SampleID_not_in_SampleDetails=Bilan[!Bilan$SampleID%in%SampleDetails$SampleID,"SampleID"]
  ls_SampleID_not_in_Bilan=SampleDetails[!SampleDetails$SampleID%in%Bilan$SampleID,"SampleID"]
  if(length(ls_SampleID_not_in_SampleDetails)>0){paste("Some leaves in 2_Fitted_ACi_data.Rdata file do not have an associated SampleDetails data, correct if necessary :",paste(ls_SampleID_not_in_SampleDetails,collapse=" "))}
  if(length(ls_SampleID_not_in_Bilan)>0){paste("Some leaf in SampleDetails do not have an associated leaf fitted ACi data in 2_Fitted_ACi_data.Rdata, correct if necessary :",paste(ls_SampleID_not_in_Bilan,collapse=" "))}
  mean_LMA=mean(SampleDetails$LMA,na.rm=TRUE)
  mean_Narea=mean(SampleDetails$Narea,na.rm=TRUE)
  mean_Nmass=mean(SampleDetails$Nmass,na.rm=TRUE)
  mean_LWC=mean(SampleDetails$LWC,na.rm=TRUE)
  if(!is.nan(mean_LMA))if(mean_LMA<20|mean_LMA>200){paste("Your average LMA looks low or high:",mean_LMA,"can you check if LMA is expressed in g. m-2?")}
  if(!is.nan(mean_Narea))if(mean_Narea<1|mean_Narea>10){paste("Your average Narea looks low or high:",mean_Narea,"can you check if Narea is expressed in g. m-2?")}
  if(!is.nan(mean_Nmass))if(mean_Nmass<10|mean_Nmass>100){paste("Your average Nmass looks low or high:",mean_Nmass,"can you check if Nmass is expressed in mg.g-1?")}
  if(!is.nan(mean_LWC))if(mean_LWC<20|mean_LWC>95){paste("Your average LWC looks low or high:",mean_LWC,"can you check if LWC is expressed in %?")}
}
