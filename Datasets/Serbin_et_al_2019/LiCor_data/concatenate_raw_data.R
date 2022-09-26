library(here)
library(dplyr)
library(purrr)
path <- here()

ag_datasets <- file.path(here(),'Datasets/Serbin_et_al_2019/LiCor_data/ag_sites/')
ag_data_files <- list.files(path = ag_datasets, pattern = "*.csv", full.names = T)
ag_data_files

ag_data <- dplyr::bind_rows(lapply(ag_data_files, read.csv))
head(ag_data)

output_dir <- file.path(here(),'Datasets/Serbin_et_al_2019/LiCor_data/')
write.csv(ag_data, file = file.path(output_dir, "concatenated_ag_gasex_data.csv"), 
          row.names = F)

nonag_datasets <- file.path(here(),'Datasets/Serbin_et_al_2019/LiCor_data/non_ag_sites')
nonag_data_files <- list.files(path = nonag_datasets, pattern = "*.csv", full.names = T)
nonag_data_files

nonag_data <- dplyr::bind_rows(lapply(nonag_data_files, read.csv))
head(nonag_data)

output_dir <- file.path(here(),'Datasets/Serbin_et_al_2019/LiCor_data/')
write.csv(nonag_data, file = file.path(output_dir, "concatenated_nonag_gasex_data.csv"), 
          row.names = F)

# what species?
unique(nonag_data$USDA_Species)

# Calculate some average stats to use for correcting remaining datasets
ABCO_avg_area <- mean(nonag_data$Area[which(nonag_data$USDA_Species=="ABCO")], na.rm=T)
ABCO_sdev_area <- sd(nonag_data$Area[which(nonag_data$USDA_Species=="ABCO")], na.rm=T)
ABCO_avg_area
ABCO_sdev_area
# > ABCO_avg_area
# [1] 1.72071
# > ABCO_sdev_area
# [1] 0.04350984

CADE_avg_area <- mean(nonag_data$Area[which(nonag_data$USDA_Species=="CADE")], na.rm=T)
CADE_sdev_area <- sd(nonag_data$Area[which(nonag_data$USDA_Species=="CADE")], na.rm=T)
CADE_avg_area
CADE_sdev_area
# > CADE_avg_area
# [1] 1.478964
# > CADE_sdev_area
# [1] 0.02962435

PILA_avg_area <- mean(nonag_data$Area[which(nonag_data$USDA_Species=="PILA")], na.rm=T)
PILA_sdev_area <- sd(nonag_data$Area[which(nonag_data$USDA_Species=="PILA")], na.rm=T)
PILA_avg_area
PILA_sdev_area
# > PILA_avg_area
# [1] 1.818156
# > PILA_sdev_area
# [1] 0.05594765

PISA2_avg_area <- mean(nonag_data$Area[which(nonag_data$USDA_Species=="PISA2")], na.rm=T)
PISA2_sdev_area <- sd(nonag_data$Area[which(nonag_data$USDA_Species=="PISA2")], na.rm=T)
PISA2_avg_area
PISA2_sdev_area
# > PISA2_avg_area
# [1] 1.913644
# > PISA2_sdev_area
# [1] 0.0391704



# Combined data
names(ag_data)
names(nonag_data)
output_data <- rbind(ag_data,nonag_data)

output_dir <- file.path(here(),'Datasets/Serbin_et_al_2019/LiCor_data/')
write.csv(output_data, file = file.path(output_dir, "concatenated_gasex_data.csv"), 
          row.names = F)

#eof