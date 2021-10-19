load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC='ok'
hist(curated_data$Ci) ## No below zero value
hist(curated_data$gsw) ## The conductance is sometimes low.. To consider in the quality check

QC_table=cbind.data.frame(SampleID_num=c(4,4,4,4,4,6,8,9,10,25,27,35,35,35,55,55,55,69,69),
                          Obs=c(13,14,15,16,17,16,4,15,2,25,28,50,51,52,28,29,30,42,43)) ## I had to do a heavy QaQc
ls_bad_curve=c(1,2,11,16,19,34,37,43,46,49,50,54,61,63,64,71,79,90,93,95)
ls_bad_curve=c(ls_bad_curve,8,12,15,17,18,20,21,32,47,48,56,58,68,86)## This curves were removed after checking the fittings
curated_data[paste(curated_data$SampleID_num,curated_data$Obs)%in%paste(QC_table$SampleID_num,QC_table$Obs),'QC']='bad'

curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'

pdf(file='1_QA_QC_Aci.pdf',)
for(SampleID_num in unique(curated_data$SampleID_num)){
plot(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num,'A'],main=unique(curated_data[curated_data$SampleID_num==SampleID_num,'SampleID_num']),cex=2,xlab='Ci',ylab='A')
if(SampleID_num%in%c(QC_table$SampleID_num,ls_bad_curve)){
  points(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'],cex=2,col='red')
}
text(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],y=curated_data[curated_data$SampleID_num==SampleID_num,'A'], labels=curated_data[curated_data$SampleID_num==SampleID_num,'Obs'],cex=0.7)
  
}
dev.off()
curated_data=curated_data[curated_data$QC=='ok',]

save(curated_data,file='1_QC_data.Rdata')