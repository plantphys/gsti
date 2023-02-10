library(here)
path <- here()

setwd(file.path(path,'/Datasets/Meacham_Hensold_et_al_2019'))

load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC='ok'
hist(curated_data$Ci) ## No below zero value
hist(curated_data$gsw) ## The conductance is sometimes low.. To consider in the quality check

# found some points that needs to be removed with ci values or gsw values less than 0.
QC_table <- cbind.data.frame(SampleID_num = c(57, 60, 67, 117, 169, 250, 255, 57),
                           Record = c(48, 59, 37, 23, 45, 1, 12, 57))

# Below are the curve points that are removed as they are not good for fitting
Curve_table1 <- cbind(SampleID_num = c(9, 36, 24, 5, 39, 40, 8, 33, 42, 44, 46, 49, 53, 56, 59, 63, 65, 62, 45, 45, 47, 50, 51, 61),
                      Record = c(67, 1, 12, 23, 34, 45, 56, 69, 80, 1, 12, 23, 34, 45, 56, 67, 78, 75, 10, 11, 15, 26, 37, 70))

Curve_table2 <- cbind(SampleID_num = c(64, 76, 77, 78, 69, 68, 66, 72, 73, 100, 100, 100, 91, 110, 129, 122, 135, 140, 147, 146, 148),
                      Record = c(81, 12, 4, 15, 26, 48, 1, 23, 34, 80, 81, 82, 67, 69, 22, 1, 1, 12, 23, 34, 12))

Curve_table3 <- cbind(SampleID_num = c(152, 145, 142, 159, 155, 173, 175, 177, 195, 204, 209, 205, 207, 219, 217, 214, 224, 220, 213),
                       Record = c(45, 56, 67, 1, 12, 12, 23, 34, 12, 45, 67, 56, 67, 12, 34, 56, 14, 36, 45))
Curve_table4 <- cbind(SampleID_num = c(213, 235, 234, 234, 237, 237, 244, 241, 227, 232, 232, 247, 230, 231, 245, 236, 252),
                       Record = c(47, 21, 31, 37, 11, 41, 55, 68, 5, 14, 16, 38, 12, 23, 50, 61, 23))                    
# combine all the observed bad points (Visually checked)
QC_table <- rbind.data.frame(QC_table, Curve_table1, Curve_table2, Curve_table3, Curve_table4)

ls_bad_curve <- c(46, 47, 110, 111, 115, 120, 173, 176, 177, 185, 188, 195, 220, 221, 227, 239, 
                  256, 30, 55, 180, 234) # removed as derived fitting results (vcmax or Jmax) seems too high
                  # I may be conservative here for thes high values (more than 400 u mol m-2 s-1)

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