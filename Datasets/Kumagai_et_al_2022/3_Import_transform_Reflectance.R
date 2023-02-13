library(spectratrait)

path=here()
setwd(file.path(path,'Datasets/Kumagai_et_al_2022'))
load("2_Fitted_ACi_data.Rdata")

# read csv data
Reflectance <- data.frame()
datafiles <- list.files(file.path(path,'Datasets/Kumagai_et_al_2022/ASD'), pattern = "\\.csv$")
for (filename in datafiles){
    csv_data <- read.csv(paste0(file.path(path,'Datasets/Kumagai_et_al_2022/ASD//'), filename))
    csv_data$ID <- paste0(substr(filename, 1, 10), '-', csv_data$Spectra)
    Reflectance <- rbind.data.frame(Reflectance, csv_data)
}


# spectral_file <- paste0(fpath, "Reflectance_data.xlsx")
# excel_data <- read_excel(spectral_file)
# excel_cnames <- paste0("Wave_", 350:2500)
# spectra <- excel_data[excel_cnames]
# spectra <- as.data.frame(lapply(spectra, as.numeric))
# spectra$ID <- paste(excel_data$Year, excel_data$Date, excel_data$Name, sep = " ")
Reflectance <- merge(x = Reflectance, y = Bilan, by.x = 'ID', by.y='SampleID')
Reflectance$SampleID=Reflectance$ID
Reflectance$Spectrometer="ASD FieldSpec 4 Hi-Res"
Reflectance$Leaf_clip="ASD Leaf Clip"
Reflectance$Reflectance=I(as.matrix(Reflectance[,3:2153] * 100))
f.plot.spec(Z = Reflectance$Reflectance, wv = 350:2500)
save(spectra,file = '3_QC_Reflectance_data.Rdata')
