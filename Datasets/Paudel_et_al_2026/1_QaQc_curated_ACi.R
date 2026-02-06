#This code is used to do the step 1 of the data curation process.
#It is used to analyse and check the data quality..
#This step visually checks each ACi curve to ensure the gas-exchange measurements look reasonable and correctly ordered.
#We plot net photosynthesis (A) against intercellular CO2 (Ci) for each sample, label individual measurement points, and save all curves into a single PDF file.
#NEW (required change):
#   - For Ci values between around 300, if the SAME Ci appears multiple times within a curve we keep ONLY the last occurrence and flag the earlier ones as bad duplicate points.
#   - Bad duplicate points are marked red dots for traceability.

# Load the 'here' package to easily reference files and folders path, which is robust and independent on platform (Linux, Windows)
library(here)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Paudel_et_al_2026' folder where the data is located
setwd(file.path(path,'/Datasets/Paudel_et_al_2026'))


load("0_curated_data.Rdata", verbose = TRUE)

# Add SampleID + Record (point index per curve)
curated_data$SampleID <- as.character(curated_data$Sample)
curated_data$Record <- ave(curated_data$Ci, curated_data$Sample_num, FUN = seq_along)

# Default flags
curated_data$keep_point <- TRUE
curated_data$QC_flag <- "ok"

# Identify points inside 270–350
in_range <- curated_data$Ci >= 270 & curated_data$Ci <= 350

# For each curve: keep only the last Record in that range
idx_by_curve <- split(seq_len(nrow(curated_data)), curated_data$Sample_num)

for (sid in names(idx_by_curve)) {
  ii <- idx_by_curve[[sid]]
  ii_in <- ii[in_range[ii]]
  
  if (length(ii_in) >= 2) {
    last_i <- ii_in[which.max(curated_data$Record[ii_in])]
    bad_i  <- setdiff(ii_in, last_i)
    
    curated_data$keep_point[bad_i] <- FALSE
    curated_data$QC_flag[bad_i] <- "bad_270_350_keep_last_only"
  }
}

# QA/QC PDF
pdf(file = "1_QA_QC_Aci.pdf", width = 8, height = 6)

for (sample_number in sort(unique(curated_data$Sample_num))) {
  
  curve_data <- curated_data[curated_data$Sample_num == sample_number, ]
  good_pts <- curve_data$keep_point
  bad_pts  <- !curve_data$keep_point
  
  plot(
    x = curve_data$Ci[good_pts],
    y = curve_data$A[good_pts],
    main = paste("Sample_num:", sample_number, "| Sample:", unique(curve_data$Sample)),
    xlab = "Ci (ppm)",
    ylab = expression(A~(mu*mol~m^{-2}~s^{-1})),
    pch  = 1,
    cex  = 1.3
  )
  
  if (any(bad_pts)) {
    points(curve_data$Ci[bad_pts], curve_data$A[bad_pts], pch = 16, col = "red", cex = 1.3)
  }
  
  text(curve_data$Ci, curve_data$A, labels = curve_data$Record, cex = 0.7)
}

dev.off()

# Save for fitting step
curated_data_qc <- curated_data
save(curated_data_qc, file = "1_QC_ACi_data.Rdata")



# Save ACi_data_flagged.csv


# Reloading ORIGINAL ACi data 
Aci_original <- read.csv("Aci_data.csv", stringsAsFactors = FALSE)

# Initialize flag column (empty by default)
Aci_original$Bad_Flagged <- ""

# Build a key to match rows correctly
key_original <- paste(
  Aci_original$Sample,
  Aci_original$A,
  Aci_original$Ci,
  Aci_original$Tleaf
)

key_curated <- paste(
  curated_data$Sample,
  curated_data$A,
  curated_data$Ci,
  curated_data$Tleaf
)

# Identify which original rows were flagged as bad
flagged_keys <- key_curated[curated_data$keep_point == FALSE]

Aci_original$Bad_Flagged[key_original %in% flagged_keys] <- "Yes"

# Write CSV
write.csv(
  Aci_original,
  file = "Aci_data_flagged.csv",
  row.names = FALSE
)

cat("Saved: Aci_data_flagged.csv\n")
cat("Only one column added: Bad_Flagged\n")
