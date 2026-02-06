
##  Import SampleDetails  and save in standard format

## WHAT this step does:
## This step imports sample-level metadata (species, site, traits, etc.) from "Sample details.csv" and prepares it for dataset consistency checks.
## We read the CSV while preserving the original column names, keep only the standard metadata columns, and create the specific column names required by f.Check_data() (SampleID, Site_name, Dataset_name).

# Load the 'here' package to easily reference files and folders path, which is robust and independent on platform (Linux, Windows)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Paudel_et_al_2026' folder where the data is located
setwd(file.path(path,'/Datasets/Paudel_et_al_2026'))

# Import SampleDetails
SampleDetails <- read.csv(
  "Sample details.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# Keep only the standard columns 
SampleDetails <- SampleDetails[, c(
  "Sample",
  "Dataset",
  "Site",
  "Species",
  "Clone",
  "Sun_Shade",
  "Phenological_stage",
  "Photosynthetic_pathway",
  "Plant_type",
  "Soil",
  "Leaf area",
  "Leaf weight",
  "LMA",
  "Nconc_percent",
  "Parea",
  "Pmass",
  "LWC",
  "Narea",
  "Nmass"
)]


# Save standardized SampleDetails
save(SampleDetails, file = "4_SampleDetails.Rdata")


# Run dataset consistency check
# f.Check_dataset.R is located in the Author folder
source("f.Check_dataset.R")

# Run validation
f.Check_data(folder_path = getwd())
