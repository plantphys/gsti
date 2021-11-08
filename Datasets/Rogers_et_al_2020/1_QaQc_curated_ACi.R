library(here)
library(spectratrait)
path=here()
setwd(paste(path,'/Datasets/Rogers_et_al_2020',sep=''))

load('0_curated_data.Rdata',verbose=TRUE)

curated_data$QC='ok'
curated_data[!is.na(curated_data$QCauthors)&curated_data$QCauthors==1,'QC']='bad'
hist(curated_data$Ci) ##
curated_data[curated_data$Ci<0,'QC']='bad'
hist(curated_data$gsw) ## No below zero value
curated_data[curated_data$gsw<0,'QC']='bad'


QC_table=cbind.data.frame(SampleID_num=c(12,14,16),
                          Obs=c(1,13,1)) ## 
ls_bad_curve=c()
curated_data[paste(curated_data$SampleID_num,curated_data$Obs)%in%paste(QC_table$SampleID_num,QC_table$Obs),'QC']='bad'
curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'

pdf(file='1_QA_QC_Aci.pdf',)
for(SampleID_num in sort(unique(curated_data$SampleID_num))){
plot(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num,'A'],main=unique(curated_data[curated_data$SampleID_num==SampleID_num,'SampleID_num']),cex=2,xlab='Ci',ylab='A')
  text(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num,'A'], labels=curated_data[curated_data$SampleID_num==SampleID_num,'Obs'],cex=0.7)
if(any(curated_data[curated_data$SampleID_num==SampleID_num,'QC']=='bad')){
  points(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'],cex=2,col='red')
  text(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'], labels=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Obs'],cex=0.7,col='red')
}
}
dev.off()
curated_data=curated_data[curated_data$QC=='ok',]

save(curated_data,file='1_QC_data.Rdata')