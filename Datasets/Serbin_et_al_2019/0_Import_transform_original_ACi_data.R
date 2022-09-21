library(here)
path <- here()

source(file.path(path,'/R/Correspondance_tables_ESS.R'))
setwd(file.path(path,'/Datasets/Serbin_et_al_2019'))

src_data_dir <- file.path("LiCor_data")
#original_data <- read.csv(file.path(src_data_dir,'CVARS_Compiled_ACi_Data_June2013.csv'), header = T)
original_data <- read.csv(file.path(src_data_dir,'concatenated_ag_gasex_data.csv'), header = T, stringsAsFactors = F)
head(original_data)
names(original_data)
#curated_data <- original_data[,c("Site", "Plot","USDA_Species", "Tree_Plant_Number", "Leaf_Number", "Canopy_Position",
#                                 "Leaf_Age", "Sample_Name", "Date", "Photo", "Ci","CO2S","CO2R","Cond","Press",
#                                 "PARi","RH_S","Tleaf","QC","Rep")]     

sampID <- paste0(original_data$Sample_Name, "_", original_data$Rep, "_", as.Date(as.character(original_data$Date), format = "%Y%m%d"))
original_data$Sample_ID_Name <- sampID
original_data$SampleID <- as.numeric(as.factor(sampID))
head(original_data)

curated_data <- original_data[,c("SampleID","Obs","Photo", "Ci","CO2S","CO2R","Cond","Press",
                                 "PARi","RH_S","Tleaf","Sample_ID_Name","QC","Rep")] 
names(curated_data)
head(curated_data)

colnames(curated_data)=c(ESS_column,'Sample_ID_Name','QCauthors','Replicate')
head(curated_data)

curated_data[curated_data$Replicate==-9999,'Replicate']=1
curated_data$QCauthors[curated_data$QCauthors==0L]=NA
curated_data$Obs=NA
head(curated_data)

## Adding a 'Obs' information to the dataset
for(SampleID in curated_data$SampleID){
  curated_data[curated_data$SampleID==SampleID,'Obs']=1:nrow(curated_data[curated_data$SampleID==SampleID,])
}
head(curated_data)

## Adding a numeric SampleID -- WHY DO WE NEED THIS TOO?  Need to ask Julien
curated_data$SampleID_num <- as.numeric(as.factor(paste(curated_data$SampleID,curated_data$Replicate)))
head(curated_data)

save(curated_data,file='0_curated_data.Rdata')

## TODO: NEED TO PROCESS ALL SRC DATA SIMILARLY THEN ADD TO A SINGLE L0 FILE



