## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'RodriguezCaton_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/RodriguezCaton_et_al_2024'))

# Load the ACi data that were processed in step 0
load('0_curated_data.Rdata',verbose=TRUE)

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the ACi curves in the next step.
curated_data$QC='ok'

# Displaying Ci values to spot bad data
hist(curated_data$Ci) 

# Flagging the below 0 and above 2000 Ci as bad data
curated_data[ curated_data$Ci<0 | curated_data$Ci>2000,'QC']='bad'


# I create a "Quality check" table where I manually inform bad points. 
# When I start the quality check the QC table is empty:
QC_table=cbind.data.frame(SampleID_num=c(),Record=c()) 
# I plot the data in the next step (line starting with pdf below). 
# I then manually check the plots and write down the SampleID_num and the Record corresponding to bad points
# This works well if there are few points to remove.
# You can use another method if you need.

# QC_table=cbind.data.frame(SampleID_num=c(1),
#                           Record=c(2,3,4,5))
# QC_table=rbind(QC_table, cbind.data.frame(SampleID_num=c(2),
#                           Record=c(2,3,4,5)))
QC_table=cbind.data.frame(SampleID_num=c(1,3,14,18,19,20,20,22,22,23,25,30,34,34,42,53,59,61,64,64,83,96,105,105),
                          Record=c(1,7,1,1,1,1,2,1,2,1,1,1,1,2,1,1,1,1,1,2,1,8,1,10)) ## Added by JL 2024/10/30

QC_table=rbind(QC_table, cbind.data.frame(SampleID_num=c(5),
                                          Record=c(10,12)))
QC_table=rbind(QC_table, cbind.data.frame(SampleID_num=c(16),
                                          Record=c(12)))
QC_table=rbind(QC_table, cbind.data.frame(SampleID_num=c(40),
                                          Record=c(4)))
QC_table=rbind(QC_table, cbind.data.frame(SampleID_num=c(81),
                                          Record=c(11)))

##
# Here I flag the bad curves by writing down the SampleID_num of the bad curves.
# ls_bad_curve=c(6,7,8,9,16,19:45,  #  ,20,21, 22,23,24,25,26,27,28,
#               58, 69, 71, 76,77,81,83, 86, 88, 89,91,93,95,99,101,104,105,108)
#ls_bad_curve=c(3, 6, 7, 8, 9, 67, 72, 73, 79, 82, 84, 85, 87, 89, 91, 95, 97, 100, 101, 104) # Milagros 3024/10/30
ls_bad_curve=c(2,6, 7, 8, 9,17,48,49,54,57, 67, 72, 73, 79, 82, 84, 85, 87, 89, 91, 95, 97, 100, 101, 104) # JL 3024/10/30


# Here I flag all the bad curves and bad points
curated_data[paste(curated_data$SampleID_num,curated_data$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'
curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'


# Creating a PDF file where all the ACi curves are plot. The points in red are bad points or curves and the points in black are ok.
pdf(file='1_QA_QC_Aci.pdf',)
for(SampleID_num in sort(unique(curated_data$SampleID_num))){
plot(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],
     y=curated_data[curated_data$SampleID_num==SampleID_num,'A'],
     main=unique(curated_data[curated_data$SampleID_num==SampleID_num,'SampleID_num']),
     cex=2,xlab='Ci',ylab='A')
  text(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],
       y=curated_data[curated_data$SampleID_num==SampleID_num,'A'], 
       labels=curated_data[curated_data$SampleID_num==SampleID_num,'Record'],cex=0.7)
if(any(curated_data[curated_data$SampleID_num==SampleID_num,'QC']=='bad')){
  points(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],
         y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'],
         cex=2,col='red')
  text(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],
       y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'], 
       labels=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Record'],cex=0.7,col='red')
}
}
dev.off()


# Keeping only the good points and curves
curated_data=curated_data[curated_data$QC=='ok',]

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')
