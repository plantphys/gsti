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
path=here()
setwd(path)

##### Importing the dataset descriptions

ls_files=dir(recursive = TRUE)
ls_files_Description=ls_files[which(grepl(x=ls_files,pattern="Description.csv",ignore.case = TRUE))]
All_Description=do.call("rbind", apply(X = as.matrix(ls_files_Description),FUN = read.csv,MARGIN = 1))


world <- ne_countries(scale = "medium", returnclass = "sf")
Map_datasets=ggplot(data = world) + geom_sf() + xlab("Longitude") + ylab("Latitude") +geom_point(data= All_Description,aes(x=Long, y=Lat),
                                                                                   color = "red")
jpeg(filename = 'Map_datasets.jpeg',width = 170,height = 170,units = 'mm',res=600)
Map_datasets
dev.off()

print(Map_datasets)

##### Importing curated datasets

ls_files=dir(recursive = TRUE)
ls_files_Curated=ls_files[which(grepl(x=ls_files,pattern="3_Spectra_traits.Rdata",ignore.case = TRUE))]
data_curated=data.frame()
for(files in ls_files_Curated){
  load(files)
  data_curated=rbind.data.frame(data_curated,spectra)
}

Resume=data.frame(table(data_curated$Species))
colnames(Resume)=c('Species','N_leaf')
png("Leaf_per_species.png", height=10*nrow(Resume), width=100,units = 'mm',res=600)
p<-tableGrob(Resume)
grid.arrange(p)
dev.off()

png("Hist_Vcmax25.png", height=100, width=100,units = 'mm',res=600)
hist(data_curated$Vcmax25,breaks = 20,xlab=expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1),ylab='Number of leaves',main='')
dev.off()