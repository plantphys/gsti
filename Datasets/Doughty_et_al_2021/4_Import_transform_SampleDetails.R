## This code is used to do the step 4 of the data curation process.
## It is used to import the Sample information data save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Doughty_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Doughty_et_al_2021'))

# Importing the author's sample information
SampleDetails=read.csv("traitdata.csv")

# Importing the leaf composition traits
TreeInfo=read.csv("speciesdata.csv")

# Merging the leaf composition with the leaf information
SampleDetails=merge(x=SampleDetails,y=TreeInfo,by.x="Tree_tag",by.y="TagNumber")

# Inform the various information required
SampleDetails$Site_name="SAFE_tower" # Note that the site_name should be present in your Site.csv file
SampleDetails$SampleID
SampleDetails$Dataset_name="Doughty_et_al_2021"
SampleDetails$Species=SampleDetails$GenusSpecies # Genus species
SampleDetails[SampleDetails$Species=="NaN","Species"]="Unknown"
SampleDetails$Sun_Shade="Sun"
SampleDetails$Phenological_stage="Mature"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild" # Wild, Agricultural, or Ornamental
SampleDetails$Soil="Natural" # Natural, Managed or Pot
SampleDetails$LMA = as.numeric(SampleDetails$LMA) # Leaf mass area in g m-2. Here, LMA is already informed so I just print it 
SampleDetails$Narea = NA # Nitrogen content per surface area in g m-2
SampleDetails$Nmass = NA # Nitrogen content on a leaf dry weight basis. In mg . g  (i.e per thousand)
SampleDetails$Parea=NA # Phosphorus content per surface area in g m-2
SampleDetails$Pmass=NA # Phosphorus content on a leaf dry weight basis
SampleDetails$LWC = (SampleDetails$leaf.fresh.weight-SampleDetails$dry.weight)/SampleDetails$leaf.fresh.weight*100  # Leaf water content (Fresh_weight - dry weight)/Fresh weight

# Keeping only the columns of the standard:
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

# Saving the SampleDetails data
save(SampleDetails,file="4_SampleDetails.Rdata")

# Checking the overall dataset information. 
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
