#########################################################################
###   This code is used to do a summary of the database, including    ###
###   a map of the sites included, and basic description statistics   ###
###   of the number of leaves, species, and biomes                    ###
#########################################################################


## Import libraries

#install.packages(c("cowplot", "googleway", "ggplot2", "ggrepel", 
#                   "ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata","rgeos"))

library(ggplot2)
library(gridExtra)
library(here)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
#library(rgeos)
library(spectratrait) ## Package available on github: devtools::install_github(repo = "TESTgroup-BNL/spectratrait", dependencies=TRUE)
library(cowplot)
## Define the working directory
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
                                color = "red", size = 4)+theme_bw()+theme(panel.border = element_rect(linewidth = 1.3,colour = "black"))

png(filename = file.path(out_path,'Map_datasets.png'),width = 240,height = 120,units = 'mm',res=300)
print(Map_datasets)
dev.off()

print(Map_datasets)


## Histogram of Vcmax25 in the combined dataset
jpeg(file.path(out_path,"Hist_Vcmax25.jpeg"), height=120, 
     width=100,units = 'mm',res=300)
hist(Database$Vcmax25,breaks = 20, 
     xlab=expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1), 
     ylab='Number of leaves',main='')
box(lwd=2.2)
dev.off()

## Reflectance spectra of the combined dataset (Full range spectra only)
Reflectance=I(as.matrix(Database[,43:2193]))
# list of spectra that are not in the full range
ls_not_full=which(is.na(Reflectance),arr.ind = TRUE)[,1]
ls_not_full=ls_not_full[-which(duplicated(ls_not_full))]
Reflectance_full=Reflectance[-ls_not_full,]
jpeg(file.path(out_path,"Reflectance.jpeg"), height=120, width=130, 
     units = 'mm',res=300)
f.plot.spec(Z = Reflectance_full,wv = 350:2500,)
dev.off()

## Number of methods to estimate Vcmax25
table(Database$Fitting_method)/sum(table(Database$Fitting_method))


## Computing the number of leaves per species
Resume=data.frame(table(Database$Species))
colnames(Resume)=c('Species','N_leaf')
Resume$Species=as.character(Resume$Species)
Resume=rbind.data.frame(Resume,c('Total leaves',sum(as.numeric(Resume$N_leaf))))
jpeg(file.path(out_path,"Leaf_per_species.jpeg"), height=8*nrow(Resume), 
     width=100,units = 'mm',res=300)
p<-tableGrob(Resume)
grid.arrange(p)
dev.off()

## Computing the number of leaves per biome and the number of species per biome

Biomes=read.csv(file='Vignettes/Biomes.csv')
Database=merge(Database,Biomes)
n_Leaf_Biome=tapply(X=Database$Species,INDEX = Database$Biome,FUN = length)

a=ggplot(data.frame(value=n_Leaf_Biome,Biome=names(n_Leaf_Biome)), aes(x = "", y = value, fill = Biome)) +
  geom_col(color="white",size=1.5,alpha=0.8)+ labs(title="N observations per Biome")+
  geom_text(aes(x=1.25,label = value),
            position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y")  + theme_void() + theme(plot.title = element_text(hjust = 0.5))
print(a)

n_Species_Biome=tapply(X=Database$Species,INDEX = Database$Biome,FUN = function(x){length(unique(x))})

b=ggplot(data.frame(value=n_Species_Biome,Biome=names(n_Species_Biome)), aes(x = "", y = value, fill =Biome)) +
  geom_col(color="white",size=1.5,alpha=0.8) + labs(title="N species per Biome") +
  geom_text(aes(x=1.25,label = value),
            position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y")  + theme_void()+ theme(plot.title = element_text(hjust = 0.5))
print(b)

jpeg(file.path(out_path,"Number_observations.jpeg"), height=140, width=160, 
     units = 'mm',res=300)
plot_grid(a+theme(legend.position = "none"),b+theme(legend.position = "none"),get_legend(a),ncol=2,rel_heights = c(0.65,0.35))+theme(plot.background = element_rect(color = "black",linewidth = 1.2))
dev.off()
