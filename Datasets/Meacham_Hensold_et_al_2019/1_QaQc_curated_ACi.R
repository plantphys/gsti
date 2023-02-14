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
# JL on february 14th 2023 Removed the first point of each curve which is often very poor
first_point<-tapply(X = curated_data$Record,INDEX = curated_data$SampleID_num,FUN = min)
first_point<-data.frame(SampleID_num=names(first_point),Record=first_point)

# Below are the curve points that are removed as they are not good for fitting
Curve_table1 <- cbind(SampleID_num = c(9, 36, 24, 5, 39, 40, 8, 33, 42, 44, 46, 49, 53, 56, 59, 63, 65, 62, 45, 45, 47, 50, 51, 61),
                      Record = c(67, 1, 12, 23, 34, 45, 56, 69, 80, 1, 12, 23, 34, 45, 56, 67, 78, 75, 10, 11, 15, 26, 37, 70))

Curve_table2 <- cbind(SampleID_num = c(64, 76, 77, 78, 69, 68, 66, 72, 73, 100, 100, 100, 91, 110, 129, 122, 135, 140, 147, 146, 148),
                      Record = c(81, 12, 4, 15, 26, 48, 1, 23, 34, 80, 81, 82, 67, 69, 22, 1, 1, 12, 23, 34, 12))

Curve_table3 <- cbind(SampleID_num = c(152, 145, 142, 159, 155, 173, 175, 177, 195, 204, 209, 205, 207, 219, 217, 214, 224, 220, 213),
                       Record = c(45, 56, 67, 1, 12, 12, 23, 34, 12, 45, 67, 56, 67, 12, 34, 56, 14, 36, 45))
Curve_table4 <- cbind(SampleID_num = c(213, 235, 234, 234, 237, 237, 244, 241, 227, 232, 232, 247, 230, 231, 245, 236, 252),
                       Record = c(47, 21, 31, 37, 11, 41, 55, 68, 5, 14, 16, 38, 12, 23, 50, 61, 23))                    

Curve_tableJL <-cbind(SampleID_num = c(8,8,10,15,68,68,69,69,110,110,115,124,126,131,133,134,141,177,219),
                      Record = c(67,68,78,34,57,58,35,36,69,70,57,23,12,45,34,33,34,34,21))                    

# combine all the observed bad points (Visually checked)
QC_table <- rbind.data.frame(QC_table, first_point,Curve_table1, Curve_table2, Curve_table3, Curve_table4, Curve_tableJL)

ls_bad_curve <- c(44:48, 53, 80, 85, 87, 91, 93, 100, 101, 111,139,144,165,170, 173,176,177, 185, 188, 195, 203:217, 220, 221, 224,226,227, 229, 232,234, 239, 
                  241,243,247,249,256,261) 

ls_bad_fit <-c(18,22,49,51,59,61,63:65,244) # Jl added these bad curves. 

curated_data[paste(curated_data$SampleID_num, curated_data$Record) %in% paste(QC_table$SampleID_num, QC_table$Record),'QC']='bad'

curated_data[curated_data$SampleID_num %in% ls_bad_curve, 'QC'] <-'bad'
curated_data[curated_data$SampleID_num %in% ls_bad_fit, 'QC'] <-'bad'
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