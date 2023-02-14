library(here)
path <- here()

setwd(file.path(path,'/Datasets/Kumagai_et_al_2022'))

load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC='ok'
hist(curated_data$Ci) 
curated_data[curated_data$Ci<10,"QC"]="bad"
hist(curated_data$gsw) 

curated_data[curated_data$gsw<0.01,"QC"]="bad"
# found some points that needs to be removed with ci values or gsw values less than 0.

# Below are the curve points that are removed as they are not good for fitting
QC_table<- data.frame(SampleID_num = c(37, 52, 52, 52, 52, 107, 107, 92,121, 140),
                      Record = c(50, 43, 42, 41, 45, 45, 46, 121,22, 89))


ls_bad_curve <- c(12,27, 75, 88, 93,107, 110, 130, 141, 142, 143) # removed as bad data

curated_data[paste(curated_data$SampleID_num, curated_data$Record) %in% paste(QC_table$SampleID_num, QC_table$Record),'QC']='bad'

curated_data[curated_data$SampleID_num %in% ls_bad_curve, 'QC'] <-'bad'

pdf(file = '1_QA_QC_Aci.pdf',)
for(SampleID_num in unique(curated_data$SampleID_num)) {
  plot(x = curated_data[curated_data$SampleID_num == SampleID_num,'Ci'],
       y = curated_data[curated_data$SampleID_num == SampleID_num,'A'],
       main = unique(curated_data[curated_data$SampleID_num == SampleID_num,'SampleID_num']),
       cex = 2,
       xlab = 'Ci',
       ylab = 'A')
if(SampleID_num %in%c (QC_table$SampleID_num, ls_bad_curve)) {
  points(x = curated_data[curated_data$SampleID_num == SampleID_num&curated_data$QC=='bad','Ci'],
         y = curated_data[curated_data$SampleID_num == SampleID_num&curated_data$QC=='bad','A'],
         cex = 2,
         col = 'red')
}
text(x = curated_data[curated_data$SampleID_num == SampleID_num,'Ci'],
     y = curated_data[curated_data$SampleID_num == SampleID_num,'A'], 
     labels = curated_data[curated_data$SampleID_num == SampleID_num,'Record'],
     cex = 0.7)
}
dev.off()
curated_data <- curated_data[curated_data$QC == 'ok',]

save(curated_data,file = '1_QC_ACi_data.Rdata')
