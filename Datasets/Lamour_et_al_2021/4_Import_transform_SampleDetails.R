## This code is used to do the step 4 of the data curation process.
## It is used to import the Sample information data save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Lamour_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Lamour_et_al_2021'))

# Importing the author's sample information
SampleDetails=read.csv("PA-SLZ_2020_SampleDetails.csv")

# Importing the leaf composition traits
Chem_data=read.csv("PA-SLZ_2020_CHN_LMA_data.csv")

# Merging the leaf composition with the leaf information
SampleDetails=merge(x=SampleDetails,y=Chem_data,by.x="SampleID",by.y="SampleID")

# Inform the various information required
SampleDetails$Site_name="SLZ" # Note that the site_name should be present in your Site.csv file
SampleDetails$Dataset_name="Lamour_et_al_2021"
SampleDetails$Species=SampleDetails$Species_Name # Genus species
SampleDetails$Sun_Shade="Shade"
SampleDetails[SampleDetails$Vertical_Elevation%in%c(0,1),"Sun_Shade"]="Sun" # Sun, Shade or NA
SampleDetails$Phenological_stage=SampleDetails$Phenological_Stage
SampleDetails$Plant_type="Wild" # Wild or Agricultural
SampleDetails$Soil="Natural" # Natural, Managed or Pot
SampleDetails$LMA # Leaf mass area in g m-2. Here, LMA is already informed so I just print it 
SampleDetails$Narea # Nitrogen content per surface area in g m-2
SampleDetails$Nmass # Nitrogen content on a leaf dry weight basis. In mg . g  (i.e per thousand)
SampleDetails$Parea=NA # Phosphorus content per surface area in g m-2
SampleDetails$Pmass=NA # Phosphorus content on a leaf dry weight basis
SampleDetails$LWC # Leaf water content (Fresh_weight - dry weight)/Fresh weight

# Keeping only the columns of the standard:
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

# Saving the SampleDetails data
save(SampleDetails,file="4_SampleDetails.Rdata")

# Checking the overall dataset information. 
source(file.path(path,'/R/f.CHeck_dataset.R'))
f.Check_data(folder_path = getwd())