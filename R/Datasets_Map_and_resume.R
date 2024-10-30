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
library(spectratrait) 
library(cowplot)

## Define the working directory
path <- here()
out_path <- file.path(path,"Outputs")
setwd(path)
getwd()

source(file.path(path,'R/Photosynthesis_tools.R'))

# Importing the database
Database_p1=read.csv(file=file.path(path,"database/Database_p1.csv"))
Database_p2=read.csv(file=file.path(path,"database/Database_p2.csv"))
Database_p3=read.csv(file=file.path(path,"database/Database_p3.csv"))
Database=rbind.data.frame(Database_p1,Database_p2,Database_p3)

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

Reflectance=I(as.matrix(Database[,44:2194]))
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

nrow(Database[!is.na(Database$Rdark),])
nrow(Database[!is.na(Database$Fitting_method),])
nrow(Database[!is.na(Database$Fitting_method)&!is.na(Database$Rdark),])
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

Species=Database[,c("Species","Plant_type")]
Species=Species[-which(duplicated(paste(Species$Species,Species$Plant_type))),]
Species[which(duplicated(Species$Species)),]
length(unique(Species$Species))
table(Species$Plant_type)
nrow(Database[Database$Plant_type=="Agricultural",])

Database$Rdark25=f.modified.arrhenius.inv(P = Database$Rdark,Tleaf = Database$Tleaf_Rdark+273.15,Ha = 46390,Hd=150650,s = 490)
quantile(Database$Rdark25,probs=c(0.025,0.975),na.rm=TRUE)
mean(Database$Rdark25,na.rm=TRUE)
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
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ geom_smooth(method="lm")
print(a)       

reg = lm(Vcmax25~Narea,data=Database)
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
b=ggplot(data=Database,aes(x=Narea,y=Vcmax25))+geom_point(size = pt_size)+ylim(c(0,300))+theme_bw()+
  ylab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+xlab(expression(N[area]~g~m^-2))+
  annotate(x=0.5,y=300,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0.5,y=0.9*300,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ geom_smooth(method="lm")

print(b)
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
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ geom_smooth(method="lm")

print(c)

reg = lm(Jmax25~Vcmax25,data=Database)
summary(reg)
summary(lm(Jmax25~0+Vcmax25,data=Database))
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
d=ggplot(data=Database,aes(x=Vcmax25,y=Jmax25))+geom_point(size = pt_size)+xlim(c(0,300))+ylim(c(0,600))+theme_bw()+
  ylab(expression(italic(J)[max25]~mu*mol~m^-2~s^-1))+xlab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+
  annotate(x=0,y=600,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*600,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ geom_smooth(method="lm")

print(d)

reg = lm(Vcmax25~Rdark25,data=Database)
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
e=ggplot(data=Database,aes(x=Rdark25,y=Vcmax25))+geom_point(size = pt_size)+ylim(c(0,150))+theme_bw()+
  ylab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+xlab(expression(italic(R)[dark25]~mu*mol~m^-2~s^-1))+
  annotate(x=0,y=150,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*150,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ geom_smooth(method="lm")

print(e)


jpeg("Outputs/Correlation_Vcmax25_traits.jpeg", height=270, width=180, units = 'mm',res=300)
plot_grid(a,b,c,d,e,ncol=2,labels = c('(a)','(b)','(c)','(d)','(e)'),hjust = -0.1,align = 'hv')
dev.off()
