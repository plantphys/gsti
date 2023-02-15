list.of.packages <- c("pls","dplyr","reshape2","here","plotrix","ggplot2","gridExtra",
                      "spectratrait")
invisible(lapply(list.of.packages, library, character.only = TRUE))
path <- here()
source(file.path(path,'R/Auto_plsr.R'))

##############################
### Importing the datasets ###
##############################
setwd(path)


# Importing the database
Database=read.csv(file=file.path(path,"database/Database.csv"))
Database$Reflectance=I(as.matrix(Database[,31:2181]))
Database=Database[,c(1:30,2191)]

## Keeping only the wavelength 400 to 2400
start_wave <- 450
end_wave <- 2400
orig_wavelengths <- seq(350, 2500, 1)
orig_wave_index <- seq_along(orig_wavelengths)
waves_index <- orig_wave_index[which(orig_wavelengths>=start_wave & 
                                       orig_wavelengths<=end_wave)]
select_waves <- orig_wavelengths[waves_index]

Database$Reflectance <- Database$Reflectance[,waves_index]


## Squaring Vcmax25 to 'normalize' its distribution
Database$sqrt_Vcmax25=sqrt(Database$Vcmax25)

hist(Database$Vcmax25)
hist(Database$sqrt_Vcmax25) 
## Removing Na values to avoid any issue
Database <- Database[!is.na(Database$sqrt_Vcmax25),]

## Keeping only relevant columns to reduce the database size
Database <- Database[,c("SampleID","Dataset_name","sqrt_Vcmax25","Reflectance")]

## Using a LOO PLSR model to identify outlier.
## This process takes 6 minutes
test_LOO <- plsr(sqrt_Vcmax25~ Reflectance,ncomp = 19, data = Database, validation = "LOO")
res_LOO <- test_LOO$validation$pred[,1,19]-Database$sqrt_Vcmax25
hist(res_LOO)
abline(v=c(-3*sd(res_LOO),3*sd(res_LOO)))
outliers <- which(abs(res_LOO)>3*sd(res_LOO))
Database <- Database[-outliers,]


############################
#### PLSR models VCMAX25 ###
############################
setwd(file.path(path,'/PLSR'))
#### Using all the data sets together
inVar='sqrt_Vcmax25'
method <- "base" 

#### Splitting the dataset into calibration and validation
#### Here, I do a stratified random sampling by dataset, with 80 % of the observations within each dataset used for calibration
split_data <- spectratrait::create_data_split(dataset=Database,approach=method, split_seed=2356812, 
                                              prop=0.8, group_variables='Dataset_name')

cal.plsr.data <- split_data$cal_data
val.plsr.data <- split_data$val_data

plsr_model <- f.auto_plsr(inVar = inVar, cal.plsr.data = cal.plsr.data, val.plsr.data = val.plsr.data, 
                       file_name = paste0('Validation_Alldatasets_', Sys.Date()), wv = select_waves)

result_random=data.frame(Obs=plsr_model$Obs,Pred=plsr_model$Pred,Dataset_name=val.plsr.data$Dataset_name)
result_random$Vcmax25_Obs=result_random$Obs^2
result_random$Vcmax25_Pred=result_random$Pred^2

stat_random=summary(lm(Vcmax25_Pred~Vcmax25_Obs,data=result_random))
jpeg("Validation_random.jpeg", height=130, width=170,units = 'mm',res=300)
ggplot(data=result_random,aes(x=Vcmax25_Obs,y=Vcmax25_Pred,color=Dataset_name))+theme_bw() +
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
ls_dataset=unique(Database$Dataset_name)
for(dataset_validation in ls_dataset){
  cal.plsr.data <- Database[!Database$Dataset_name==dataset_validation,]
  val.plsr.data <- Database[Database$Dataset_name==dataset_validation,]
  res=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data, 
                  file_name = paste('Validation',dataset_validation,sep='_'), method=21, wv=select_waves)
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
  

