## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Wang et al 2021
## The dataset was sent by Sheng Wang


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 
source(file.path(path,'/R/Photosynthesis_tools.R')) 

# Set the working directory to the 'Wang_et_al_2021' folder where the data is located
setwd(file.path(path,'/Datasets/Wang_et_al_2021'))

# Import the authors original raw data
ls_files=dir(recursive = TRUE) ## This lists all the files that are in the same folder as this R code.

## Only keeping the licor 6800 files
ls_files_Li6800=ls_files[which(grepl(x=ls_files,pattern=".xlsx")&grepl(x=ls_files,pattern="ACi_data"))]

## Import and bind the data from all the files
data_6800=data.frame()
col_names=c("obs","A","Ci","CO2_s","CO2_r","gsw","Pa","Qin","RHcham","Tleaf","file")
for(file in ls_files_Li6800){
  print(paste('###################',file))
  file_6800=f.import_licor6800(column_display = c("A", "gsw", "Qin", 
                                                  "Ci", "file"),file = file,do.print = FALSE,nskip_header = 14,nskip_data = 16)
  
  data_6800=rbind.data.frame(data_6800,file_6800[,col_names])  
}
which(is.na(data_6800$Ci))

data_6800$SampleID=sub("\\.xlsx$", "", basename(data_6800$file))

# Select specific columns from the original data to create the curated data set
# Here I selected several times the column SampleID. This is because the Record and gsw columns were missing (column 2 and 7, respectively).
# I then rename this columns and populate them.

curated_data=data_6800[,c("SampleID","obs","A","Ci","CO2_s","CO2_r","gsw","Pa","Qin","RHcham","Tleaf","file")]

# Rename the columns of the curated dataset with the ESS standard
colnames(curated_data)=c(ESS_column)

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
