## This code is used to do the step 1 of the data curation process.
## It is used to analyse and check the data quality. Bad points are removed as well as bad curves.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Silva_Perez_et_al_2018' folder where the data is located
setwd(file.path(path,'/Datasets/Silva_Perez_et_al_2018'))

# Load the ACi data that were processed in step 0
load('0_curated_data.Rdata',verbose=TRUE)

# Adding a Quality Check column with two values: "ok" or "bad", where "bad" correspond to bad data 
# that is not used to fit the ACi curves in the next step.
curated_data$QC='ok'
curated_data=curated_data[!is.na(curated_data$Qin),]

# Flagging the below 0 Ci as bad data
curated_data[curated_data$Ci<0,'QC']='bad'

hist(curated_data$RHs) # There are some very low RHs values 
hist(curated_data$Qin) 
hist(curated_data$gsw) 
curated_data[curated_data$Qin<1550,'QC']='bad'

### Function to remove the duplicated 400 ppm values
remove_Aci_dupplicate<-function(Aci_curve){
  Aci_curve=round(Aci_curve,-1)
  remove=rep('NO',length(Aci_curve))
  if (Aci_curve[length(Aci_curve)]==400){remove[length(remove)]='YES'}
  remove[which(duplicated(Aci_curve[1:(length(Aci_curve)-1)],fromLast = FALSE))]='YES'
  remove[1:5]='NO'
  remove[which(duplicated(Aci_curve[1:5],fromLast = TRUE))]='YES'
  return(remove)
}

remove=ave(curated_data$CO2r,curated_data$SampleID,FUN=remove_Aci_dupplicate)
curated_data[which(remove=='YES'),'QC']='bad'


# I create a "Quality check" table where I manually inform bad points. 
# When I start the quality check the QC table is empty: QC_table=cbind.data.frame(SampleID_num=c(),Record=c()) 
# I plot the data in the next step (line starting with pdf below). 
# I then manually check the plots and write down the SampleID_num and the Record corresponding to bad points
# This works well if there are few points to remove.
# You can use another method if you need.

QC_table=cbind.data.frame(SampleID_num=c(135,265,266,267,268,269,270,271,272,337,338,342,350,352,353,355,373,376,377,383,393,401,407,553),
                          Record=c(6,50,57,7,15,22,29,36,43,2,17,41,30,45,53,61,43,8,15,15,1,66,61,43)) 
# Here I flag the bad curves by writing down the SampleID_num of the bad curves.
ls_bad_curve=c(313,336,339,341,344:346,351,354,357,359,415,429,498,500,510,591,602)

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

# Saving the Quality checked data to be used in the next step.
save(curated_data,file='1_QC_ACi_data.Rdata')