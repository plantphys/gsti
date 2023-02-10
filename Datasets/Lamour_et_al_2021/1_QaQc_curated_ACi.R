library(here)
path=here()
setwd(file.path(path,'/Datasets/Lamour_et_al_2021'))

load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC='ok'
hist(curated_data$Ci) ## No below zero value
curated_data[curated_data$Ci<0,'QC']='bad'

curated_data[curated_data$Remove=='YES','QC']='bad'


## There are a lot of curves (253), they look nice overall, but of course, given the number of curves I needed to remove a lot of points.
QC_table=cbind.data.frame(SampleID_num=c(18,70,111),
                          Record=c(14,20,20)) ## 
ls_bad_curve=c(11,52,77,127)
curated_data[paste(curated_data$SampleID_num,curated_data$Record)%in%paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'
curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'

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