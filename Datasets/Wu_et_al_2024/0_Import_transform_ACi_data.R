## This codes is used to do the step 0 of the data curation process.
## It imports and transforms the ACi data from Wu et al 2024.
## The dataset is available publicly : https://nph.onlinelibrary.wiley.com/doi/10.1111/nph.20267


# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)
library(readxl)

# Find the path of the top relative directory
path=here()

# Loading the ESS standard column names that will be used for all datasets
source(file.path(path,'/R/Correspondance_tables_ESS.R')) 

# Set the working directory to the 'Wu_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Wu_et_al_2024'))

# Import the authors original raw data

ls_ACi_files=dir(recursive = TRUE)
ls_ACi_files=ls_ACi_files[which(grepl(x=ls_ACi_files,pattern="ACI curve summary",ignore.case = TRUE))]
ACi_data=data.frame()
for (file in ls_ACi_files){
  data_file=read_xlsx(file)
  if (ncol(data_file)<60){
    data_file=data_file[,c("Species_ID","Obs","Date", "Photo", "Ci", "CO2S", "CO2R", "Cond", "Press", "PARi", "RH_S", "Tleaf")]
    colnames(data_file)=c("Name","Record","Date", "A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")
  } else {
  colnames(data_file)[2:ncol(data_file)]=data_file[1,2:ncol(data_file)]
  data_file=data_file[-c(1),]
  data_file=data_file[,c("Species_ID","obs","TIME", "A", "Ci", "CO2_s", "CO2_r", "gsw", "Pa", "Qin", "RHcham", "Tleaf")]
  colnames(data_file)=c("Name","Record","Date", "A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs", "Tleaf")
  }
  data_file=data_file[!is.na(data_file$Record),]
  data_file$Site=substr(x = file,start = nchar(file)-6,stop = nchar(file)-5)
  data_file$Excel_file=file
  ACi_data=rbind.data.frame(ACi_data,data_file)
}
ACi_data[ACi_data$Site=="BN","Site"]="XSBN"
ACi_data$SampleID=paste(ACi_data$Site,ACi_data$Name,sep="_")



# Select specific columns from the original data to create the curated data set
# Here I selected several times the column SampleID. This is because the Record and gsw columns were missing (column 2 and 7, respectively).
# I then rename this columns and populate them.

curated_data=ACi_data[,c("SampleID", "Record","A","Ci","CO2s","CO2r","gsw","Patm","Qin","RHs","Tleaf","Excel_file")]

# Convert the 'SampleID' column to a numerical factor which is simpler to use and refer to for analyzing the data
curated_data$SampleID_num=as.numeric(as.factor(curated_data$SampleID))

# Here I modify SampleID to be able to link the information at the leaf level.
curated_data$SampleID=gsub("-ACI","-L",curated_data$SampleID)
curated_data$SampleID=gsub("-M","",curated_data$SampleID)

curated_data[,2:11] = lapply(curated_data[,2:11],as.numeric)
curated_data=as.data.frame(curated_data)
# Saving the curated dataset
save(curated_data,file='0_curated_data.Rdata')
