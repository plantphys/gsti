## This code is used to do the step 4 of the data curation process.
## It is used to import the Sample information data save it using a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Garcia_et_al_2022' folder where the data is located
setwd(file.path(path,'/Datasets/Garcia_et_al_2022'))

# loading the fitted data so we have the list of SampleID
load("2_Fitted_ACi_data.Rdata",verbose=TRUE)
SampleDetails=Bilan
SampleDetails$TreeID= sapply(SampleDetails$SampleID, function(x) strsplit(x, "B")[[1]][1])

# Importing the author's sample information
TreeInfo=read.csv("BCI_sample_metadata.csv")

# Merging the leaf composition with the leaf information
SampleDetails=merge(x=SampleDetails,y=TreeInfo,by.x="TreeID",by.y="tree_id")

# Inform the various information required
SampleDetails$Site_name="BCI" # Note that the site_name should be present in your Site.csv file
SampleDetails$Dataset_name="Garcia_et_al_2022"
SampleDetails$Species=paste(SampleDetails$Genus,SampleDetails$Species) # Genus species
SampleDetails$Sun_Shade="Sun"
SampleDetails[SampleDetails$branch_position=="shade","Sun_Shade"]="Shade"
SampleDetails$Phenological_stage="Mature"
SampleDetails$Photosynthetic_pathway="C3"
SampleDetails$Plant_type="Wild" # Wild, Agricultural, or Ornamental
SampleDetails$Soil="Natural" # Natural, Managed or Pot
SampleDetails$LMA=NA # Leaf mass area in g m-2. Here, LMA is already informed so I just print it 
SampleDetails$Narea=NA # Nitrogen content per surface area in g m-2
SampleDetails$Nmass=NA # Nitrogen content on a leaf dry weight basis. In mg . g  (i.e per thousand)
SampleDetails$Parea=NA # Phosphorus content per surface area in g m-2
SampleDetails$Pmass=NA # Phosphorus content on a leaf dry weight basis
SampleDetails$LWC=NA # Leaf water content (Fresh_weight - dry weight)/Fresh weight
SampleDetails$Chl=NA

# Keeping only the columns of the standard:
SampleDetails=SampleDetails[,c("SampleID","Site_name","Dataset_name","Species","Sun_Shade","Phenological_stage","Plant_type","Photosynthetic_pathway","Soil","LMA","Narea","Nmass","Parea","Pmass","LWC")]

# Saving the SampleDetails data
save(SampleDetails,file="4_SampleDetails.Rdata")

# Checking the overall dataset information. 
source(file.path(path,'/R/f.Check_dataset.R'))
f.Check_data(folder_path = getwd())
