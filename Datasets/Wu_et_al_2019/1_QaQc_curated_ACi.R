library(here)
path=here()
setwd(paste(path,'/Datasets/Wu_et_al_2019',sep=''))

load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC='ok'
hist(curated_data$Ci) ## No below zero value
curated_data[curated_data$Ci<0,'QC']='bad'
hist(curated_data$gsw) ## The conductance is sometimes low.. To consider in the quality check
curated_data[curated_data$gsw<0,'QC']='bad'

## There is a dupplicate for SampleID = BNL10446 (SampleID_num == 2, that I remove manually)
curated_data=curated_data[-which(curated_data$SampleID=='BNL10446'&curated_data$Obs>18),]

### Here the data is totally raw, so I filter for the duplicated Ci levels:
remove_Aci_dupplicate<-function(Aci_curve){
  Aci_curve=round(Aci_curve,-1)
  remove=rep('NO',length(Aci_curve))
  remove[length(Aci_curve)]='YES'
  remove[which(duplicated(Aci_curve[1:(length(Aci_curve)-1)],fromLast = TRUE))]='YES'
  remove[1:5]='NO'
  remove[which(duplicated(Aci_curve[1:5],fromLast = TRUE))]='YES'
  return(remove)
}

remove=ave(curated_data$CO2r,curated_data$SampleID,FUN=remove_Aci_dupplicate)
curated_data[which(remove=='YES'),'QC']='bad'

### Some 'automatic' removals where not accurate, so I put back some points:
OK_table=cbind.data.frame(SampleID_num=c(2,76,84,94,95,114,134,150),Obs=c(18,17,17,17,17,17,37,19)) ## 
curated_data[paste(curated_data$SampleID_num,curated_data$Obs)%in%paste(OK_table$SampleID_num,OK_table$Obs),'QC']='ok'


## There are a lot of curves (253), they look nice overall, but of course, given the number of curves I needed to remove a lot of points.
QC_table=cbind.data.frame(SampleID_num=c(1,2,4,5,7,8,10,11,13,21,21,33,35,35,39,44,47,49,51,53,56,61,63,75,76,84,91,94,94,106,116,142,146,146,146,156,157,161,171,173,173,180,190,198,202,209,241),
                          Obs=c(12,11,51,87,106,3,79,52,42,3,18,17,38,39,25,58,62,2,12,53,36,69,42,10,10,15,1,1,10,1,10,75,95,94,97,4,19,39,64,22,31,90,34,13,67,84,92)) ## 
ls_bad_curve=c(64,66,67,70,72,74,77,78,79,85,86,93,105,107,108,111,113,115,117,131,136,137,141,144,145,154,169,170,
               174,175,176,179,187,193,194,195,197,199,203,208,212,213,215,216,224,230,232,238,239,244,245,246,247,249,253)
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