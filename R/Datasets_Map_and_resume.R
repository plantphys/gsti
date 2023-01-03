#install.packages(c("cowplot", "googleway", "ggplot2", "ggrepel", 
#                   "ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata","rgeos"))

library(ggplot2)
library(gridExtra)
library(here)
theme_set(theme_bw())
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(spectratrait)
path <- here()
setwd(path)

### Importing the dataset descriptions

ls_files <- dir(recursive = TRUE)
ls_files_Description <- ls_files[which(grepl(x=ls_files,pattern="Description.csv",ignore.case = TRUE))]
ls_files_Description <- ls_files_Description[which(grepl(x=ls_files_Description,pattern="Datasets",ignore.case = TRUE))]
ls_files_Description <- ls_files_Description[-which(grepl(x=ls_files_Description,pattern="TEMPLATE",ignore.case = TRUE))]
All_Description <- do.call("rbind", apply(X = as.matrix(ls_files_Description),FUN = read.csv,MARGIN = 1))

### Creating a map of all datasets
world <- ne_countries(scale = "medium", returnclass = "sf")
Map_datasets <- ggplot(data = world) + geom_sf() + xlab("Longitude") + 
  ylab("Latitude") +geom_point(data= All_Description,aes(x=Long, y=Lat),color = "red")
#jpeg(filename = 'Map_datasets.jpeg',width = 170,height = 170,units = 'mm',res=150)

## !! TO DO - Update this to add X/Y labels etc, make prettier
png(filename = 'Map_datasets.png',width = 250,height = 150,units = 'mm',res=150)
Map_datasets
dev.off()

print(Map_datasets)

### Importing curated datasets - TODO: replace = with <-

ls_files=dir(recursive = TRUE)
ls_files_Curated=ls_files[which(grepl(x=ls_files,pattern="3_Spectra_traits.Rdata",ignore.case = TRUE))]
data_curated=data.frame()
for(files in ls_files_Curated){
  print(files)
  load(files,verbose=TRUE)
  data_curated=rbind.data.frame(data_curated,spectra)
}

### Computing the number of leaves per species
Resume=data.frame(table(data_curated$Species))
colnames(Resume)=c('Species','N_leaf')
Resume$Species=as.character(Resume$Species)
Resume=rbind.data.frame(Resume,c('Total leaves',sum(as.numeric(Resume$N_leaf))))
jpeg("Leaf_per_species.jpeg", height=8*nrow(Resume), width=100,units = 'mm',res=300)
p<-tableGrob(Resume)
grid.arrange(p)
dev.off()

## Histogram of Vcmax25 in the combined dataset
jpeg("Hist_Vcmax25.jpeg", height=100, width=100,units = 'mm',res=300)
hist(data_curated$Vcmax25,breaks = 20,xlab=expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1),ylab='Number of leaves',main='')
dev.off()

## Reflectance spectra of the combined dataset
jpeg("Reflectance.jpeg", height=100, width=100,units = 'mm',res=300)
f.plot.spec(Z = data_curated$Spectra,wv = 350:2500)
dev.off()

