
## Dataset accessible at XXXXX (will update when I have a DOI)

setwd("~/Global_Vcmax-main/Datasets/Davidson_etal_2023")

original_data <-read.csv('Stomatal_Response_Curve_Data.csv')
curated_data<- original_data[,c("SampleID","A","Ci","Patm","Qin","Tleaf")]

curated_data$SampleID_num <- as.numeric(as.factor(curated_data$SampleID))
curated_data <- curated_data[order(-curated_data$Qin),]
curated_data <- curated_data[match(unique(curated_data$SampleID_num), curated_data$SampleID_num),]

save(curated_data,file='0_curated_data.Rdata')
