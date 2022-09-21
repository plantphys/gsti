library(here)
path <- here()
setwd(file.path(path,'/Datasets/Serbin_et_al_2019'))

load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC <- 'ok'
curated_data$QC[curated_data$QCauthors==1] <- 'bad'

hist(curated_data$Ci) ## No below zero value
min(curated_data$Ci)
hist(curated_data$gsw) 
min(curated_data$gsw)

# remove Ci and gsw < 0
curated_data[curated_data$Ci<0, 'QC'] <- 'bad'
curated_data[curated_data$gsw<0, 'QC'] <- 'bad'
head(curated_data)

# !! I HAVE NO IDEA WHAT ANY OF THIS IS !! Need to ask Julien what all of this about and why there are so many manual steps

#QC_table <- cbind.data.frame(SampleID_num=c(2,6,7,12,18,21,21,21,23,23,34,36),Obs=c(13,12,8,6,6,7,8,9,8,9,7,7))
#ls_bad_curve=c(3,4,9,29)
#curated_data[paste(curated_data$SampleID_num,curated_data$Obs) %in% paste(QC_table$SampleID_num,QC_table$Obs),'QC']='bad'
#curated_data[curated_data$SampleID_num%in%ls_bad_curve,'QC']='bad'

# I DONT KNOW WHAT ALL OF THIS IS DOING - SEEMS OVERLY COMPLICATED

# pdf(file='1_QA_QC_Aci.pdf',)
# for(SampleID_num in unique(curated_data$SampleID_num)) {
#   plot(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],
#        y=curated_data[curated_data$SampleID_num==SampleID_num,'A'],
#        main=unique(curated_data[curated_data$SampleID_num==SampleID_num,
#                                 'SampleID_num']),cex=2,xlab='Ci',ylab='A')
# if(SampleID_num%in%c(QC_table$SampleID_num,ls_bad_curve)) {
#   points(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],
#          y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'],
#          cex=2,col='red')
# }
# text(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],
#      y=curated_data[curated_data$SampleID_num==SampleID_num,'A'], 
#      labels=curated_data[curated_data$SampleID_num==SampleID_num,'Obs'],cex=0.7)
#   
# }
# dev.off()


# Keep only "good" data
curated_data <- curated_data[curated_data$QC=='ok',]

save(curated_data,file='1_QC_data.Rdata')
