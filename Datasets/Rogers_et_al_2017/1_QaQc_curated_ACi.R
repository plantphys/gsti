library(here)
library(spectratrait)
path=here()
setwd(file.path(path,'/Datasets/Rogers_et_al_2017'))

load('0_curated_data.Rdata',verbose=TRUE)

## A lot of curves dont have a spectra associated, so to facilitate the QaQc 
## I only keep the curves with a spectra

ecosis_id <- "bf41fff2-8571-4f34-bd7d-a3240a8f7dc8"
dat_raw <- get_ecosis_data(ecosis_id = ecosis_id)

curated_data=curated_data[curated_data$SampleID%in%dat_raw$Sample_ID,]

curated_data$QC='ok'
curated_data[!is.na(curated_data$QCauthors)&curated_data$QCauthors==1,'QC']='bad'
hist(curated_data$Ci) ##
curated_data[curated_data$Ci<0,'QC']='bad'
hist(curated_data$gsw) ## No below zero value
curated_data[curated_data$gsw<0,'QC']='bad'


QC_table=cbind.data.frame(SampleID_num=c(46,46,46,53,70,71,72,73,110,110,111,157),
                          Record=c(16,6,7,1,1,16,1,16,16,17,1,18)) ## 
ls_bad_curve=c(43,45,59,74,136,139,147,148,149,150,157,158,159,160,161,162,176,177,178)
curated_data[paste(curated_data$SampleID_num,curated_data$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'
curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'

############ Here I manually consider some points 'good' so the estimation of Jmax is correct
curated_data[curated_data$SampleID_num==52&curated_data$Record>12,'QC']='ok'
curated_data[curated_data$SampleID_num==72&curated_data$Record>11,'QC']='ok'
curated_data[curated_data$SampleID_num==73&curated_data$Record>12,'QC']='ok'
curated_data[curated_data$SampleID_num==78&curated_data$Record>12,'QC']='ok'
curated_data[curated_data$SampleID_num==79&curated_data$Record>13,'QC']='ok'
curated_data[curated_data$SampleID_num==103&curated_data$Record>13,'QC']='ok'
curated_data[curated_data$SampleID_num==104&curated_data$Record>13,'QC']='ok'
curated_data[curated_data$SampleID_num==115&curated_data$Record>11,'QC']='ok'
curated_data[curated_data$SampleID_num==125&curated_data$Record>12,'QC']='ok'
curated_data[curated_data$SampleID_num==127&curated_data$Record>12,'QC']='ok'

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
curated_data=curated_data[curated_data$QC=='ok',]

save(curated_data,file='1_QC_ACi_data.Rdata')