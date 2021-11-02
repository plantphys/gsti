library(here)
path=here()
setwd(paste(path,'/Datasets/Yan_et_al_2021',sep=''))

load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC='ok'
hist(curated_data$Ci) 
curated_data[curated_data$Ci<0,'QC']='bad'
hist(curated_data$gsw) 
curated_data[curated_data$gsw<0,'QC']='bad'
curated_data[curated_data$Remove=='YES','QC']='bad'

### Function to remove the duplicated A-Ci values
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


QC_table=cbind.data.frame(SampleID_num=c(16,19,45,45,78,127,225,336),
                          Obs=c(98,44,70,71,80,101,143,73)) ## 

## I remove a lot of curves with a discontinuity between the bottom part of the curve and the top part.
## I suppose that the photosynthesis was not acclimated yest for those leaves
ls_bad_curve=c(47,48,54,55,56,70,85,103,105,106,168,173,180,190,191,193,202,217,232,233,234,240,241,256,274,281,294,317,328)
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