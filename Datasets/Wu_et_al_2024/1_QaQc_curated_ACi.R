## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Wu_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Wu_et_al_2024'))

# Load the ACi data that were processed in step 0
load('0_curated_data.Rdata',verbose=TRUE)

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the ACi curves in the next step.
curated_data$QC='ok'

# Displaying Ci values to spot bad data
hist(curated_data$Ci) 
hist(curated_data$gsw,breaks = 40)
hist(curated_data$RHs)
hist(curated_data$Tleaf)
hist(curated_data$Qin)

# Flagging the below 0 Ci as bad data
curated_data[curated_data$Ci<0,'QC']='bad'
curated_data[curated_data$gsw<0.005,'QC']='bad'
curated_data[curated_data$RHs<20,'QC']='bad'


# I create a "Quality check" table where I manually inform bad points. 
# When I start the quality check the QC table is empty: QC_table=cbind.data.frame(SampleID_num=c(),Record=c()) 
# I plot the data in the next step (line starting with pdf below). 
# I then manually check the plots and write down the SampleID_num and the Record corresponding to bad points
# This works well if there are few points to remove.
# You can use another method if you need.

QC_table=cbind.data.frame(SampleID_num=c(7,7,68,77,92,92,93,93,253,256,353,353,355,358,362,655,765,229,326),
                          Record=c(1,2,1,14,13,14,13,14,1,13,13,14,1,6,11,3,7,8,14)) 

# Here I flag the bad curves by writing down the SampleID_num of the bad curves.
ls_bad_curve=c(2,4,10,12,14,24,28,31,37,54,59,60,61,72,74,75,87,100,102:105,148,168,183,208,214,215,226,248,249,264,291,309,324,327,344,359,365,374,390,397,410,436,499,505,526,531,585,696,751,837)

# I also flag duplicated measurements for which it will be difficult to know what was the real sampleID
ls_duplicated=c(294,354,555,608,651,714,757,758,780,820,874,891)

# Checking the number of points in each curve:
n_points_curves=tapply(X=curated_data$SampleID_num,INDEX = curated_data$SampleID_num,FUN = function(x) length(x))
which(n_points_curves<3)
# Here I flag all the bad curves and bad points
curated_data[paste(curated_data$SampleID_num,curated_data$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'
curated_data[curated_data$SampleID_num%in%c(ls_bad_curve,ls_duplicated),'QC']='bad'


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

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')