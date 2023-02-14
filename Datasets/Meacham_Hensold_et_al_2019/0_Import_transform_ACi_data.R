## Dataset was shared by Meacham-Hensold et al. through its 2019 RSE paper.
## Licor datasets are in .xlsx
## Note that in .xlsx, there are two rows for header to we want to remove the second row but keep
# the first row (variable names) and then the actual data rows

library(magrittr)
library(readxl)
library(here)
path<-here()
source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Meacham_Hensold_et_al_2019'))

aci_files <- list.files(file.path(path,"Datasets/Meacham_Hensold_et_al_2019/Licor_data"), pattern = "*.xlsx")


curated_data <- data.frame()
for(file in aci_files) {
  print(file)
  filepath <-file.path(path,"Datasets/Meacham_Hensold_et_al_2019/Licor_data",file)
    (excel_cnames <- read_excel(filepath, n_max = 0) %>%
                    names())
    excel_data <- read_excel(filepath, skip = 2, col_names = excel_cnames)
    excel_data$date <- substr(file, 1, 10) # save year so that we can match to spectral data later
    excel_data$sampleID <- paste(excel_data$date, excel_data$ID)
    temp_data1 <- excel_data[, c('Obs','Photo','Ci','CO2S','CO2R',"Cond","Press","PARi","RH_S","Tleaf")]
    temp_data1 <- as.data.frame(lapply(temp_data1, as.numeric))
    temp_data <- cbind.data.frame(excel_data$sampleID, temp_data1)
    colnames(temp_data) <- ESS_column
    temp_data$file <- file
    curated_data <- rbind.data.frame(curated_data, temp_data)
}

curated_data$SampleID_num <- as.numeric(as.factor(curated_data$SampleID))
curated_data<-curated_data[order(curated_data$SampleID_num),]
save(curated_data,file = '0_curated_data.Rdata')
