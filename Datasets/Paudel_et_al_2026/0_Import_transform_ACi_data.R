
# This data was sent by Bipin Paudel


# WHAT this step does:
# This step reads the raw ACi gas-exchange data and keeps only the variables required for ACi curve fitting and QA/QC.
# This creates a clean, standardized ACi dataset that all later steps (QA/QC, curve fitting, and consistency checks) can rely on.
# Load the 'here' package to easily reference files and folders path, which is robust and independent on platform (Linux, Windows.)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Paudel_et_al_2026' folder where the data is located
setwd(file.path(path,'/Datasets/Paudel_et_al_2026'))


# Read ACi data (already curated CSV)
original_data <- read.csv("Aci_data.csv")

# Keep only required columns
curated_data <- original_data[, c(
  "Sample",
  "A",
  "Ci",
  "Patm",
  "Qin",
  "Tleaf"
)]

# Create numeric SampleID (for plotting and model fitting only)
curated_data$Sample_num <- as.numeric(as.factor(curated_data$Sample))

# Order by decreasing incident light (same convention as ACi fitting routines)
curated_data <- curated_data[order(-curated_data$Qin), ]

# Save curated data for next steps
save(curated_data, file = "0_curated_data.Rdata")

# Quick structure check
str(curated_data)
head(curated_data)