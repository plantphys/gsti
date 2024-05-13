#install.packages(c("cowplot", "googleway", "ggplot2", "ggrepel", 
#                   "ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata","rgeos"))

library(ggplot2)
library(gridExtra)
library(here)
theme_set(theme_bw())
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
#library(rgeos)
library(spectratrait) ## Package available on github: devtools::install_github(repo = "TESTgroup-BNL/spectratrait", dependencies=TRUE)
path <- here()
out_path <- file.path(path,"Outputs")
setwd(path)
getwd()

# Importing the database
Database=read.csv(file=file.path(path,"database/Database.csv"))

# Identifying unique sites
All_sites=Database[-which(duplicated(paste(Database$Site_name,Database$Longitude))),c("Site_name","Longitude","Latitude")]

### Creating a map of all datasets
world <- ne_countries(scale = "medium", returnclass = "sf")
Map_datasets <- ggplot(data = world) + geom_sf() + xlab("Longitude") + 
  ylab("Latitude") + geom_point(data= All_sites, aes(x=Longitude, 
                                                     y=Latitude), 
                                color = "red", size = 4)
#jpeg(filename = 'Map_datasets.jpeg',width = 170,height = 170,units = 'mm',res=150)

## !! TO DO - Update this to add X/Y labels etc, make prettier
png(filename = file.path(out_path,'Map_datasets.png'),width = 250,height = 150,units = 'mm',res=150)
print(Map_datasets)
dev.off()

print(Map_datasets)


### Computing the number of leaves per species
Resume=data.frame(table(Database$Species))
colnames(Resume)=c('Species','N_leaf')
Resume$Species=as.character(Resume$Species)
Resume=rbind.data.frame(Resume,c('Total leaves',sum(as.numeric(Resume$N_leaf))))
jpeg(file.path(out_path,"Leaf_per_species.jpeg"), height=8*nrow(Resume), 
     width=100,units = 'mm',res=300)
p<-tableGrob(Resume)
grid.arrange(p)
dev.off()

## Histogram of Vcmax25 in the combined dataset
jpeg(file.path(out_path,"Hist_Vcmax25.jpeg"), height=100, 
     width=100,units = 'mm',res=300)
hist(Database$Vcmax25,breaks = 20, 
     xlab=expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1), 
     ylab='Number of leaves',main='')
dev.off()

## Reflectance spectra of the combined dataset (Full range spectra only)
Reflectance=I(as.matrix(Database[,41:2191]))
# list of spectra that are not in the full range
ls_not_full=which(is.na(Reflectance),arr.ind = TRUE)[,1]
ls_not_full=ls_not_full[-which(duplicated(ls_not_full))]
Reflectance_full=Reflectance[-ls_not_full,]
jpeg(file.path(out_path,"Reflectance.jpeg"), height=120, width=150, 
     units = 'mm',res=300)
f.plot.spec(Z = Reflectance_full,wv = 350:2500,)
dev.off()

