## This code is used to do the step 4 of the data curation process.
## It is used to import the Sample information data save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'RodriguezCaton_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/RodriguezCaton_et_al_2024'))

# Importing the author's sample information
SampleDetails=read.csv("RodriguezCaton_2024_SampleDetails.csv")

# Inform the various information required
SampleDetails$Site_name="LSVA" # Note that the site_name should be present in your Site.csv file
SampleDetails$Dataset_name="RodriguezCaton_et_al_2024"
SampleDetails$Species=SampleDetails$Species_Name # Genus species
SampleDetails$Sun_Shade="Sun"
SampleDetails$Phenological_stage="Mature"
SampleDetails$Plant_type="Wild" # Wild, Agricultural, or Ornamental
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Soil="Natural" # Natural, Managed or Pot
SampleDetails$LMA =NA# Leaf mass area in g m-2.
SampleDetails$Narea =NA# Nitrogen content per surface area in g m-2
SampleDetails$Nmass =NA# Nitrogen content on a leaf dry weight basis. In mg . g  (i.e per thousand)
SampleDetails$Parea=NA # Phosphorus content per surface area in g m-2
SampleDetails$Pmass=NA # Phosphorus content on a leaf dry weight basis
SampleDetails$LWC=NA  # Leaf water content (Fresh_weight - dry weight)/Fresh weight

# Keeping only the columns of the standard:
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Photosynthetic_pathway","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

# Saving the SampleDetails data
save(SampleDetails,file="4_SampleDetails.Rdata")

# Checking the overall dataset information. 
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
