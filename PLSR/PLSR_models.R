list.of.packages <- c("pls","dplyr","reshape2","here","plotrix","ggplot2","gridExtra",
                      "spectratrait")
invisible(lapply(list.of.packages, library, character.only = TRUE))
path=here()
source(paste(path,'/R/Auto_plsr.R',sep=''))

##############################
### Importing the datasets ###
##############################
setwd(path)

ls_files=dir(recursive = TRUE)
ls_files_Curated=ls_files[which(grepl(x=ls_files,pattern="3_Spectra_traits.Rdata",ignore.case = TRUE))]
data_curated=data.frame()
for(files in ls_files_Curated){
  load(files,verbose=TRUE)
  data_curated=rbind.data.frame(data_curated,spectra)
}

## Keeping only the wavelength 400 to 2400
data_curated$Spectra=data_curated$Spectra[,51:2051]

## Squaring Vcmax25 to 'normalize' its distribution
data_curated$sqrt_Vcmax25=sqrt(data_curated$Vcmax25)
hist(data_curated$Vcmax25)
hist(data_curated$sqrt_Vcmax25) 

## Removing Na values to avoid any issue
data_curated=data_curated[!is.na(data_curated$sqrt_Vcmax25)]

#####################
#### PLSR models  ###
#####################
setwd(paste(path,'/PLSR',sep = ''))
#### Using all the data sets together
inVar='sqrt_Vcmax25'
method <- "base" 

#### Splitting the dataset into calibration and validation
#### Here, I do a stratified random sampling by dataset, with 80 % of the observations within each dataset used for calibration
split_data <- spectratrait::create_data_split(dataset=data_curated,approach=method, split_seed=2356812, 
                                              prop=0.8, group_variables='dataset')

cal.plsr.data <- split_data$cal_data
val.plsr.data <- split_data$val_data

plsr_model=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data,file_name = paste('Validation_Alldatasets',Sys.Date()),wv = 400:2400)

result_random=data.frame(Obs=plsr_model$Obs,Pred=plsr_model$Pred,dataset=val.plsr.data$dataset)
result_random$Vcmax25_Obs=result_random$Obs^2
result_random$Vcmax25_Pred=result_random$Pred^2

stat_random=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result_random))
jpeg("Validation_random.jpeg", height=170, width=200,units = 'mm',res=300)
ggplot(data=result_random,aes(x=Vcmax25_Obs,y=Vcmax25_Pred,color=dataset))+theme_bw()+
  geom_point(size=0.5)+xlim(0,max(c(result_random$Vcmax25_Obs,result_random$Vcmax25_Pred)))+
  ylim(0,max(c(result_random$Vcmax25_Obs,result_random$Vcmax25_Pred)))+
  geom_abline(slope=1)+geom_smooth(method='lm',se=FALSE)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(expression(Observed~italic(V)[cmax25]))+ylab(expression(Predicted~italic(V)[cmax25]))+
  ggtitle(paste0("Validation: ", paste0("R2 = ", round(stat_random$r.squared,2)), "; ", paste0("RMSEP = ", 
                                                                                           round(stat_random$sigma,1)),"; ", paste0("nComps = ", 
                                                                                              plsr_model$nComps)))
dev.off()
#### Here, I successively use each dataset as a validation dataset and all the others as calibration
#### I fixe the number of components to the number of components used in the random split (just above)
#### to homogenize the comparisons between models
result=data.frame()
for(dataset in unique(data_curated$dataset)){
  cal.plsr.data <- data_curated[!data_curated$dataset==dataset,]
  val.plsr.data <- data_curated[data_curated$dataset==dataset,]
  res=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data,file_name = paste('Validation',dataset,sep='_'),method=plsr_model$nComps,wv=400:2400)
  result=rbind.data.frame(result,data.frame(Obs=res$Obs,Pred=res$Pred,dataset=dataset))
}

result$Vcmax25_Obs=result$Obs^2
result$Vcmax25_Pred=result$Pred^2

stat_dataset=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result))

jpeg("Validation_datasets.jpeg", height=170, width=200,units = 'mm',res=300)
ggplot(data=result,aes(x=Vcmax25_Obs,y=Vcmax25_Pred,color=dataset))+theme_bw()+
  geom_point(size=0.5)+xlim(0,max(c(result$Vcmax25_Obs,result$Vcmax25_Pred)))+
  ylim(0,max(c(result$Vcmax25_Obs,result$Vcmax25_Pred)))+
  geom_abline(slope=1)+geom_smooth(method='lm')+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(expression(Observed~italic(V)[cmax25]))+ylab(expression(Predicted~italic(V)[cmax25]))+
    ggtitle(paste0("Validation: ", paste0("R2 = ", round(stat_dataset$r.squared,2)), "; ", paste0("RMSEP = ", 
                                                                                                 round(stat_dataset$sigma,1)),"; ", paste0("nComps = ", 
                                                                                                                                          plsr_model$nComps)))
dev.off()
  


