library(here)
path <- here()

setwd(file.path(path,'/Datasets/Sexton_et_al_2021'))

load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC='ok'
hist(curated_data$Ci) ## No below zero value
hist(curated_data$gsw) ## The conductance is sometimes low.. To consider in the quality check

QC_table=cbind.data.frame(SampleID_num=c(18,34,60,60),Record=c(13,7,5,7)) ## Beautiful data!
ls_bad_curve=c('73')
curated_data[paste(curated_data$SampleID_num,curated_data$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'

## I just remove the curve 73
curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'

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