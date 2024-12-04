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


#####################################
###   Overview of the database    ###
#####################################
### Number of datasets
unique(Database$Dataset_name)
length(unique(Database$Dataset_name))

### Number of sites 
unique(Database$Site_name)
length(unique(Database$Site_name))

### Histogram of Vcmax25

jpeg(file.path(out_path,"Hist_Vcmax25.jpeg"), height=120,width=100,units = 'mm',res=300)
  hist(Database$Vcmax25,breaks = 20, 
     xlab=expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1), 
     ylab='Number of leaves',main='')
  box(lwd=2.2)
dev.off()

### Reflectance spectra of the combined dataset (Full range spectra only)

Reflectance=I(as.matrix(Database[,47:2197]))
# list of spectra that are not in the full range
ls_not_full=which(is.na(Reflectance),arr.ind = TRUE)[,1]
ls_not_full=ls_not_full[-which(duplicated(ls_not_full))]
Reflectance_full=Reflectance[-ls_not_full,]

jpeg(file.path(out_path,"Reflectance.jpeg"), height=120, width=130, 
     units = 'mm',res=300)
spectra_quantiles = apply(Reflectance_full,2,quantile,na.rm=T,probs=c(0.025,0.5,0.975))
plot(x=NULL,y=NULL,ylim=c(0,100),xlim=c(350,2500),xlab="Wavelength (nm)",
     ylab="Reflectance (%)")
polygon(c(350:2500 ,2500:350),c(spectra_quantiles[3,], rev(spectra_quantiles[1,])),
        col="#99CC99",border=NA)
lines(350:2500,spectra_quantiles[2,],lwd=2, lty=1, col="black")
legend("topright",legend=c("Median", "95% interval"),lty=c(1,1),
       lwd=c(2,10),col=c("black","#99CC99"),bty="n")
box(lwd=2.2)
dev.off()

### Method used to estimate Vcmax25

table(Database$Fitting_method)/sum(table(Database$Fitting_method))
nrow(Database[Database$Dataset_name%in%c("Cui_et_al_2025","Maréchaux_et_al_2024"),])

nrow(Database[!is.na(Database$Rdark),])
nrow(Database[!is.na(Database$Fitting_method),])
nrow(Database[!is.na(Database$Fitting_method)&!is.na(Database$Rdark),])

quantile(Database$Vcmax25,probs=c(0.025,0.975),na.rm=TRUE)
mean(Database$Vcmax25,na.rm=TRUE)
### Number of datasets with VIS only reflectance
unique(Database[is.na(Database$Wave_.1500),"Dataset_name"])

### Number of observations per species and biome

Resume=data.frame(table(Database$Species))
colnames(Resume)=c('Species','N_leaf')
Resume$Species=as.character(Resume$Species)
Resume=rbind.data.frame(Resume,c('Total leaves',sum(as.numeric(Resume$N_leaf))))
jpeg(file.path(out_path,"Leaf_per_species.jpeg"), height=8*nrow(Resume), 
     width=150,units = 'mm',res=300)
p<-tableGrob(Resume)
grid.arrange(p)
dev.off()

Biomes=read.csv(file='Documentation/Biomes.csv')
Database=merge(Database,Biomes)
n_Leaf_Biome=tapply(X=Database$Species,INDEX = Database$Biome,FUN = length)
n_Species_Biome=tapply(X=Database$Species,INDEX = Database$Biome,FUN = function(x){length(unique(x))})
Biomes$n_obs=0
Biomes$n_species=0
Biomes[Biomes$Biome%in%names(n_Leaf_Biome),"n_obs"]=n_Leaf_Biome[Biomes[Biomes$Biome%in%names(n_Leaf_Biome),"Biome"]]
Biomes[Biomes$Biome%in%names(n_Species_Biome),"n_species"]=n_Species_Biome[Biomes[Biomes$Biome%in%names(n_Species_Biome),"Biome"]]


biome_colors <- c("Tundra"="#bbe3d4",
                  "Tropical & Subtropical Moist Broadleaf Forests"="#74c24d",
                  "Mediterranean Forests, Woodlands & Scrub"="#fe4d4d",
                  "Deserts & Xeric Shrublands"="#db9595",
                  "Temperate Grasslands, Savannas & Shrublands"="#feff9d",
                  "Boreal Forests/Taiga"="#a2ccf8",
                  "Temperate Conifer Forests"="#7dad9b",
                  "Temperate Broadleaf & Mixed Forests"="#4d9d82",
                  "Montane Grasslands & Shrublands"="#e2d5bb",
                  "Mangroves"="#fe4ed6",
                  "Flooded Grasslands & Savannas"="#d2eeff",
                  "Tropical & Subtropical Grasslands, Savannas & Shrublands"="#fec44e",
                  "Tropical & Subtropical Dry Broadleaf Forests"="#dbdc95",
                  "Tropical & Subtropical Coniferous Forests"="#acdd94")

a=ggplot(Biomes, aes(y = reorder(Biome,n_obs), x = n_obs, fill = Biome)) +
  geom_bar(stat = "identity") +
  labs(y = "Biome", x = "Number of observations") +
  theme_bw() + theme(legend.position="none",axis.text.y = element_text(color = "black")) +
                       scale_fill_manual(values=biome_colors)+ylab("")

b=ggplot(Biomes, aes(y = reorder(Biome,n_obs), x = n_species, fill = Biome)) +
  geom_bar(stat = "identity") +
  labs(y = "Biome", x = "Number of species") +
  theme_bw() + theme(legend.position="none",axis.text.y = element_blank(),axis.title.y = element_blank()) +
  scale_fill_manual(values=biome_colors)+ylab("")

jpeg(file.path(out_path,"Number_observations.jpeg"), height=120, width=180, 
     units = 'mm',res=300)
plot_grid(a,b,ncol=2,rel_widths = c(0.75,0.25))
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
pt_size=1
pt_alpha=0.2
reg = lm(Vcmax25~LMA,data=Database)
nrow(Database[!is.na(Database$LMA),])
quantile(Database$LMA,probs=c(0.025,0.975),na.rm=TRUE)
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
a=ggplot(data=Database,aes(x=LMA,y=Vcmax25))+geom_point(size = pt_size, alpha = pt_alpha)+ylim(c(0,300))+theme_bw()+
  ylab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+xlab(expression(LMA~g~m^-2))+
  annotate(x=0.5,y=300,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0.5,y=0.9*300,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ geom_smooth(method="lm")
print(a)       

reg = lm(Vcmax25~Narea,data=Database)
nrow(Database[!is.na(Database$Narea),])
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
b=ggplot(data=Database,aes(x=Narea,y=Vcmax25))+geom_point(size = pt_size, alpha = pt_alpha)+ylim(c(0,300))+theme_bw()+
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
c=ggplot(data=Database,aes(x=Chl_Gitelson,y=Vcmax25))+geom_point(size = pt_size, alpha = pt_alpha)+ylim(c(0,300))+theme_bw()+
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
d=ggplot(data=Database,aes(x=Vcmax25,y=Jmax25))+geom_point(size = pt_size, alpha = pt_alpha)+xlim(c(0,300))+ylim(c(0,600))+theme_bw()+
  ylab(expression(italic(J)[max25]~mu*mol~m^-2~s^-1))+xlab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+
  annotate(x=0,y=600,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*600,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ geom_smooth(method="lm")

print(d)

reg = lm(Vcmax25~Rdark25*Biome,data=Database)
summary(reg)
RMSE = sqrt(mean(residuals(reg)^2))
R2 = summary(reg)$adj.r.squared
e=ggplot(data=Database,aes(x=Rdark25,y=Vcmax25))+geom_point(size = pt_size, alpha = pt_alpha)+ylim(c(0,300))+xlim(c(0,4))+theme_bw()+
  ylab(expression(italic(V)[cmax25]~mu*mol~m^-2~s^-1))+xlab(expression(italic(R)[dark25]~mu*mol~m^-2~s^-1))+
  annotate(x=0,y=300,label=paste("R² =",round(R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*300,label=paste("RMSE =",round(RMSE,1)),"text",hjust=0,vjust=1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ geom_smooth(method="lm")

print(e)


jpeg("Outputs/Correlation_Vcmax25_traits.jpeg", height=270, width=180, units = 'mm',res=300)
plot_grid(a,b,c,d,e,ncol=2,labels = c('(a)','(b)','(c)','(d)','(e)'),hjust = -0.1,align = 'hv')
dev.off()



###################################
###   Map of the dataset sites  ###
###################################

library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

All_sites=Database[-which(duplicated(paste(Database$Site_name,Database$Longitude))),c("Site_name","Longitude","Latitude","Biome","Biome_number","Dataset_name","Soil")]
All_sites$Type="Managed"
All_sites[All_sites$Soil=="Natural","Type"]="Natural"
ecoregions = st_read(file.path(path,'Other/Ecoregions2017.shp')) ## This shapefile ca nbe dowloaded here: https://ecoregions.appspot.com/

ecoregions_plot=ggplot(data = ecoregions,aes(fill=BIOME_NAME,color=BIOME_NAME)) + geom_sf() + theme_bw() + 
  geom_point(data = All_sites, aes(x=Longitude,y=Latitude,shape=Type),color="black",fill="black", size =2.5) +
  theme(legend.position="bottom",panel.grid.major = element_blank(),panel.grid.minor = element_blank(),legend.title = element_blank(),legend.key.size = unit(0.5, "line"),legend.spacing.y = unit(0.1, "line"),legend.text = element_text(size = 12),legend.direction = "vertical") +
  scale_color_manual(values=biome_colors,guide = guide_legend(nrow = 7, ncol = 2)) +
  scale_fill_manual(values=biome_colors) +xlab("")+ylab("")+guides(shape = guide_legend(order = 1))

png(filename = file.path(path,'Outputs/Map_dataset.png'),width = 250,height = 150,units = 'mm',res=300)
print(ecoregions_plot)
dev.off()
