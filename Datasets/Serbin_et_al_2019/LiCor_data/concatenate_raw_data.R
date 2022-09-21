library(here)
library(dplyr)
library(purrr)
path <- here()

ag_datasets <- file.path(here(),'Datasets/Serbin_et_al_2019/LiCor_data/ag_sites/')
ag_data_files <- list.files(path = ag_datasets, pattern = "*.csv", full.names = T)
ag_data_files

ag_data <- dplyr::bind_rows(lapply(ag_data_files, read.csv))
head(ag_data)

# !! TODO: Finish importing all ag data - not complete

output_dir <- file.path(here(),'Datasets/Serbin_et_al_2019/LiCor_data/')
write.csv(ag_data, file = file.path(output_dir, "concatenated_ag_gasex_data.csv"), 
          row.names = F)

#eof