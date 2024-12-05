list.of.packages <- c("pls","dplyr","reshape2","here","plotrix","ggplot2","gridExtra",
                      "spectratrait")
invisible(lapply(list.of.packages, library, character.only = TRUE))
path <- here()
source(file.path(path,'R/Auto_plsr.R'))
source(file.path(path,'R/Photosynthesis_tools.R'))


##############################
### Importing the datasets ###
##############################
setwd(path)

wv=400:2400 ## Wavelengths used for the PLSr

# Importing the database
Database_p1=read.csv(file=file.path(path,"database/Database_p1.csv"))
Database_p2=read.csv(file=file.path(path,"database/Database_p2.csv"))
Database_p3=read.csv(file=file.path(path,"database/Database_p3.csv"))
Database=rbind.data.frame(Database_p1,Database_p2,Database_p3)
Database$Spectra=I(as.matrix(Database[,paste("Wave_.",wv,sep="")]))

hist(Database$Rdark)
hist(Database$Tleaf_Rdark)

Database$Rdark25=f.modified.arrhenius.inv(P = Database$Rdark,Tleaf = Database$Tleaf_Rdark+273.15,Ha = 46390,Hd=150650,s = 490)
hist(Database$Rdark25)

## Removing Na values to avoid any issue
Database <- Database[!is.na(Database$Rdark25),]

## Keeping only spectra trait measured on the same leaves
Database = Database[Database$Spectra_trait_pairing=="Same",]


## Keeping only relevant columns to reduce the database size
Database <- Database[,c("SampleID","Dataset_name","Rdark25","Spectra")]

f.plot.spec(Z = Database$Spectra,wv = wv)

## Only keeping full range spectra
ls_not_full_range=which(is.na(Database$Spectra),arr.ind = TRUE)[,1]
ls_not_full_range=ls_not_full_range[-which(duplicated(ls_not_full_range))]
Database=Database[-ls_not_full_range,]
Database=Database[Database$Dataset_name!="Ting_et_al_2023",] # Not using imaging spectroscopy yet
f.plot.spec(Z = Database$Spectra,wv = wv)

## Using a LOO PLSR model to identify outlier.
## This process takes 6 minutes
test_LOO <- plsr(Rdark25~ Spectra,ncomp = 25, data = Database, validation = "LOO")
res_LOO <- test_LOO$validation$pred[,1,25]-Database$Rdark25
hist(res_LOO)
abline(v=c(-2.6*sd(res_LOO),2.6*sd(res_LOO)))
outliers <- which(abs(res_LOO)>2.6*sd(res_LOO))
Database <- Database[-outliers,]

Database$StdError_Rdark25=NA

############################
#### PLSR models Rdark2525 ###
############################
setwd(file.path(path,'/PLSR'))
#### Using all the data sets together
inVar='Rdark25'

#### Splitting the dataset into calibration and validation
#### Here, I do a stratified random sampling by dataset, with 80 % of the observations within each dataset used for calibration
split_data <- spectratrait::create_data_split(dataset=Database,approach="base", split_seed=1, 
                                              prop=0.8, group_variables='Dataset_name')

training <- split_data$cal_data
validation <- split_data$val_data

plsr_model <- f.auto_plsr(inVar = inVar, training = training,validation = validation, 
                       file_name = paste0('Validation_Alldatasets_Rdark25_', Sys.Date()), wv = wv,pwr_transform = 0.5)


save(file="PLSR_model_Rdark25.Rdata",plsr_model,training,validation)
