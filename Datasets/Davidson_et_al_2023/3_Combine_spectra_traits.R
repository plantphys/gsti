library(spectratrait)
library(here)
path <- here()

setwd(file.path(path,'/Datasets/Davidson_et_al_2023'))

spectra <- read.csv('Spec_Data.csv')
leaf_description <- read.csv("Leaf_Trait_Data.csv")
leaf_description <- leaf_description[,1:9]
leaf_description$USDA_Code <- as.factor(leaf_description$USDA_Code)
levels(leaf_description$USDA_Code) <- c("Acer rubrum","Acer saccharum","Betula alleghaniensis","Quercus alba","Quercus montana","Quercus rubra")

load("2_Result_1pt_fitting.Rdata" ,verbose=TRUE)

spectra=merge(x=spectra,y=Bilan,by.x = 'SampleID',by.y='SampleID')
spectra=merge(x=spectra,y=leaf_description,by.x = 'SampleID',by.y='SampleID')

spectra=data.frame(SampleID=spectra$SampleID,
                        dataset='Davidson_etal_2023',
                        Site_name ="BRF",
                        Species=spectra$USDA_Code,
                        Sun_Shade = "Sun",
                        Plant_type = "Wild",
                        Soil = "Natural",
                        Vcmax_method = "One point",
                        N_pc=NA,
                        Na=spectra$Na,
                        LMA=spectra$LMA,
                        LWC=NA,
                        Vcmax25=spectra$VcmaxRef,
                        Jmax25=NA,
                        Tp25=NA,
                        Tleaf_ACi=spectra$Tleaf,
                        Spectra=I(as.matrix(spectra[,4:2154])))## Reflectance in % (0-100)
f.plot.spec(Z = spectra$Spectra,wv = 350:2500)


save(spectra,file='3_Spectra_traits.Rdata')
