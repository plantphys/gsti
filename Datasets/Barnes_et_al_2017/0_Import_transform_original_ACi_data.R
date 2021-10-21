library(here)

## I downloaded this dataset from the DOI  10.17605/OSF.IO/ZUR8E.


filename = '7_quality_checked_licor_datafiles.csv'
sampleID_column='fname'


original_data=read.csv(file = filename)
curated_data=original_data
correspondance_table=LICOR6400toESS
colnames(correspondance_table)[1]=sampleID_column

curated_data=curated_data[,colnames(curated_data)%in%colnames(correspondance_table)]
colnames(curated_data)=correspondance_table[1,colnames(curated_data)]

curated_data$SampleID_num=as.numeric(factor(curated_data$SampleID))

save(curated_data,file='0_curated_data.Rdata')
