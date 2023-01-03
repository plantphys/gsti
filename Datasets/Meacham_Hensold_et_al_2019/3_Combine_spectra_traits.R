library(magrittr)
library(readxl)
library(spectratrait)

path=here()
setwd(file.path(path,'/Datasets/Meacham_Hensold_et_al_2019'))
load("2_Result_ACi_fitting.Rdata")
spectral_file <- paste0(file.path(path,'/Datasets/Meacham_Hensold_et_al_2019'), "/Reflectance_data.xlsx")
excel_data <- read_excel(spectral_file)
excel_cnames <- paste0("Wave_", 350:2500)
spectra <- excel_data[excel_cnames]
spectra <- as.data.frame(lapply(spectra, as.numeric))
spectra$ID <- paste(excel_data$Year, excel_data$Date, excel_data$Name, sep = " ")
spectra <- merge(x = spectra, y = Bilan, by.x = 'ID', by.y='SampleID')

spectra=data.frame(SampleID=spectra$SampleID_num,
                        dataset = 'Meacham_Hensold_et_al_2019',
                        Species = 'Nicotiana tabacum',
                        N_pc = NA,
                        Na = NA,
                        LMA = NA,
                        LWC = NA,
                        Vcmax25 = spectra$VcmaxRef,
                        Jmax25 = spectra$JmaxRef,
                        Tp25 = spectra$TpRef,
                        Tleaf_ACi = spectra$Tleaf,
                        Spectra = I(as.matrix(spectra[,2:2152] * 100))) ## Reflectance in % (0 - 100)
f.plot.spec(Z = spectra$Spectra, wv = 350:2500)


save(spectra,file = '3_Spectra_traits.Rdata')
