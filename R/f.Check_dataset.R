

f.Check_data=function(folder_path=NA){
  library(spectratrait)
  
  print("### Beginning of tests ###")
  
  setwd(folder_path)

  
  #List of required files and required colnames
  ls_R_files=c("0_Import_transform_ACi_data.R","1_QaQc_curated_ACi.R","2_Fit_ACi.R","3_Import_transform_Reflectance.R","4_Import_transform_SampleDetails")
  ls_required_data_files=c("3_QC_Reflectance_data.Rdata","4_SampleDetails.Rdata","Site.csv","Description.csv")
  ls_ACi_files=c("0_curated_data.Rdata","1_QC_ACi_data.Rdata","2_Fitted_ACi_data.Rdata")
  Site_colnames=c("Site_name","Longitude","Latitude","Elevation","Biome_number")
  Bilan_colnames=c("SampleID_num","Vcmax25","Jmax25","TPU25","Rday25","StdError_Vcmax25","StdError_Jmax25","StdError_TPU25","StdError_Rday25","Tleaf","sigma","AIC","Model","Fitting_method","SampleID")
  Reflectance_colnames=c("SampleID","Spectrometer","Probe_type","Probe_model","Spectra_trait_pairing","Reflectance")
  SampleDetails_colnames=c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")
  Description_colnames=c("Authors","Acknowledgment","Dataset_DOI","Publication_DOI","Email")
  Rdark_colnames=c("SampleID","Rdark","Tleaf_Rdark")
  
  # List of files included in the dataset folder
  ls_files=dir()
  
  ############################################
  ###  Are all the needed files included ? ###
  ############################################
  # Checking if ls_required_data_files are all present
  if(all(ls_required_data_files%in%ls_files)){print("All the required Rdata files were included")} else {print(paste("Missing Rdata files:",paste(ls_required_data_files[which(!ls_required_data_files%in%ls_files)],collapse = ", ")))
    stop()}
  
  # Checking if all Aci files are present if at least one is present
  if(!all(ls_ACi_files%in%ls_files)&any(ls_ACi_files%in%ls_files)){print(paste(paste(ls_files[which(ls_ACi_files%in%ls_files)],collapse=", "),"were included in the folder but",paste(ls_ACi_files[which(!ls_ACi_files%in%ls_files)],collapse = " ,"),"is missing"))
    stop()}
  
  ## Checking if the Rdark data is included
  if("Rdark_data.Rdata"%in%ls_files){print("Rdark data included")
    is_Rdark=TRUE}else{print("Rdark data was not included in the dataset")
      is_Rdark=FALSE}
  
  is_Rdark_and_Aci=FALSE
  # If Rdark is not included, testing if all Aci files are included
  if(!"Rdark_data.Rdata"%in%ls_files&!all(ls_ACi_files%in%ls_files)){print("There is no Rdark data and no ACi files (or one of the required ACi files is missing)")
    stop()}else if("Rdark_data.Rdata"%in%ls_files&all(ls_ACi_files%in%ls_files)){is_Rdark_and_Aci=TRUE}

 
  #####################################################
  ###   Checking the Site and Description metadata  ###
  #####################################################
  Site=read.csv("Site.csv")
  
  if(any(!Site_colnames%in%colnames(Site))){print("!!! Your Site dataframe misses some columns:")
    print(Site_colnames[!Site_colnames%in%colnames(Site)])
    stop()}
  
  Description=read.csv("Description.csv")
  if(any(!Description_colnames%in%colnames(Description))){print("!!! Your Description dataframe misses some columns:")
    print(Description_colnames[!Description_colnames%in%colnames(Description)])
    stop()}
  
  load("4_SampleDetails.Rdata")
  
  if(any(is.na(c(Site$Site_name,Site$Latitude,Site$Longitude,Site$Biome_number)))){print("!!! You did not provide the Site_name, Latitude, Longitude or Biome number")
                                                                                  stop()}else("The Site.csv file looks ok")
  
  print(paste("Your dataset",unique(SampleDetails$Dataset_name),"includes",nrow(Site),"site(s):"))
  print(Site)
  
  if(any(is.na(c(Description$Authors,Description$Email)))){print("!!! You did not provide the author list or the contact email in the description file")
                                                                                  stop()}else if (is.na(Description$Acknowledgment)){print("No acknowledgements in the Description.csv file. Revise if this is a mistake")}else ("The Description.csv file looks ok")
  
  invisible(readline(prompt="Press [enter] to continue"))
  
  ############################################
  ### Checking fitted ACi data if included ###
  ############################################
  
  if("2_Fitted_ACi_data.Rdata"%in%ls_files){
    load(file ="2_Fitted_ACi_data.Rdata")
    if(any(!Bilan_colnames%in%colnames(Bilan))){print("!!! Your Bilan dataframe misses some columns:")
      print(Bilan_colnames[!Bilan_colnames%in%colnames(Bilan)])
      stop()}
    
    if(any(duplicated(Bilan$SampleID))){"!!! You have duplicated SampleID names in your Bilan dataframe"
      stop()}
    
    n_sampleID=nrow(Bilan[!is.na(Bilan$Vcmax25),])
    n_Vcmax25=nrow(Bilan[!is.na(Bilan$Vcmax25),])
    
    print("Is the histogram of Vcmax25 value correct? If not revise steps 0, 1, and 2")
    
    hist(Bilan$Vcmax25)
  } else {print("No Vcmax data included")}

  
  invisible(readline(prompt="Press [enter] to continue"))
  
  #################################
  ## Checking Reflectance data  ###
  #################################
  
  load(file ="3_QC_Reflectance_data.Rdata")
  
  if(any(!Reflectance_colnames%in%colnames(Reflectance))){print("!!! Your Reflectance dataframe misses some columns:")
    print(Reflectance_colnames[!Reflectance_colnames%in%colnames(Reflectance)])
    stop()}
  
  print("Does the reflectance look ok? If not revise step 3")
 
  if(any(!is.na(Reflectance$Reflectance)&Reflectance$Reflectance>70)){print("Some of your spectra have high reflectance values above 70%. Please check if this is expected")}
   f.plot.spec(Z = Reflectance$Reflectance,wv = 350:2500)
  
  invisible(readline(prompt="Press [enter] to continue"))
  if(any(duplicated(Reflectance$SampleID))){print("!!! You have duplicated SampleID names in your Reflectance dataframe")
                                            stop()}
  
  if("2_Fitted_ACi_data.Rdata"%in%ls_files){
    ls_SampleID_not_in_Reflectance=Bilan[!Bilan$SampleID%in%Reflectance$SampleID,"SampleID"]
    ls_SampleID_not_in_Bilan=Reflectance[!Reflectance$SampleID%in%Bilan$SampleID,"SampleID"]
    if(length(ls_SampleID_not_in_Reflectance)>0){print(paste("Some leaves in 2_Fitted_ACi_data.Rdata file do not have an associated Reflectance data, correct if necessary :",paste(ls_SampleID_not_in_Reflectance,collapse=" ")))}
    if(length(ls_SampleID_not_in_Bilan)>0){print(paste("Some Reflectance spectra do not have an associated leaf fitted ACi data in 2_Fitted_ACi_data.Rdata, correct if necessary :",paste(ls_SampleID_not_in_Bilan,collapse=" ")))}
  }
  if(mean(Reflectance$Reflectance,na.rm=TRUE)<1){print("Your reflectance data are expressed in 0-1. They should be expressed in percent from 0 to 100, please correct")
                                                  stop()}
  

  invisible(readline(prompt="Press [enter] to continue"))
  
  ####################################
  ### Checking SampleDetails data  ###
  ####################################
  
  load(file ="4_SampleDetails.Rdata")
  
  if(any(!SampleDetails_colnames%in%colnames(SampleDetails))){print("!!! Your SampleDetails dataframe misses some columns:")
    SampleDetails_colnames[!SampleDetails_colnames%in%colnames(SampleDetails)]}
  
  
  ## Is the site name given in this dataframe the same as the ones in the Site.csv file?
  
  if(any(!SampleDetails$Site_name%in%Site$Site_name)){print("The site names in SampleDetails do not correspond to the site names you provided in Site.csv. Please correct 4_Import_transform_SampleDetails.R or Site.csv")
    print(paste("Site_name in SampleDetails:",paste(unique(SampleDetails$Site_name),collapse = " ")))
    print(paste("Site_name in Site.csv:",paste(unique(Site$Site_name),collapse = " ")))
    stop()}
  if(any(!SampleDetails$Sun_Shade%in%c("Sun","Shade",NA))){print("Column Sun_Shade only accepts Sun Shade or NA values")
                                                          stop()}
  if(any(!SampleDetails$Phenological_stage%in%c("Young","Mature","Old"))){print("Column Phenological_stage only accepts Young, Mature or Old values")
                                                          stop()}
  if(any(!SampleDetails$Plant_type%in%c("Wild","Agricultural"))){print("Column Plant_type only accepts Wild or Agricultural values")
                                                          stop()}
  if(any(!SampleDetails$Soil%in%c("Natural","Managed","Pot","Hydroponic"))){print("Column Soil only accepts Natural, Managed, Pot, and Hydroponic values")
                                                          stop()}
  
  
  if("2_Fitted_ACi_data.Rdata"%in%ls_files){
    ls_SampleID_not_in_SampleDetails=Bilan[!Bilan$SampleID%in%SampleDetails$SampleID,"SampleID"]
    if(length(ls_SampleID_not_in_SampleDetails)>0){paste("Some leaves in 2_Fitted_ACi_data.Rdata file do not have an associated SampleDetails data, correct if necessary :",paste(ls_SampleID_not_in_SampleDetails,collapse=" "))}
    ls_SampleID_not_in_Bilan=SampleDetails[!SampleDetails$SampleID%in%Bilan$SampleID,"SampleID"]
    if(length(ls_SampleID_not_in_Bilan)>0){paste("Some leaf in SampleDetails do not have an associated leaf fitted ACi data in 2_Fitted_ACi_data.Rdata, correct if necessary :",paste(ls_SampleID_not_in_Bilan,collapse=" "))}
  }
  
   
  mean_LMA=mean(SampleDetails$LMA,na.rm=TRUE)
  mean_Narea=mean(SampleDetails$Narea,na.rm=TRUE)
  mean_Nmass=mean(SampleDetails$Nmass,na.rm=TRUE)
  mean_LWC=mean(SampleDetails$LWC,na.rm=TRUE)
  
  if(is.nan(mean_LMA)){print("No LMA data included. Consider adding LMA values if you have them")} else if(mean_LMA<20|mean_LMA>200){
    print(paste("Your average LMA looks low or high:",mean_LMA,"can you check if LMA is expressed in g. m-2?"))
    invisible(readline(prompt="Press [enter] to continue"))}
  if(is.nan(mean_Narea)){print("No Narea data included. Consider adding Narea values if you have them")} else if(mean_Narea<1|mean_Narea>10){
    print(paste("Your average Narea looks low or high:",mean_Narea,"can you check if Narea is expressed in g. m-2?"))
    invisible(readline(prompt="Press [enter] to continue"))}
  if(is.nan(mean_Nmass)){print("No Nmass data included. Consider adding Nmass values if you have them")} else if(mean_Nmass<10|mean_Nmass>100){
    print(paste("Your average Nmass looks low or high:",mean_Nmass,"can you check if Nmass is expressed in mg.g-1?"))
    invisible(readline(prompt="Press [enter] to continue"))}
  if(is.nan(mean_LWC)){print("No LWC data included. Consider adding LWC values if you have them")} else if(mean_LWC<20|mean_LWC>95){
    print(paste("Your average LWC looks low or high:",mean_LWC,"can you check if LWC is expressed in %?"))
    invisible(readline(prompt="Press [enter] to continue"))}

  
  #####################################
  ## Checking Rdark data if included ##
  #####################################
  
  if("Rdark_data.Rdata"%in%ls_files){ load("Rdark_data.Rdata")
                                      if(any(!Rdark_colnames%in%colnames(Rdark))){print("!!! Rdark colnames are not valid.")
                                                                                  stop()}
                                      if(is.nan(mean(Rdark$Tleaf_Rdark,na.rm=TRUE))){print("!!! Tleaf_Rdark values are required but are not provided")
                                        stop()}
                                      if(mean(Rdark$Tleaf_Rdark,na.rm=TRUE)>70){print("!!! Rdark Tleaf values seem high. Are you sure they are in degree Celcius?")
                                        stop()}
                                      if(!any(Rdark$SampleID%in%SampleDetails$SampleID)){print("SampleID in Rdark data do not match SampleID in SampleDetails")
                                                                                        stop()}}else(print("Optional Rdark data not included in the dataset"))
  
  ############################################################
  ## Checking if all the data files can be merged together  ##
  ############################################################
  ## There are three cases: 1) ACi and Rdark data are included, 2)  Rdark data only are included, 3) ACi only are included
  
  print("Checking if all the data can be merged together")
  if(is_Rdark_and_Aci){ ## case 1
    test=try({
      load(file = "Rdark_data.Rdata")
      Bilan=merge(x=Bilan,y=Rdark,by="SampleID",all=TRUE)
      Dataset_data=merge(x=SampleDetails[,SampleDetails_colnames],y=Bilan[,Bilan_colnames],by="SampleID",all=FALSE)
      Dataset_data=merge(x=Dataset_data,y=Reflectance[,Reflectance_colnames],by="SampleID",all=FALSE)
      Dataset_data=merge(x=Dataset_data,y=Site,by="Site_name")
      Dataset_data=cbind.data.frame(Dataset_data,Description)},silent=TRUE)
  }else if(is_Rdark){ ## case 2
    test=try({
      load(file = "Rdark_data.Rdata")
      Bilan = data.frame(matrix(ncol = length(Bilan_colnames), nrow = 0))
      colnames(Bilan)=Bilan_colnames
      Bilan=merge(x=Bilan,y=Rdark,by="SampleID",all.y=TRUE)
      Dataset_data=merge(x=SampleDetails[,SampleDetails_colnames],y=Bilan[,Bilan_colnames],by="SampleID",all=FALSE)
      Dataset_data=merge(x=Dataset_data,y=Reflectance[,Reflectance_colnames],by="SampleID",all=FALSE)
      Dataset_data=merge(x=Dataset_data,y=Site,by="Site_name")
      Dataset_data=cbind.data.frame(Dataset_data,Description)},silent=TRUE)
  } else { ## case 3
    test=try({
      Bilan$Rdark=NA
      Bilan$Tleaf_Rdark=NA
      Dataset_data=merge(x=SampleDetails[,SampleDetails_colnames],y=Bilan[,Bilan_colnames],by="SampleID",all=FALSE)
      Dataset_data=merge(x=Dataset_data,y=Reflectance[,Reflectance_colnames],by="SampleID",all=FALSE)
      Dataset_data=merge(x=Dataset_data,y=Site,by="Site_name")
      Dataset_data=cbind.data.frame(Dataset_data,Description)},silent=TRUE)
  }

  if(class(test)=="data.frame"){print("The data was successfully merged")}else({print("!!! The data could not be merged.")
                                                                                      stop()})
  
print("### End of tests ###")
}
