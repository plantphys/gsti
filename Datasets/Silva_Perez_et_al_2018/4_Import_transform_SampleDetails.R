## This code is used to do the step 4 of the data curation process.
## It is used to import the Sample information data save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Silva_Perez_et_al_2018' folder where the data is located
setwd(file.path(path,'/Datasets/Silva_Perez_et_al_2018'))

# Most data was processed during the Reflectance curation process
load('3_QC_Reflectance_data.Rdata',verbose = TRUE)
SampleDetails=Reflectance[,colnames(Reflectance)!="Reflectance"]


# Inform the various information required
SampleDetails$Dataset_name="Silva_Perez_et_al_2018"
SampleDetails$Site_name="CSIRO_BMC"
SampleDetails[SampleDetails$Exp%in%c("CA_Mex","CB_Mex"),"Site_name"]="CENEB"
SampleDetails[SampleDetails$Exp%in%c("BYPB_Aus3","CA_Aus3","EVA_Aus3"),"Site_name"]="CSIRO_G"
SampleDetails$Species="Triticum species"
SampleDetails$Sun_Shade="Sun"
SampleDetails$Phenological_stage="Mature"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Agricultural" # Wild, Agricultural, or Ornamental
SampleDetails$Soil="Managed" # Natural, Managed or Pot
SampleDetails[SampleDetails$Site_name=="CSIRO_BMC","Soil"]="Pot"
SampleDetails$LMA=SampleDetails$LMA_O # Leaf mass area in g m-2. Here, LMA is already informed so I just print it 
SampleDetails$Narea=SampleDetails$Narea_O # Nitrogen content per surface area in g m-2
SampleDetails$Nmass=SampleDetails$Narea*1000/SampleDetails$LMA# Nitrogen content on a leaf dry weight basis. In mg . g  (i.e per thousand)
SampleDetails$Parea=SampleDetails$Parea_O # Phosphorus content per surface area in g m-2
SampleDetails$Pmass=SampleDetails$Parea*1000/SampleDetails$LMA # Phosphorus content on a leaf dry weight basis
SampleDetails$LWC=NA # Leaf water content (Fresh_weight - dry weight)/Fresh weight

# Keeping only the columns of the standard:
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

# Saving the SampleDetails data
save(SampleDetails,file="4_SampleDetails.Rdata")

# Checking the overall dataset information. 
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
