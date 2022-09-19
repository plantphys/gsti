list.of.packages <- c("pls","dplyr","reshape2","here","plotrix","ggplot2","gridExtra",
                      "spectratrait")
invisible(lapply(list.of.packages, library, character.only = TRUE))
path <- here()
#source(paste(path,'/R/Auto_plsr.R',sep=''))
source(file.path(path,'R/Auto_plsr.R'))

##############################
### Importing the datasets ###
##############################
setwd(path)

ls_files <- dir(recursive = TRUE)
ls_files_Curated <- ls_files[which(grepl(x=ls_files,pattern="3_Spectra_traits.Rdata",ignore.case = TRUE))]
data_curated=data.frame()
for(i in seq_along(ls_files_Curated)) {
  load(ls_files_Curated[i],verbose=TRUE)
  data_curated <- rbind.data.frame(data_curated,spectra)
}

## Keeping only the wavelength 400 to 2400
## !! TODO: Should change this to something like ~450+ because of SNR issues at < 450 nm
start_wave <- 450
end_wave <- 2400
orig_wavelengths <- seq(350, 2500, 1)
orig_wave_index <- seq_along(orig_wavelengths)
waves_index <- orig_wave_index[which(orig_wavelengths>=start_wave & 
                                       orig_wavelengths<=end_wave)]
select_waves <- orig_wavelengths[waves_index]

#data_curated$Spectra <- data_curated$Spectra[,51:2051]
#data_curated$Spectra <- data_curated$Spectra[,151:2051]
data_curated$Spectra <- data_curated$Spectra[,waves_index]


## Squaring Vcmax25 to 'normalize' its distribution
data_curated$sqrt_Vcmax25=sqrt(data_curated$Vcmax25)
data_curated$sqrt_Vcmax25_JB=sqrt(data_curated$Vcmax25_JB)
hist(data_curated$Vcmax25)
hist(data_curated$Vcmax25_JB)
hist(data_curated$sqrt_Vcmax25) 
hist(data_curated$sqrt_Vcmax25_JB) 
## Removing Na values to avoid any issue
data_curated <- data_curated[!is.na(data_curated$sqrt_Vcmax25),]

## Using a LOO PLSR model to identify wrong data
test_LOO <- plsr(sqrt_Vcmax25~ Spectra,ncomp = 19, data = data_curated, validation = "LOO")
res_LOO <- test_LOO$validation$pred[,1,19]-data_curated$sqrt_Vcmax25
outliers <- which(abs(res_LOO)>3*sd(res_LOO))
data_curated <- data_curated[-outliers,]
############################
#### PLSR models VCMAX25 ###
############################
#setwd(paste(path,'/PLSR',sep = ''))
setwd(file.path(path,'/PLSR'))
#### Using all the data sets together
inVar='sqrt_Vcmax25'
method <- "base" 

#### Splitting the dataset into calibration and validation
#### Here, I do a stratified random sampling by dataset, with 80 % of the observations within each dataset used for calibration
split_data <- spectratrait::create_data_split(dataset=data_curated,approach=method, split_seed=2356812, 
                                              prop=0.8, group_variables='dataset')

cal.plsr.data <- split_data$cal_data
val.plsr.data <- split_data$val_data

plsr_model <- f.auto_plsr(inVar = inVar, cal.plsr.data = cal.plsr.data, val.plsr.data = val.plsr.data, 
                       file_name = paste0('Validation_Alldatasets_', Sys.Date()), wv = select_waves)

result_random=data.frame(Obs=plsr_model$Obs,Pred=plsr_model$Pred,dataset=val.plsr.data$dataset)
result_random$Vcmax25_Obs=result_random$Obs^2
result_random$Vcmax25_Pred=result_random$Pred^2

stat_random=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result_random))
jpeg("Validation_random.jpeg", height=130, width=170,units = 'mm',res=300)
ggplot(data=result_random,aes(x=Vcmax25_Obs,y=Vcmax25_Pred,color=dataset))+theme_bw() +
  geom_point(size=0.5)+xlim(0,max(c(result_random$Vcmax25_Obs,result_random$Vcmax25_Pred))) +
  ylim(0,max(c(result_random$Vcmax25_Obs,result_random$Vcmax25_Pred))) +
  geom_abline(slope=1)+geom_smooth(method='lm',se=FALSE) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  xlab(expression(Observed~italic(V)[cmax25]))+ylab(expression(Predicted~italic(V)[cmax25])) +
  ggtitle(paste0("Validation: ", paste0("R2 = ", round(stat_random$r.squared,2)), "; ", 
                 paste0("RMSEP = ", round(stat_random$sigma,1)),"; ", paste0("nComps = ", 
                                                                             plsr_model$nComps)))
dev.off()
#### Here, I successively use each dataset as a validation dataset and all the others as calibration
#### I fixe the number of components to the number of components used in the random split (just above)
#### to homogenize the comparisons between models
result=data.frame()
ls_dataset=unique(data_curated$dataset)
for(dataset_validation in ls_dataset){
  cal.plsr.data <- data_curated[!data_curated$dataset==dataset_validation,]
  val.plsr.data <- data_curated[data_curated$dataset==dataset_validation,]
  res=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data, 
                  file_name = paste('Validation',dataset_validation,sep='_'), method=19, wv=select_waves)
  result=rbind.data.frame(result,data.frame(Obs=res$Obs,Pred=res$Pred,dataset_validation=dataset_validation))
}

result$Vcmax25_Obs=result$Obs^2
result$Vcmax25_Pred=result$Pred^2

Table_R2_all=data.frame()
for(dataset_validation in ls_dataset){
  reg=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result[result$dataset_validation==dataset_validation,]))
  Table_R2_all=rbind.data.frame(Table_R2_all,data.frame(dataset_validation=dataset_validation,dataset_removed=NA,R2=reg$r.squared))
}


stat_dataset=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result))

jpeg("Validation_datasets.jpeg", height=130, width=170,units = 'mm',res=300)
ggplot(data=result,aes(x=Vcmax25_Obs,y=Vcmax25_Pred,color=dataset_validation))+theme_bw()+
  geom_point(size=0.5)+xlim(0,max(c(result$Vcmax25_Obs,result$Vcmax25_Pred)))+
  ylim(0,max(c(result$Vcmax25_Obs,result$Vcmax25_Pred)))+
  geom_abline(slope=1)+geom_smooth(method='lm')+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(expression(Observed~italic(V)[cmax25]))+ylab(expression(Predicted~italic(V)[cmax25]))+
    ggtitle(paste0("Validation: ", paste0("R2 = ", round(stat_dataset$r.squared,2)), "; ", 
                   paste0("RMSEP = ", round(stat_dataset$sigma,1)),"; ", paste0("nComps = ", 
                                                                                plsr_model$nComps)))
dev.off()
  

############################
#### PLSR models Vcmax25_JB ###
############################
setwd(paste(path,'/PLSR',sep = ''))
#### Using all the data sets together
inVar='sqrt_Vcmax25_JB'
method <- "base" 

#### Splitting the dataset into calibration and validation
#### Here, I do a stratified random sampling by dataset, with 80 % of the observations within each dataset used for calibration
split_data <- spectratrait::create_data_split(dataset=data_curated,approach=method, split_seed=2356812, 
                                              prop=0.8, group_variables='dataset')

cal.plsr.data <- split_data$cal_data
val.plsr.data <- split_data$val_data

plsr_model=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data, 
                       file_name = paste0('Validation_Alldatasets_',Sys.Date(),"_",inVar), wv = select_waves)

result_random=data.frame(Obs=plsr_model$Obs,Pred=plsr_model$Pred,dataset=val.plsr.data$dataset)
result_random$Vcmax25_Obs=result_random$Obs^2
result_random$Vcmax25_Pred=result_random$Pred^2

stat_random=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result_random))
jpeg("Validation_random_JB.jpeg", height=130, width=170,units = 'mm',res=300)
ggplot(data=result_random,aes(x=Vcmax25_Obs,y=Vcmax25_Pred,color=dataset))+theme_bw()+
  geom_point(size=0.5)+xlim(0,max(c(result_random$Vcmax25_Obs,result_random$Vcmax25_Pred)))+
  ylim(0,max(c(result_random$Vcmax25_Obs,result_random$Vcmax25_Pred)))+
  geom_abline(slope=1)+geom_smooth(method='lm',se=FALSE)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(expression(Observed~italic(V)[cmax25]))+ylab(expression(Predicted~italic(V)[cmax25]))+
  ggtitle(paste0("Validation: ", paste0("R2 = ", round(stat_random$r.squared,2)), "; ", 
                 paste0("RMSEP = ", round(stat_random$sigma,1)),"; ", paste0("nComps = ", 
                                                                             plsr_model$nComps)))
dev.off()
#### Here, I successively use each dataset as a validation dataset and all the others as calibration
#### I fixed the number of components to the number of components used in the random split (just above)
#### to homogenize the comparisons between models

## !!TODO: Confirm that we want to be hard-coding the number of components in these tests !!

result=data.frame()
ls_dataset=unique(data_curated$dataset)
for(dataset_validation in ls_dataset){
  cal.plsr.data <- data_curated[!data_curated$dataset==dataset_validation,]
  val.plsr.data <- data_curated[data_curated$dataset==dataset_validation,]
  res=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data, 
                  file_name = paste('Validation',dataset_validation,sep='_'),method=19,wv=select_waves)
  result=rbind.data.frame(result,data.frame(Obs=res$Obs,Pred=res$Pred,dataset_validation=dataset_validation))
}

result$Vcmax25_Obs=result$Obs^2
result$Vcmax25_Pred=result$Pred^2

Table_R2_all=data.frame()
for(dataset_validation in ls_dataset){
  reg=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result[result$dataset_validation==dataset_validation,]))
  Table_R2_all=rbind.data.frame(Table_R2_all,data.frame(dataset_validation=dataset_validation, 
                                                        dataset_removed=NA,R2=reg$r.squared))
}


stat_dataset=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result))

jpeg("Validation_dataset_JB.jpeg", height=130, width=170,units = 'mm',res=300)
ggplot(data=result,aes(x=Vcmax25_Obs,y=Vcmax25_Pred,color=dataset_validation))+theme_bw()+
  geom_point(size=0.5)+xlim(0,max(c(result$Vcmax25_Obs,result$Vcmax25_Pred)))+
  ylim(0,max(c(result$Vcmax25_Obs,result$Vcmax25_Pred)))+
  geom_abline(slope=1)+geom_smooth(method='lm')+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(expression(Observed~italic(V)[cmax25]))+ylab(expression(Predicted~italic(V)[cmax25]))+
  ggtitle(paste0("Validation: ", paste0("R2 = ", round(stat_dataset$r.squared,2)), "; ", 
                 paste0("RMSEP = ", round(stat_dataset$sigma,1)),"; ", paste0("nComps = ", 
                                                                              plsr_model$nComps)))
dev.off()


#### Here, I want to evaluate the information present in each dataset, or another words,
#### I want to evaluate how important is each one of the dataset in the overall performance of
#### the model
#
#result2=data.frame()
#
#for(dataset_validation in ls_dataset){
#  for(dataset_removed in ls_dataset[-which(ls_dataset==dataset_validation)]){
#    cal.plsr.data <- data_curated[!data_curated$dataset%in%c(dataset_validation,dataset_removed),]
#    val.plsr.data <- data_curated[data_curated$dataset==dataset_validation,]
#    res=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data,file_name = NULL,method=19,wv=400:2400)
#    result2=rbind.data.frame(result2,data.frame(Obs=res$Obs,Pred=res$Pred,dataset_validation=dataset_validation,dataset_removed=dataset_removed))
#  }
#}
#
#result2$Vcmax25_Obs=result2$Obs^2
#result2$Vcmax25_Pred=result2$Pred^2
#
#Table_R2=data.frame()
#for(dataset_validation in ls_dataset){
#  for(dataset_removed in ls_dataset[-which(ls_dataset==dataset_validation)]){
#    reg=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result2[result2$dataset_validation==dataset_validation&result2$dataset_removed==dataset_removed,]))
#    Table_R2=rbind.data.frame(Table_R2,data.frame(dataset_validation=dataset_validation,dataset_removed=dataset_removed,R2=reg$r.squared))
#  }
#}
#
#for(dataset_validation in ls_dataset){
#  Table_R2[Table_R2$dataset_validation==dataset_validation,'R2_all']=Table_R2_all[Table_R2_all$dataset_validation==dataset_validation,'R2']
#}
#
#Table_R2$Effect_removed=Table_R2$R2_all-Table_R2$R2
#
#
##### Here, I want to evaluate the information present in each dataset alone to predict the others
#result3=data.frame()
#
#for(dataset_calibration in ls_dataset){
#    print(paste('Dataset for calibration =',dataset_calibration))
#    cal.plsr.data <- data_curated[data_curated$dataset%in%c(dataset_calibration),]
#    val.plsr.data <- data_curated[!data_curated$dataset==dataset_calibration,]
#    try({res=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data,file_name = 'test.pdf',wv=400:2400,seg=10,method = 9)
#    result3=rbind.data.frame(result3,data.frame(Obs=res$Obs,Pred=res$Pred,dataset_calibration=dataset_calibration,dataset_validation=val.plsr.data$dataset))})
#}
#result3$Vcmax25_Obs=result3$Obs^2
#result3$Vcmax25_Pred=result3$Pred^2
#
#Table_R2_indiv=data.frame()
#for(dataset_validation in ls_dataset){
#  for(dataset_calibration in ls_dataset[-which(ls_dataset==dataset_validation)]){
#    try({
#      reg=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result3[result3$dataset_calibration==dataset_calibration&result3$dataset_validation==dataset_validation,]))
#    Table_R2_indiv=rbind.data.frame(Table_R2_indiv,data.frame(dataset_calibration=dataset_calibration,dataset_validation=dataset_validation,R2=reg$r.squared))
#    })
#  }
#}
#
#Table_R2_indiv_all=data.frame()
#  for(dataset_calibration in ls_dataset){
#    try({
#      reg=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result3[result3$dataset_calibration==dataset_calibration,]))
#      Table_R2_indiv_all=rbind.data.frame(Table_R2_indiv_all,data.frame(dataset_calibration=dataset_calibration,R2=reg$r.squared))
#    })
#}#