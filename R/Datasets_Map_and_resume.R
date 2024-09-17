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

###################################
###   Map of the dataset sites  ###
###################################

# Identifying unique sites
All_sites=Database[-which(duplicated(paste(Database$Site_name,Database$Longitude))),c("Site_name","Longitude","Latitude")]

world <- ne_countries(scale = "medium", returnclass = "sf")
Map_datasets <- ggplot(data = world) + geom_sf() + xlab("Longitude") + 
  ylab("Latitude") + geom_point(data= All_sites, aes(x=Longitude, 
                                                     y=Latitude), 
                                color = "red", size = 3)+theme_bw()+theme(panel.border = element_rect(linewidth = 1.3,colour = "black"))

png(filename = file.path(out_path,'Map_datasets.png'),width = 240,height = 120,units = 'mm',res=300)
print(Map_datasets)
dev.off()

print(Map_datasets)


#####################################
###   Overview of the database    ###
#####################################

### Histogram of Vcmax25

jpeg(file.path(out_path,"Hist_Vcmax25.jpeg"), height=120,width=100,units = 'mm',res=300)
  hist(Database$Vcmax25,breaks = 20, 
     xlab=expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1), 
     ylab='Number of leaves',main='')
  box(lwd=2.2)
dev.off()

### Reflectance spectra of the combined dataset (Full range spectra only)

Reflectance=I(as.matrix(Database[,43:2193]))
# list of spectra that are not in the full range
ls_not_full=which(is.na(Reflectance),arr.ind = TRUE)[,1]
ls_not_full=ls_not_full[-which(duplicated(ls_not_full))]
Reflectance_full=Reflectance[-ls_not_full,]

jpeg(file.path(out_path,"Reflectance.jpeg"), height=120, width=130, 
     units = 'mm',res=300)
f.plot.spec(Z = Reflectance_full,wv = 350:2500,)
dev.off()

### Repartition of the method used to estimate Vcmax25

table(Database$Fitting_method)/sum(table(Database$Fitting_method))


### Number of observations per species and biome

Resume=data.frame(table(Database$Species))
colnames(Resume)=c('Species','N_leaf')
Resume$Species=as.character(Resume$Species)
Resume=rbind.data.frame(Resume,c('Total leaves',sum(as.numeric(Resume$N_leaf))))
jpeg(file.path(out_path,"Leaf_per_species.jpeg"), height=8*nrow(Resume), 
     width=100,units = 'mm',res=300)
p<-tableGrob(Resume)
grid.arrange(p)
dev.off()

Biomes=read.csv(file='Documentation/Biomes.csv')
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


#######################################################
###   Correlation between Vcmax 25 and leaf traits  ###
#######################################################
pt_size=0.7
reg = lm(Vcmax25~LMA,data=Database)
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
a=ggplot(data=Database,aes(x=LMA,y=Vcmax25))+geom_point(size = pt_size)+ylim(c(0,300))+theme_bw()+
  ylab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+xlab(expression(LMA~g~m^-2))+
  annotate(x=0.5,y=300,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0.5,y=0.9*300,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
       

reg = lm(Vcmax25~Narea,data=Database)
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
b=ggplot(data=Database,aes(x=Narea,y=Vcmax25))+geom_point(size = pt_size)+ylim(c(0,300))+theme_bw()+
  ylab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+xlab(expression(N[area]~g~m^-2))+
  annotate(x=0.5,y=300,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0.5,y=0.9*300,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

##Gitelson index = (R_750−800)/(R_695−740) − 1
R_750_800=rowMeans(Database[,colnames(Database)%in%paste("Wave_.",750:800,sep="")])
R_695_740=rowMeans(Database[,colnames(Database)%in%paste("Wave_.",695:740,sep="")])
Database$Chl_Gitelson=R_750_800/R_695_740-1

reg = lm(Vcmax25~Chl_Gitelson,data=Database)
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
c=ggplot(data=Database,aes(x=Chl_Gitelson,y=Vcmax25))+geom_point(size = pt_size)+ylim(c(0,300))+theme_bw()+
  ylab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+xlab(expression(Chl~index~value))+
  annotate(x=0,y=300,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*300,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

reg = lm(Jmax25~Vcmax25,data=Database)
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
d=ggplot(data=Database,aes(x=Vcmax25,y=Jmax25))+geom_point(size = pt_size)+xlim(c(0,300))+ylim(c(0,600))+theme_bw()+
  ylab(expression(italic(J)[max25]~mu*mol~m^-2~s^-1))+xlab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+
  annotate(x=0,y=600,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*600,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
jpeg("Outputs/Correlation_Vcmax25_traits.jpeg", height=180, width=180, units = 'mm',res=300)
plot_grid(a,b,c,d,ncol=2,labels = c('(a)','(b)','(c)','(d)'),hjust = -0.1,align = 'hv')
dev.off()