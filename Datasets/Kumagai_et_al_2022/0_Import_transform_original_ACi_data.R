## Dataset was shared by Kumagai et al. through its 2022 paper.
## Licor datasets are in .xlsx
## Note that in .xlsx, there are two rows for header to we want to remove the second row but keep
# the first row (variable names) and then the actual data rows
# The first 14 rows are not data

library(magrittr)
library(readxl)
setwd("~/Global_Vcmax/")
source('R/Correspondance_tables_ESS.R')
data_folder <- "Datasets/Kumagai_et_al_2022/Licor_data"
aci_files <- list.files(data_folder, pattern = "*.xlsx")
outfile <- 'Datasets/Kumagai_et_al_2022/0_curated_data.Rdata'

curated_data <- data.frame()
for(file in aci_files) {
    print(file)
    filepath <- paste0(data_folder, '/', file)
    (excel_cnames <- read_excel(filepath, skip = 14, n_max = 0) %>%
                    names())
    excel_data <- read_excel(filepath, skip = 16, col_names = excel_cnames)
    excel_data$date <- substr(file, 1, 10) # save year so that we can match to spectral data later
    excel_data$sampleID <- paste0(excel_data$date, '-', excel_data$plant)
    temp_data1 <- excel_data[, c('obs','A','Ci','CO2_s','CO2_r',"gsw","Pa","Qin","RHcham","Tleaf")]
    temp_data1 <- as.data.frame(lapply(temp_data1, as.numeric))
    temp_data <- cbind.data.frame(excel_data$sampleID, temp_data1)
    colnames(temp_data) <- ESS_column
    temp_data$file <- file
    curated_data <- rbind.data.frame(curated_data, temp_data)
}

curated_data$SampleID_num <- as.numeric(as.factor(curated_data$SampleID))
save(curated_data, file = outfile)
