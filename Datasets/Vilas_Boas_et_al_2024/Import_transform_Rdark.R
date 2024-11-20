## This code is used to import and transform dark respiration data. This is an optional step of the process.
## It is used to import Rdark data and transform it in a standard format

# Load the 'here' package to easily reference files and folders path, which is robust and independent on your platform (Linux, Windows..)
library(here)
library(readxl)

# Find the path of the top relative directory
path=here()

# Set the working directory to the 'Vilas_Boas_et_al_2024' folder where the data is located
setwd(file.path(path,'/Datasets/Vilas_Boas_et_al_2024'))

# List all the licor raw data, and detect the Rdark files
ls_li6400=dir(recursive = TRUE)
ls_li6400=ls_li6400[which(grepl(x=ls_li6400,pattern="Dark",ignore.case = TRUE)&grepl(x=ls_li6400,pattern="_.xlsx",ignore.case = TRUE))]

# Import all the Rdark data
curated_data=data.frame()
for (file in ls_li6400){
  data_header=read_xlsx(file)
  header=unlist(data_header[which(data_header[,1]=="Obs"),])
  data_file=read_xlsx(file,skip=(which(data_header[,1]=="Obs")),col_names = header)
  data_file=data_file[!is.na(as.numeric(data_file$Obs)),]
  data_file$file=file
  data_file=data_file[,c("SampleID","Obs","Photo","Ci","CO2S","CO2R","Cond","Press","PARi","RH_S","Tleaf","file")]
  curated_data=rbind.data.frame(curated_data,data_file)
}

# Rename the columns of the curated dataset with the ESS standard
colnames(curated_data)=c("SampleID","Record","A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs","Tleaf","file")
curated_data=as.data.frame(curated_data)

# QaQc the Rdark data and averaging the observations to constitute one measurement per leaf
Rdark_data=data.frame()
pdf(file = "QaQc_Rdark_data.pdf")
for (SampleID in unique(curated_data$SampleID)){
  leaf_data=curated_data[curated_data$SampleID==SampleID,]
  plot(x=leaf_data$Record,y=leaf_data$A,ylim=c(-3,0.5))
  points(x=leaf_data[(nrow(leaf_data)-10):nrow(leaf_data),"Record"],y=leaf_data[(nrow(leaf_data)-10):nrow(leaf_data),"A"],col="red")
  aggregated_data=apply(leaf_data[(nrow(leaf_data)-10):nrow(leaf_data),c("A", "Ci", "CO2s", "CO2r", "gsw", "Patm", "Qin", "RHs","Tleaf")],MARGIN = 2,FUN = function(x) mean(as.numeric(x)))
  aggregated_data$SampleID=SampleID
  Rdark_data=rbind.data.frame(Rdark_data,aggregated_data)
}
dev.off()


# Creating a Rdark dataframe
Rdark=data.frame(SampleID=Rdark_data$SampleID,Rdark=-Rdark_data$A,Tleaf_Rdark=Rdark_data$Tleaf)

# Checking data quality
hist(Rdark$Rdark) # No negative values
hist(Rdark$Tleaf_Rdark)


# Saving Rdark data
save(Rdark,file="Rdark_data.Rdata")
