
## STEP 2 — Fit ACi curves and estimate photosynthetic parameters (Paudel)

## WHAT this step does:
## 1) Loads the QA/QC ACi dataset from Step 1 .
## 2) Removes ONLY the bad points from the fitting input. This means fitting is done using ONLY the retained (“good”) points. Bad points remain saved in 1_QC_ACi_data.Rdata for traceability.
## 3) Fits one ACi curve per sample using f.fit_ACi().
## 4) Saves fitted parameters (Bilan) for later merging with spectra and metadata.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on platform (Linux, Windows)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Paudel_et_al_2026' folder where the data is located
setwd(file.path(path,'/Datasets/Paudel_et_al_2026'))


# 2) Load ACi fitting functions ----
source("fit_Vcmax.R")
source("Photosynthesis_tools.R")

# 3) Load quality-checked ACi data (from Step 1) 
load("1_QC_ACi_data.Rdata")  # loads curated_data_qc

# Use the object saved in the previous step
if (exists("curated_data_qc")) {
  ACi_data <- curated_data_qc
} else if (exists("curated_data")) {
  ACi_data <- curated_data
} else {
  stop("Neither curated_data_qc nor curated_data found in loaded RData.")
}

# 4) Create column names required by the ACi fitting function 
ACi_data$SampleID     <- as.character(ACi_data$Sample)
ACi_data$SampleID_num <- as.integer(ACi_data$Sample_num)

# 5) Fit ONLY the kept points (bad points are excluded from fitting) 
ACi_data_fit <- ACi_data[ACi_data$keep_point == TRUE, ]

# 6) Sort by curve and increasing Ci (required for stable fitting)
ACi_data_fit <- ACi_data_fit[order(ACi_data_fit$SampleID_num, ACi_data_fit$Ci), ]

# 7) Fit ACi curves (one curve per sample) 
Bilan <- f.fit_ACi(
  measures = ACi_data_fit,
  param    = f.make.param()
)

#  8) Attach SampleID and Sample name back to fitted parameters 
sample_map <- ACi_data_fit[!duplicated(ACi_data_fit$SampleID_num),
                           c("SampleID_num", "SampleID", "Sample")]

Bilan <- merge(Bilan, sample_map, by = "SampleID_num", all.x = TRUE, sort = FALSE)

# 9) Save fitted ACi parameters 
save(Bilan, file = "2_Fitted_ACi_data.Rdata")

cat("ACi fitting completed successfully.\n")
cat("Fitting used ONLY keep_point == TRUE (bad points excluded from fitting).\n")
cat("Saved: 2_Fitted_ACi_data.Rdata\n")
