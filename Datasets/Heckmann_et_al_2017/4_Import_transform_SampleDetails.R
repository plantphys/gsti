## This code is used to do the step 4 of the data curation process.
## It is used to import the Sample information data save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Heckmann_et_al_2017' folder where the data is located
setwd(file.path(path,'/Datasets/Heckmann_et_al_2017'))

# Importing the author's sample information
SampleDetails=read.csv("table_heckmann2017.csv")

# Keeping C3 species only
SampleDetails = SampleDetails[SampleDetails$photosynthesis=="C3",]
SampleDetails$Photosynthetic_pathway="C3"

# Inform the various information required
SampleDetails$SampleID=SampleDetails$Li6400.file
SampleDetails$Dataset_name = "Heckmann_et_al_2017"
SampleDetails$LMA = NA # Leaf mass area in g m-2. Here, LMA is already informed so I just print it 
SampleDetails$Narea = NA # Nitrogen content per surface area in g m-2
SampleDetails$Nmass = SampleDetails$N.*10 # Nitrogen content on a leaf dry weight basis. In mg . g  (i.e per thousand)
SampleDetails$Parea = NA # Phosphorus content per surface area in g m-2
SampleDetails$Pmass = NA # Phosphorus content on a leaf dry weight basis
SampleDetails$LWC = SampleDetails$LWC # Leaf water content (Fresh_weight - dry weight)/Fresh weight
SampleDetails$Chl=NA

# Keeping only the columns of the standard:
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

# Saving the SampleDetails data
save(SampleDetails,file="4_SampleDetails.Rdata")

# Checking the overall dataset information. 
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
