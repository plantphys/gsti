library(here)
path <- here()

setwd(file.path(path,'/Datasets/Barnes_et_al_2017'))


load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC='ok'
hist(curated_data$Ci) ## No below zero value
hist(curated_data$gsw) ## The minimun conductance seem fine

QC_table=cbind.data.frame(SampleID_num=c(17,25,30,68,84),Record=c(8,8,8,12,12))
ls_bad_curve=c()
curated_data[paste(curated_data$SampleID_num,curated_data$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'

pdf(file='1_QA_QC_Aci.pdf',)
for(SampleID_num in unique(curated_data$SampleID_num)){
plot(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num,'A'],main=unique(curated_data[curated_data$SampleID_num==SampleID_num,'SampleID_num']),cex=2,xlab='Ci',ylab='A')
if(SampleID_num%in%c(QC_table$SampleID_num,ls_bad_curve)){
  points(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'],cex=2,col='red')
}
text(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num,'A'], labels=curated_data[curated_data$SampleID_num==SampleID_num,'Record'],cex=0.7)
  
}
dev.off()
curated_data=curated_data[curated_data$QC=='ok',]

save(curated_data,file='1_QC_ACi_data.Rdata')