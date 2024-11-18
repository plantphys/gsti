## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)
library(ggplot2)
library(cowplot)
# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Vilas_Boas_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Vilas_Boas_et_al_2024'))

# Load the ACi data that were processed in step 0
load('0_curated_data.Rdata',verbose=TRUE)

######## This dataset has A-Ci data and survey data. The A-Ci data is first QaQc and then the survey data
survey=curated_data[curated_data$Method=="Survey",]
curated_data=curated_data[curated_data$Method=="ACi",]

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the ACi curves in the next step.
curated_data$QC='ok'

# Displaying Ci values to spot bad data
hist(curated_data$Ci) ## No below zero value
hist(curated_data$gsw,20)
hist(curated_data$RHs)

##Function to find and Remove duplicated values
Remove_Aci_dupplicate<-function(Aci_curve){
  ##Rounding the ci values
  Aci_curve=round(Aci_curve,-1)
  Remove=rep('NO',length(Aci_curve))
  ## We Remove the last point of the curve if it is a duplicate
  if(length(Aci_curve)%in%which(duplicated(Aci_curve))){Remove[length(Aci_curve)]='YES'}
  ## We Remove all the duplicates except the last one, so theoretically, if there are several 400 CO2 levels, only the last one is kept
  Remove[which(duplicated(Aci_curve[1:(length(Aci_curve))],fromLast = TRUE))]='YES'
  Remove[1:5]='NO'
  Remove[which(duplicated(Aci_curve[1:5],fromLast = TRUE))]='YES'
  return(Remove)
}

## The duplicated points are Removed using this function
Remove=ave(curated_data$CO2r,curated_data$SampleID,FUN=Remove_Aci_dupplicate)
curated_data[which(Remove=='YES'),'QC']='bad'

# I create a "Quality check" table where I manually inform bad points. 
# When I start the quality check the QC table is empty: QC_table=cbind.data.frame(SampleID_num=c(),Record=c()) 
# I plot the data in the next step (line starting with pdf below). 
# I then manually check the plots and write down the SampleID_num and the Record corresponding to bad points
# This works well if there are few points to remove.
# You can use another method if you need.

QC_table=cbind.data.frame(SampleID_num=c(24,25,52),
                          Record=c(2,1,1)) 
# Here I flag the bad curves by writing down the SampleID_num of the bad curves.
ls_bad_curve=c()

# Here I flag all the bad curves and bad points
curated_data[paste(curated_data$SampleID_num,curated_data$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'
curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'


# Creating a PDF file where all the ACi curves are plot. The points in red are bad points or curves and the points in black are ok.
pdf(file='1_QA_QC_Aci.pdf',)
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

#################### Dealing with the survey data
## Only keeping survey data at a Qin above 1700 mumol m-2 s-1
Qin=tapply(survey$Qin,survey$SampleID,mean)
survey=survey[survey$SampleID%in%names(Qin[Qin>1700]),]
survey$Record=as.numeric(survey$Record)
survey$QC="ok"
curated_survey=data.frame()
## Creation of a pdf to analyse the quality of the files
pdf(file='1_QA_QC_Survey.pdf')
for (SampleID_num in sort(unique(survey$SampleID_num))){
  selection1=survey[survey$SampleID_num==SampleID_num,]
  leaf=unique(selection1$SampleID_num)
  selection2=selection1[(nrow(selection1)-20):(nrow(selection1)-8),]
  #selection2=selection2[selection2$sel=='YES',]
  a=ggplot(data=selection1,aes(x=Record,y=A))+geom_point()+geom_point(data=selection2,aes(x=Record,y=A),color='red',size=2)+theme_classic()+ylim(c(max(-3,min(selection1$A,na.rm=TRUE)),min(30,max(selection1$A,na.rm=TRUE))))+ggtitle(leaf)
  b=ggplot(data=selection1,aes(x=Record,y=Ci))+geom_point()+geom_point(data=selection2,aes(x=Record,y=Ci),color='red',size=2)+theme_classic()+ylim(c(max(0,min(selection1$Ci,na.rm=TRUE)),min(500,max(selection1$Ci,na.rm=TRUE))))+ggtitle(leaf)
  print(plot_grid(a,b,ncol=2))
  curated_survey=rbind.data.frame(curated_survey,selection2)
}
dev.off()

# Here I flag the bad curves by writing down the SampleID_num of the bad curves.
ls_bad_curve=c(67,68)
# Removing one unstable point in curve 13
QC_table=cbind.data.frame(SampleID_num=c(13),
                          Record=c(351)) 

# Here I flag all the bad curves and bad points
curated_survey[paste(curated_survey$SampleID_num,curated_survey$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'
curated_survey[curated_survey$SampleID_num%in%ls_bad_curve,'QC']='bad'

# Keeping only the good points and curves
curated_survey=curated_survey[curated_survey$QC=='ok',]

# Averaging the survey gas exchange data by SampleID_num
curated_survey=aggregate(curated_survey[,c("Record","A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")],by=list(curated_survey$SampleID_num,curated_survey$SampleID,curated_survey$file,curated_survey$Method,curated_survey$QC),mean)
colnames(curated_survey)[1:5]=c("SampleID_num","SampleID","file","Method","QC")

curated_survey=curated_survey[curated_survey$gsw>0.015,]

# Combining the A-Ci and survey data
curated_data=rbind.data.frame(curated_data,curated_survey[,colnames(curated_data)])

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')