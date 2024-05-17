list.of.packages <- c("pls","dplyr","reshape2","here","plotrix","ggplot2","gridExtra",
                      "spectratrait")
invisible(lapply(list.of.packages, library, character.only = TRUE))
path <- here()
source(file.path(path,'R/Auto_plsr.R'))

##############################
### Importing the datasets ###
##############################
setwd(path)

wv=400:2400 ## Wavelengths used for the PLSr

# Importing the database
Database=read.csv(file=file.path(path,"database/Database.csv"))
Database$Spectra=I(as.matrix(Database[,paste("Wave_.",wv,sep="")]))

hist(Database$Jmax25)
hist(sqrt(Database$Jmax25)) 

## Removing Na values to avoid any issue
Database <- Database[!is.na(Database$Jmax25),]

## Keeping only relevant columns to reduce the database size
Database <- Database[,c("SampleID","Dataset_name","Jmax25","StdError_Jmax25","Spectra")]
Database$sqrt_Jmax25=sqrt(Database$Jmax25)
f.plot.spec(Z = Database$Spectra,wv = wv)

## Only keeping full range spectra
ls_not_full_range=which(is.na(Database$Spectra),arr.ind = TRUE)[,1]
ls_not_full_range=ls_not_full_range[-which(duplicated(ls_not_full_range))]
Database=Database[-ls_not_full_range,]
f.plot.spec(Z = Database$Spectra,wv = wv)

## Using a LOO PLSR model to identify outlier.
## This process takes 6 minutes
test_LOO <- plsr(sqrt_Jmax25~ Spectra,ncomp = 19, data = Database, validation = "LOO")
res_LOO <- test_LOO$validation$pred[,1,19]-Database$sqrt_Jmax25
hist(res_LOO)
abline(v=c(-3*sd(res_LOO),3*sd(res_LOO)))
outliers <- which(abs(res_LOO)>3*sd(res_LOO))# 
Database <- Database[-outliers,]
Database=Database[!is.na(Database$StdError_Jmax25)&Database$StdError_Jmax25<50,]

############################
#### PLSR models Jmax25 ###
############################
setwd(file.path(path,'/PLSR'))
#### Using all the data sets together
inVar='Jmax25'

#### Splitting the dataset into calibration and validation
#### Here, I do a stratified random sampling by dataset, with 80 % of the observations within each dataset used for calibration
split_data <- spectratrait::create_data_split(dataset=Database,approach="base", split_seed=1, 
                                              prop=0.8, group_variables='Dataset_name')

training <- split_data$cal_data
validation <- split_data$val_data

plsr_model <- f.auto_plsr(inVar = inVar, training = training,validation = validation, 
                       file_name = paste0('Validation_Alldatasets_', Sys.Date()), wv = wv,pwr_transform = 0.5)


jpeg("Figure2_Jmax25.jpeg", height=120, width=120,units = 'mm',res=300)
ggplot(data=plsr_model$Predictions,aes(y=Obs,x=mean_pred))+theme_bw()+
  geom_errorbar(data=plsr_model$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
#geom_errorbarh(data=interval_valid,aes(y=Obs,xmin=lwr_pred,xmax=upr_pred),alpha=0.3)
geom_errorbarh(data=plsr_model$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
geom_point()+coord_cartesian(xlim=c(0,450),ylim=c(0,450))+
  geom_abline(slope=1) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(J)[max25]))+xlab(expression(Predicted~italic(J)[max25]))+annotate(x=0,y=450,label=paste("R² =",round(plsr_model$R2,2)),"text",hjust=0,vjust=1)+annotate(x=0,y=420,label=paste("RMSE =",round(plsr_model$RMSE,1)),"text",hjust=0,vjust=1)
dev.off()

jpeg("Figure2_Jmax25_dataset.jpeg", height=120, width=180,units = 'mm',res=300)
ggplot(data=plsr_model$Predictions,aes(y=Obs,x=mean_pred,color=Dataset_name))+theme_bw()+
  geom_errorbar(data=plsr_model$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
  #geom_errorbarh(data=interval_valid,aes(y=Obs,xmin=lwr_pred,xmax=upr_pred),alpha=0.3)
  geom_errorbarh(data=plsr_model$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
  geom_point()+coord_cartesian(xlim=c(0,450),ylim=c(0,450))+
  geom_abline(slope=1) + geom_smooth(method="lm",se=FALSE)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(J)[max25]))+xlab(expression(Predicted~italic(J)[max25]))+annotate(x=0,y=450,label=paste("R² =",round(plsr_model$R2,2)),"text",hjust=0,vjust=1)+annotate(x=0,y=420,label=paste("RMSE =",round(plsr_model$RMSE,1)),"text",hjust=0,vjust=1)
dev.off()







#### Here, I successively use each dataset as a validation dataset and all the others as calibration
#### I set the number of components to the number of components used in the random split (just above)
#### to homogenize the comparisons between models
##result=data.frame()
##ls_dataset=unique(Database$Dataset_name)
##for(dataset_validation in ls_dataset){
##  cal.plsr.data <- Database[!Database$Dataset_name==dataset_validation,]
##  val.plsr.data <- Database[Database$Dataset_name==dataset_validation,]
##  res=f.auto_plsr(inVar = inVar,cal.plsr.data = cal.plsr.data,val.plsr.data = val.plsr.data, 
##                  file_name = paste('Validation',dataset_validation,sep='_'), method=20, wv=wv)
##  result=rbind.data.frame(result,data.frame(Obs=res$Obs,Pred=res$Pred,dataset_validation=dataset_validation))
##}
##
##result$Jmax25_Obs=result$Obs^2
##result$Jmax25_Pred=result$Pred^2
##
##Table_R2_all=data.frame()
##for(dataset_validation in ls_dataset){
##  reg=summary(lm(Jmax25_Pred~Jmax25_Obs,data=result[result$dataset_validation==dataset_validation,]))
##  Table_R2_all=rbind.data.frame(Table_R2_all,data.frame(dataset_validation=dataset_validation,dataset_removed=NA,R2=reg$r.squared))
##}
##
##
##stat_dataset=summary(lm(Jmax25_Pred~Jmax25_Obs,data=result))
##
##jpeg("Validation_datasets.jpeg", height=130, width=170,units = 'mm',res=300)
##ggplot(data=result,aes(x=Jmax25_Obs,y=Jmax25_Pred,color=dataset_validation))+theme_bw()+
##  geom_point(size=0.5)+xlim(0,max(c(result$Jmax25_Obs,result$Jmax25_Pred)))+
##  ylim(0,max(c(result$Jmax25_Obs,result$Jmax25_Pred)))+
##  geom_abline(slope=1)+geom_smooth(method='lm')+
##  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
##  xlab(expression(Observed~italic(V)[cmax25]))+ylab(expression(Predicted~italic(V)[cmax25]))+
##    ggtitle(paste0("Validation: ", paste0("R2 = ", round(stat_dataset$r.squared,2)), "; ", 
##                   paste0("RMSEP = ", round(stat_dataset$sigma,1)),"; ", paste0("nComps = ", 
##                                                                                plsr_model$nComps)))
##dev.off()
##  
##
##