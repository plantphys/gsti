## This code is used to do the step 4 of the data curation process.
## It is used to import the Sample information data save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Ogaya_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Ogaya_et_al_2022'))

# Importing the Fitted ACI data (needed to only keep the sample Info associated with the ACI data)
load("2_Fitted_ACi_data.Rdata",verbose=TRUE)

# Importing the leaf composition traits
# Chem_data_saplings=read.csv("Chemistry_Saplings_Verryckt_et_al_2022.csv") !!! No spectra associated with this data
SampleDetails=read.csv("Chemistry_Trees_Verryckt_et_al_2022.csv")
SampleDetails=SampleDetails[-1,]
SampleDetails=SampleDetails[SampleDetails$ID%in%Bilan$SampleID,]

# Inform the various information required
SampleDetails$SampleID=SampleDetails$ID
SampleDetails$Site_name="Paracou" # Note that the site_name should be present in your Site.csv file
SampleDetails[SampleDetails$Site=="NOU","Site_name"]="Nouragues" # Note that the site_name should be present in your Site.csv file
SampleDetails$Dataset_name="Ogaya_et_al_2022"
SampleDetails$Species=paste(SampleDetails$Genus,SampleDetails$Species) # Genus species
SampleDetails$Sun_Shade="Shade" ## I considered that all the trees with CII less than 4 are shaded (JL 20231220)
SampleDetails[SampleDetails$Branch=="T"&SampleDetails$CII%in%c("4","5"),"Sun_Shade"]="Sun"
SampleDetails$Phenological_stage="Mature"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild" # Wild, Agricultural, or Ornamental
SampleDetails$Soil="Natural" # Natural, Managed or Pot
SampleDetails$LMA=1/as.numeric(SampleDetails$SLA)*10000 # Leaf mass area in g m-2. 
SampleDetails$Narea=SampleDetails$LMA*as.numeric(SampleDetails$N)/100 # Nitrogen content per surface area in g m-2
SampleDetails$Nmass=as.numeric(SampleDetails$N)*10 # Nitrogen content on a leaf dry weight basis. In mg . g  (i.e per thousand)
SampleDetails$Parea=SampleDetails$LMA*as.numeric(SampleDetails$P)/100 # Phosphorus content per surface area in g m-2
SampleDetails$Pmass=SampleDetails$LMA*as.numeric(SampleDetails$P)*10 # Phosphorus content on a leaf dry weight basis
SampleDetails$LWC=NA # Leaf water content (Fresh_weight - dry weight)/Fresh weight

# Keeping only the columns of the standard:
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_Pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

# Saving the SampleDetails data
save(SampleDetails,file="4_SampleDetails.Rdata")

# Checking the overall dataset information. 
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())

