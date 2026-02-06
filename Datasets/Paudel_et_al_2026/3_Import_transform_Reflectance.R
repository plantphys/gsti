
#  Import and standardize hyperspectral reflectance


# WHAT this step does:
# This step reads raw UAV VNIR reflectance, smooths and interpolates it, and formats it into the exact structure required by f.Check_data().
# We detect wavelength columns, smooth spectra using Savitzky-Golay, interpolate to 1-nm (398 to 1002), and then pad NA values so the final spectra cover 350 to 2500 nm (checker requirement).


# Load the 'here' package to easily reference files and folders path, which is robust and independent on platform (Linux, Windows)
library(here)

## Install and load spectratrait (from GitHub)

# Install devtools if not already installed
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Install spectratrait from GitHub
devtools::install_github("plantphys/spectratrait")

# Load the spectratrait package
library(spectratrait)

library(signal)
# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Paudel_et_al_2026' folder where the data is located
setwd(file.path(path,'/Datasets/Paudel_et_al_2026'))

# 2) Read raw reflectance CSV
raw_reflectance <- read.csv("Raw_Reflectance.csv", check.names = FALSE, stringsAsFactors = FALSE)

# 3) Identify wavelength columns (numeric column names)
is_wavelength <- suppressWarnings(!is.na(as.numeric(names(raw_reflectance))))
wavelength_columns <- names(raw_reflectance)[is_wavelength]

native_wavelengths <- as.numeric(wavelength_columns)
order_index <- order(native_wavelengths)
native_wavelengths <- native_wavelengths[order_index]
wavelength_columns <- wavelength_columns[order_index]

# 4) Extract metadata columns
metadata_columns <- setdiff(names(raw_reflectance), wavelength_columns)
reflectance_metadata <- raw_reflectance[, metadata_columns, drop = FALSE]

# Must have Sample
if (!("Sample" %in% names(reflectance_metadata))) {
  stop("Column 'Sample' not found in Raw_Reflectance.csv")
}

# Add SampleID 
reflectance_metadata$SampleID <- as.character(reflectance_metadata$Sample)

# SampleID must be unique
if (anyDuplicated(reflectance_metadata$SampleID)) {
  duplicate_ids <- unique(reflectance_metadata$SampleID[duplicated(reflectance_metadata$SampleID)])
  stop("Duplicate SampleID(s) found in reflectance metadata: ", paste(duplicate_ids, collapse = ", "))
}

# 5) Wavelength grids 
target_wavelengths_vnir <- 398:1002
target_wavelengths_full <- 350:2500   # REQUIRED by f.Check_data()
number_full <- length(target_wavelengths_full)

# 6) Output reflectance matrix (350 to 2500)
Reflectance_matrix <- matrix(
  NA_real_,
  nrow = nrow(raw_reflectance),
  ncol = number_full,
  dimnames = list(reflectance_metadata$SampleID, as.character(target_wavelengths_full))
)

# 7) Fill matrix (smooth + interpolate to 398 to 1002)
for (i in seq_len(nrow(raw_reflectance))) {
  
  spectrum_raw <- as.numeric(raw_reflectance[i, wavelength_columns])
  
  # Smooth on native bands
  spectrum_smooth <- sgolayfilt(spectrum_raw, n = 9, p = 1)
  
  # Interpolate within VNIR range
  spectrum_interp <- approx(
    x = native_wavelengths,
    y = spectrum_smooth,
    xout = target_wavelengths_vnir
  )$y
  
  # Store into full matrix (350 to 397 stays NA; 398 to 1002 filled; 1003 to 2500 stays NA)
  Reflectance_matrix[i, as.character(target_wavelengths_vnir)] <- spectrum_interp
}

# 8) Create  Reflectance object 
Reflectance <- reflectance_metadata
Reflectance$Reflectance <- Reflectance_matrix

Reflectance$Spectrometer <- "Headwall Nano-Hyperspec VNIR (UAV)"
Reflectance$Probe_type <- "Imager"
Reflectance$Probe_model <- NA
Reflectance$Spectra_trait_pairing <- "Plant scale"

save(Reflectance, file = "3_QC_Reflectance_data.Rdata")

# 9) Save CSV (350 to 2500 columns)
reflectance_csv <- cbind(
  reflectance_metadata,
  as.data.frame(Reflectance_matrix, check.names = FALSE)
)

write.csv(reflectance_csv, "Interpolated_Reflectance.csv", row.names = FALSE)

cat("Done.\n")
cat("Saved: 3_QC_Reflectance_data.Rdata\n")
cat("Saved: 3_QC_Reflectance_data_350_2500_1nm.csv\n")
