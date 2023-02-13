

f.Check_data=function(folder_path=NA){
print("### Beginning of tests ###")
  setwd(folder_path)
  library(spectratrait)
  ls_R_files=c("0_Import_transform_ACi_data.R","1_QaQc_curated_ACi.R","2_Fit_ACi.R","3_Import_transform_Reflectance.R","4_Import_transform_SampleDetails")
  ls_data_files=c("0_curated_data.Rdata","1_QC_ACi_data.Rdata","2_Fitted_ACi_data.Rdata","3_QC_Reflectance_data.Rdata","4_SampleDetails.Rdata","Site.csv","Description.csv")
  ls_files=dir()
  
  ## Are all the required Rdata files present in the folder?
  if(all(ls_data_files%in%ls_files)){"All the required Rdata files were included"} else {(print(paste("Missing Rdata files:",ls_data_files[which(!ls_data_files%in%ls_files)])))
    stop()}
 
  ## Checking the Site and Description metadata
  Site=read.csv("Site.csv")
  
  Site_colnames=c("Site_name","Longitude","Latitude","Elevation","Biome_number")
  if(any(!Site_colnames%in%colnames(Site))){print("!!! Your Site dataframe misses some columns:")
    print(Site_colnames[!Site_colnames%in%colnames(Site)])
    stop()}
  
  
  Description=read.csv("Description.csv")
  load("4_SampleDetails.Rdata")
  if(any(is.na(c(Site$Site_name,Site$Latitude,Site$Longitude,Site$Biome_number)))){print("!!! You did not provide the Site_name, Latitude, Longitude or Biome number")
                                                                                  stop()}else("The Site.csv file looks ok")
  print(paste("Your dataset",unique(SampleDetails$Dataset_name),"includes",nrow(Site),"site(s):"))
  print(Site)
  if(any(is.na(c(Description$Authors,Description$Email)))){print("!!! You did not provide the author list or the contact email in the description file")
                                                                                  stop()}else if (is.na(Description$Acknowledgment)){print("No acknowledgements in the Description.csv file. Revise if this is a mistake")}else ("The Description.csv file looks ok")
  invisible(readline(prompt="Press [enter] to continue"))
  
  ## Checking Vcmax data
  load(file ="2_Fitted_ACi_data.Rdata")
  Bilan_colnames=c("SampleID_num","Vcmax25","Jmax25","TPU25","Rday25","StdError_Vcmax25","StdError_Jmax25","StdError_TPU25","StdError_Rday25","Tleaf","sigma","AIC","Model","Fitting_method","SampleID")
  if(any(!Bilan_colnames%in%colnames(Bilan))){print("!!! Your Bilan dataframe misses some columns:")
    print(Bilan_colnames[!Bilan_colnames%in%colnames(Bilan)])
    stop()}
  
  
  if(any(duplicated(Bilan$SampleID))){"!!! You have duplicated SampleID names in your Bilan dataframe"
                                      stop()}
  n_sampleID=nrow(Bilan[!is.na(Bilan$Vcmax25),])
  n_Vcmax25=nrow(Bilan[!is.na(Bilan$Vcmax25),])
  print("Is the histogram of Vcmax25 value correct? If not revise steps 0, 1, and 2")
  hist(Bilan$Vcmax25)
  invisible(readline(prompt="Press [enter] to continue"))
  
  ## Checking Reflectance data
  load(file ="3_QC_Reflectance_data.Rdata")
  Reflectance_colnames=c("SampleID","Spectrometer","Leaf_clip","Reflectance")
  if(any(!Reflectance_colnames%in%colnames(Reflectance))){print("!!! Your Reflectance dataframe misses some columns:")
    print(Reflectance_colnames[!Reflectance_colnames%in%colnames(Reflectance)])
    stop()}
  
  print("Does the reflectance look ok? If not revise step 3")
  f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)
  
  if(any(duplicated(Reflectance$SampleID))){print("!!! You have duplicated SampleID names in your Reflectance dataframe")
                                            stop()}
  ls_SampleID_not_in_Reflectance=Bilan[!Bilan$SampleID%in%Reflectance$SampleID,"SampleID"]
  ls_SampleID_not_in_Bilan=Reflectance[!Reflectance$SampleID%in%Bilan$SampleID,"SampleID"]
  if(length(ls_SampleID_not_in_Reflectance)>0){print(paste("Some leaves in 2_Fitted_ACi_data.Rdata file do not have an associated Reflectance data, correct if necessary :",paste(ls_SampleID_not_in_Reflectance,collapse=" ")))}
  if(length(ls_SampleID_not_in_Bilan)>0){print(paste("Some Reflectance spectra do not have an associated leaf fitted ACi data in 2_Fitted_ACi_data.Rdata, correct if necessary :",paste(ls_SampleID_not_in_Bilan,collapse=" ")))}
  if(mean(Reflectance$Reflectance,na.rm=TRUE)<1){print("Your reflectance data are expressed in 0-1. They should be expressed in percent from 0 to 100, please correct")
                                                  stop()}
  invisible(readline(prompt="Press [enter] to continue"))
  
  ## Checking SampleDetails data
  load(file ="4_SampleDetails.Rdata")
  SampleDetails_colnames=c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")
  if(any(!SampleDetails_colnames%in%colnames(SampleDetails))){print("!!! Your SampleDetails dataframe misses some columns:")
    SampleDetails_colnames[!SampleDetails_colnames%in%colnames(SampleDetails)]}
  if(any(!SampleDetails$Sun_Shade%in%c("Sun","Shade",NA))){print("Column Sun_Shade only accepts Sun Shade or NA values")
                                                          stop()}
  if(any(!SampleDetails$Plant_type%in%c("Wild","Agricultural"))){print("Column Plant_type only accepts Wild or Agricultural values")
                                                          stop()}
  if(any(!SampleDetails$Soil%in%c("Natural","Managed","Pot"))){print("Column Soil only accepts Natural, Managed and Pot values")
                                                          stop()}
  
  ls_SampleID_not_in_SampleDetails=Bilan[!Bilan$SampleID%in%SampleDetails$SampleID,"SampleID"]
  ls_SampleID_not_in_Bilan=SampleDetails[!SampleDetails$SampleID%in%Bilan$SampleID,"SampleID"]
  if(length(ls_SampleID_not_in_SampleDetails)>0){paste("Some leaves in 2_Fitted_ACi_data.Rdata file do not have an associated SampleDetails data, correct if necessary :",paste(ls_SampleID_not_in_SampleDetails,collapse=" "))}
  if(length(ls_SampleID_not_in_Bilan)>0){paste("Some leaf in SampleDetails do not have an associated leaf fitted ACi data in 2_Fitted_ACi_data.Rdata, correct if necessary :",paste(ls_SampleID_not_in_Bilan,collapse=" "))}
  mean_LMA=mean(SampleDetails$LMA,na.rm=TRUE)
  mean_Narea=mean(SampleDetails$Narea,na.rm=TRUE)
  mean_Nmass=mean(SampleDetails$Nmass,na.rm=TRUE)
  mean_LWC=mean(SampleDetails$LWC,na.rm=TRUE)
  if(is.nan(mean_LMA)){print("No LMA data included. Consider adding LMA values if you have them")} else if(mean_LMA<20|mean_LMA>200){paste("Your average LMA looks low or high:",mean_LMA,"can you check if LMA is expressed in g. m-2?")}
  if(is.nan(mean_Narea)){print("No Narea data included. Consider adding Narea values if you have them")} else if(mean_Narea<1|mean_Narea>10){paste("Your average Narea looks low or high:",mean_Narea,"can you check if Narea is expressed in g. m-2?")}
  if(is.nan(mean_Nmass)){print("No Nmass data included. Consider adding Nmass values if you have them")} else if(mean_Nmass<10|mean_Nmass>100){paste("Your average Nmass looks low or high:",mean_Nmass,"can you check if Nmass is expressed in mg.g-1?")}
  if(is.nan(mean_LWC)){print("No LWC data included. Consider adding LWC values if you have them")} else if(mean_LWC<20|mean_LWC>95){paste("Your average LWC looks low or high:",mean_LWC,"can you check if LWC is expressed in %?")}
print("### End of tests ###")
}
