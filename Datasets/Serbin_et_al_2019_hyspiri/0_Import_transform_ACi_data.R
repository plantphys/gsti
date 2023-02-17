library(here)
path <- here()

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Serbin_et_al_2019_hyspiri'))
getwd()

src_data_dir <- file.path("LiCor_data")

#--------------------------------------------------------------------------------------------------#
# curate the Ag datasets
orig_ag_data <- read.csv(file.path(src_data_dir,'concatenated_ag_gasex_data.csv'), 
                         header = T, stringsAsFactors = F)

# using combined is going to take some additional work to get whats needed to match with spec
# not in the ecosis version
#orig_ag_data <- read.csv(file.path(src_data_dir,'concatenated_gasex_data.csv'), 
#                         header = T, stringsAsFactors = F)

head(orig_ag_data)
names(orig_ag_data)

#!! OLD
#curated_data <- original_data[,c("Site", "Plot","USDA_Species", "Tree_Plant_Number", "Leaf_Number", "Canopy_Position",
#                                 "Leaf_Age", "Sample_Name", "Date", "Photo", "Ci","CO2S","CO2R","Cond","Press",
#                                 "PARi","RH_S","Tleaf","QC","Rep")]     
#!! OLD

sampID <- paste0(orig_ag_data$Sample_Name, "_", orig_ag_data$Rep, "_", 
                 as.Date(as.character(orig_ag_data$Date), format = "%Y%m%d"))
orig_ag_data$Sample_ID_Name <- sampID
orig_ag_data$SampleID <- as.numeric(as.factor(sampID))
head(orig_ag_data)

curated_data <- orig_ag_data[,c("SampleID","Obs","Photo", "Ci","CO2S","CO2R","Cond","Press",
                                 "PARi","RH_S","Tleaf","Sample_ID_Name","QC","Rep")] 
names(curated_data)
head(curated_data)

colnames(curated_data)=c(ESS_column,'Sample_ID_Name','QCauthors','Replicate')
##Julien modification: I changed your column name to be consistent with other datasets
curated_data=curated_data[,-which(colnames(curated_data)=='SampleID')]
curated_data$SampleID=curated_data$Sample_ID_Name

head(curated_data)

curated_data[curated_data$Replicate==-9999,'Replicate']=1
curated_data$QCauthors[curated_data$QCauthors==0L]=NA
#curated_data$Record=NA
head(curated_data)

## Adding a 'Record' information to the dataset
#for(SampleID in curated_data$SampleID){
#  curated_data[curated_data$SampleID==SampleID,'Record']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
#}
#head(curated_data)

## Adding a numeric SampleID -- WHY DO WE NEED THIS TOO?  Need to ask Julien
# Julien's answer: To facilitate the QAQC process. Usually the SampleID name are so long it
# is tedious to display them, read them and use them to flag bad points or curves.. 

curated_data$SampleID_num <- as.numeric(as.factor(curated_data$SampleID))
head(curated_data)

curated_data <- curated_data[order(curated_data$SampleID_num),]

save(curated_data,file='0_curated_data.Rdata')
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
# curate the non Ag datasets HERE
# TBD
#--------------------------------------------------------------------------------------------------#
## TODO: NEED TO PROCESS ALL SRC DATA SIMILARLY THEN ADD TO A SINGLE L0 FILE



