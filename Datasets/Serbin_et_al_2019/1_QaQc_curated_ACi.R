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

## Remove known bad curves
bad_curve_list <- c("KARE_Plot1_PIME4_L2_GE_1_2015-06-08", "KARE_Plot1_PIME4_L26_GE_1_2015-06-08", 
                    "KARE_Plot1_PIME4_L27_GE_1_2015-06-08", "KARE_Plot1_PUGR2_L10_GE_1_2015-06-07",
                    "KARE_Plot1_PUGR2_L11_GE_1_2015-06-07", "KARE_Plot1_PUGR2_L12_GE_1_2015-06-07",
                    "KARE_Plot2_FICA_L11_GE_1_2015-06-06", "KARE_PLot2_FICA_L2_GE_2_2015-06-06",
                    "KARE_Plot2_FICA_L7_GE_1_2015-06-06", "KARE_Plot2_PIME4_L10_GE_1_2015-06-08",
                    "KARE_Plot2_PIME4_L20_GE_1_2015-06-08","KARE_Plot2_PIME4_L23_GE_1_2015-06-08",
                    "KARE_Plot2_PIME4_L24_GE_1_2015-06-08","KARE_Plot2_PUGR2_L2_GE_1_2015-06-07",
                    "KARE_Plot3_FICA_L13_GE_1_2015-06-06","KARE_Plot3_FICA_L4_GE_1_2015-06-06",
                    "KARE_Plot3_FICA_L5_GE_1_2015-06-06","KARE_Plot3_PUGR2_L15_GE_1_2015-06-07",
                    "KARE_Plot3_PUGR2_L5_GE_1_2015-06-07","KARE_Plot4_FICA_L3_GE_1_2015-06-06",
                    "KARE_Plot4_FICA_L6_GE_1_2015-06-06","KARE_Plot4_PUGR2_L14_GE_1_2015-06-07",
                    "KARE_Plot4_PUGR2_L3_GE_1_2015-06-07","KARE_Plot4_PUGR2_L8_GE_1_2015-06-07",
                    "Shafter_SOTU_Plot1_L10T_GE_1_2015-06-10","Shafter_SOTU_Plot1_L11T_GE_1_2015-06-10",
                    "Shafter_SOTU_Plot2_L12T_GE_1_2015-06-10","Shafter_SOTU_Plot2_L24T_GE_1_2015-06-10",
                    "Shafter_SOTU_Plot2_L4T_GE_1_2015-06-10","Shafter_SOTU_Plot4_L13T_GE_1_2015-06-10",
                    "Shafter_SOTU_Plot4_L14T_GE_1_2015-06-10","Shafter_SOTU_Plot4_L16T_GE_1_2015-06-10",
                    "CVARS_Plot1_PHDA4_L1T_GE_1_2014-06-05","CVARS_Plot1_PHDA4_L3T_GE_3_2014-06-07",
                    "DREC_Plot1_BEVU2_L12T_GE_1_2015-06-11","REC_Plot3_BEVU2_L10T_GE_1_2015-06-11",
                    "DREC_Plot3_BEVU2_L7T_GE_1_2015-06-11","KARE_Plot1_FICA_L10_GE_1_2015-06-06",
                    "KARE_Plot1_FICA_L2large_GE_1_2015-06-05","KARE_Plot1_FICA_L3large_GE_1_2015-06-05",
                    "DREC_Plot3_BEVU2_L10T_GE_1_2015-06-11")
curated_data[which(curated_data$Sample_ID_Name %in% bad_curve_list), 'QC'] <- 'bad'


# Keep only "good" data
curated_data <- curated_data[curated_data$QC=='ok',]

save(curated_data,file='1_QC_data.Rdata')
