## This code is used to do the step 4 of the data curation process.
## It is used to import the Sample information data save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Cui_et_al_2025' folder where the data is located
setwd(file.path(path,'/Datasets/Cui_et_al_2025'))

# Importing the author's sample information
SampleDetails=read.csv("SampleDetails.csv")

# Importing the leaf chemical information
Leaf_traits=read.csv("Leaf traits.csv")

SampleDetails=merge(SampleDetails,Leaf_traits,by="SampleID",all.x=TRUE)
# Inform the various information required
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Soil = "Managed" # Natural, Managed or Pot
SampleDetails$LMA = SampleDetails$lma.g.m2
SampleDetails$Narea = SampleDetails$leafn/100*SampleDetails$LMA # Nitrogen content per surface area in g m-2
SampleDetails$Nmass = SampleDetails$leafn*10 # Nitrogen content on a leaf dry weight basis. In mg . g  (i.e per thousand)
SampleDetails$Parea = NA # Phosphorus content per surface area in g m-2
SampleDetails$Pmass = NA # Phosphorus content on a leaf dry weight basis
SampleDetails$LWC = NA # Leaf water content (Fresh_weight - dry weight)/Fresh weight

# Keeping only the columns of the standard:
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

# Saving the SampleDetails data
save(SampleDetails,file="4_SampleDetails.Rdata")

# Checking the overall dataset information. 
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())

