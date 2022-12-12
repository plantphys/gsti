library(magrittr)
library(readxl)
library(spectratrait)

fpath <- '~/Global_Vcmax/Datasets/Kumagai_et_al_2022/'
setwd(fpath)
load("2_Result_ACi_fitting.Rdata")
# read csv data
reflec_data <- data.frame()
datafiles <- list.files(paste0(fpath, "ASD"), pattern = "\\.csv$")
for (filename in datafiles){
    csv_data <- read.csv(paste0(fpath, "ASD/", filename))
    csv_data$ID <- paste0(substr(filename, 1, 10), '-', csv_data$Spectra)
    reflec_data <- rbind.data.frame(reflec_data, csv_data)
}


# spectral_file <- paste0(fpath, "Reflectance_data.xlsx")
# excel_data <- read_excel(spectral_file)
# excel_cnames <- paste0("Wave_", 350:2500)
# spectra <- excel_data[excel_cnames]
# spectra <- as.data.frame(lapply(spectra, as.numeric))
# spectra$ID <- paste(excel_data$Year, excel_data$Date, excel_data$Name, sep = " ")
spectra <- merge(x = reflec_data, y = Bilan, by.x = 'ID', by.y='SampleID')

spectra=data.frame(SampleID=spectra$SampleID_num,
                        dataset = 'Kumagai_et_al_2022',
                        Species = "Soybean with temperature treatment",
                        N_pc = NA,
                        Na = NA,
                        LMA = NA,
                        LWC = NA,
                        Vcmax25 = spectra$VcmaxRef,
                        Jmax25 = spectra$JmaxRef,
                        Tp25 = spectra$TpRef,
                        Tleaf_ACi = spectra$Tleaf,
                        Spectra = I(as.matrix(spectra[,3:2153] * 100))) ## Reflectance in % (0 - 100)
f.plot.spec(Z = spectra$Spectra, wv = 350:2500)


save(spectra,file = paste0(fpath,'3_Spectra_traits.Rdata'))
