## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Verryckt_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Verryckt_et_al_2022'))

# Load the curated_data data that were processed in step 0
load('0_curated_data.Rdata',verbose=TRUE)

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the curated_data curves in the next step.
curated_data$QC='ok'

# Importing the reflectance data so we only keep the data with A-Ci and Reflectance data
load("3_QC_Reflectance_data.Rdata",verbose=TRUE)
curated_data=curated_data[curated_data$SampleID%in%Reflectance$SampleID,]

# Only keeping the curated_data curves, removing the respiration data
Respiration_data=curated_data[curated_data$Qin<10,]
save(Respiration_data,file="1_Raw_Respiration_data.Rdata")
curated_data=curated_data[curated_data$Qin>100,]

# Displaying Ci values to spot bad data
hist(curated_data$Ci) 
hist(curated_data$gsw)
curated_data[curated_data$gsw<0|curated_data$gsw>1,"QC"]="bad"
hist(curated_data[curated_data$QC=="ok","gsw"])
curated_data[curated_data$RHs>95,"QC"]="bad"


## For this dataset, I used a specific method for the QAQC since there is a lot of data

ls_done=dir(file.path(path,'/Datasets/Verryckt_et_al_2022/Curated_ACi'))
ls_done=sapply(X = ls_done,FUN = function(x){substr(x = x,start = 13,stop = nchar(x)-4)})

ls_todo=sort(unique(curated_data$SampleID_num))
ls_todo=ls_todo[!ls_todo%in%ls_done]

for(SampleID_num in ls_todo){

  print(paste("SampleID:",SampleID_num))
  curated_data_curve=curated_data[curated_data$SampleID_num==SampleID_num,]
  plot(x=curated_data_curve$Ci,y=curated_data_curve$A,main=SampleID_num,cex=2,xlab='Ci',ylab='A')
  text(x=curated_data_curve$Ci,y=curated_data_curve$A, labels=curated_data_curve$Record,cex=0.7)
  xy <- xy.coords(x=curated_data_curve$Ci, y=curated_data_curve$A)
  if(any(curated_data_curve$QC=="bad")){
    points(x=curated_data_curve[curated_data_curve$QC=="bad","Ci"],y=curated_data_curve[curated_data_curve$QC=="bad","Photo"],cex=2,col="red")
    text(x = curated_data_curve[curated_data_curve$QC=="bad","Ci"],y=curated_data_curve[curated_data_curve$QC=="bad","Photo"],labels=curated_data_curve[curated_data_curve$QC=="bad","Record"],cex=0.7,col = "red")
  }
  x=xy$x
  y=xy$y
  record_click<-identify(x=x,y=y,n=10,plot=TRUE)
  print("Bad point(s):")
  print(record_click,collapse = TRUE)
  if(length(record_click)>0){curated_data_curve[record_click,"QC"]="bad"
  points(x=curated_data_curve[curated_data_curve$QC=="bad","Ci"],y=curated_data_curve[curated_data_curve$QC=="bad","Photo"],cex=2,col="red")
  text(x = curated_data_curve[curated_data_curve$QC=="bad","Ci"],y=curated_data_curve[curated_data_curve$QC=="bad","Photo"],labels=curated_data_curve[curated_data_curve$QC=="bad","Record"],cex=0.7,col = "red")
  }
  Sys.sleep(0.5)
  ## Saving the data to be sure not to loose anything
  write.csv(curated_data_curve,file=paste("Curated_ACi/curated_data",SampleID_num,".csv",sep=""),row.names=FALSE)
  dev.off()
}

ls_bad_curve=c(150,161,202,215,216,218,237,247,248,386,419,430,431,452,455,457,467,468,516,518,519,523,524,583,608,612,617,623:626,651,652,657,675,681,684,687,695,697:702,704:706,711,712,716,722:723,733:736,747,749,757:759,769,772:773,779,790,791,793)

# Adding the curves for which the fitting did not work
ls_bad_curve=c(ls_bad_curve,23,157,194,314,470,567,580,721,761)
#Gathering all the files
ls_files=dir(file.path(path,'/Datasets/Verryckt_et_al_2022/Curated_ACi'))
curated_data=data.frame()
for(file in ls_files){
  print(file)
  data_file=read.csv(file.path(path,'/Datasets/Verryckt_et_al_2022/Curated_ACi/',file))
  curated_data=rbind.data.frame(curated_data,data_file)
}
curated_data[curated_data$SampleID_num%in%ls_bad_curve,"QC"]="bad"

# Creating a PDF file where all the curated_data curves are plot. The points in red are bad points or curves and the points in black are ok.
pdf(file='1_QA_QC_curated_data.pdf',)
for(SampleID_num in sort(unique(curated_data$SampleID_num))){
plot(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num,'A'],main=unique(curated_data[curated_data$SampleID_num==SampleID_num,'SampleID_num']),cex=2,xlab='Ci',ylab='A')
  text(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num,'A'], labels=curated_data[curated_data$SampleID_num==SampleID_num,'Record'],cex=0.7)
if(any(curated_data[curated_data$SampleID_num==SampleID_num,'QC']=='bad')){
  points(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'],cex=2,col='red')
  text(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'], labels=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Record'],cex=0.7,col='red')
}
}
dev.off()

# Keeping only the good points and curves
curated_data=curated_data[curated_data$QC=='ok',]

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')
