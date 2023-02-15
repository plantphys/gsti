library(here)
path <- here()
setwd(file.path(path,'/Datasets/Serbin_et_al_2019_hyspiri'))

load('0_curated_data.Rdata',verbose=TRUE)
curated_data$QC <- 'ok'
curated_data$QC[curated_data$QCauthors==1] <- 'bad'

hist(curated_data$Ci) 
min(curated_data$Ci)
hist(curated_data$gsw) 
min(curated_data$gsw)

# remove Ci and gsw < 0
curated_data[curated_data$Ci<0, 'QC'] <- 'bad'
min(curated_data$Ci[which(curated_data$QC!='bad')])
curated_data[curated_data$gsw<0, 'QC'] <- 'bad'
min(curated_data$gsw[which(curated_data$QC!='bad')])
head(curated_data)

## What species and sites are included in the curated data?
# Create a sites table
# annoyingly the Shafter data names are not in the same order so need special handling
sites <- NULL
sites <- substr(curated_data$Sample_ID_Name, 1, regexpr("_", curated_data$Sample_ID_Name)-1)
unique(sites)
shaft_index <- which(sites == "Shafter")

# species
species <- NULL
species <- gsub("^(?:[^_]+_){2}([^_]+).*", "\\1", curated_data$Sample_ID_Name)
species[shaft_index]
species[shaft_index] = gsub("^(?:[^_]+_){1}([^_]+).*", "\\1", curated_data$Sample_ID_Name[shaft_index])
unique(species)

##Shawn, this is Julien, do you copy?
# The QC table is just a table that lists bad points from curves. 
# I do the QC manually based on the pdf file produced below
# I build the QC table very manually as you see, but this is my prefered method because I dont like opening a csv file and then importing it.
# But we could do it like that if you prefer..
# The list ls_bad_curve is exactly the same as yours below except that I use the SampleId_num which allowes me to write a number
# instead of a complicated file name or SampleId name..

# !!! I copy Julien!  Thanks for the details !!!
#bad_curve_list <- c("KARE_Plot1_PIME4_L2_GE_1_2015-06-08", 
#                    "KARE_Plot1_PIME4_L26_GE_1_2015-06-08")



### List of author curated "bad" curves and data points (based on original QCauthor column)
bad_curve_list <- c("KARE_Plot1_PIME4_L2_GE_1_2015-06-08", "KARE_Plot1_PIME4_L26_GE_1_2015-06-08",
                    "KARE_Plot1_PIME4_L27_GE_1_2015-06-08", "KARE_Plot1_PUGR2_L10_GE_1_2015-06-07",
                    "KARE_Plot1_PUGR2_L11_GE_1_2015-06-07", "KARE_Plot1_PUGR2_L12_GE_1_2015-06-07",
                    "KARE_Plot2_FICA_L11_GE_1_2015-06-06", "KARE_PLot2_FICA_L2_GE_2_2015-06-06",
                    "KARE_Plot2_FICA_L7_GE_1_2015-06-06", "KARE_Plot2_PIME4_L10_GE_1_2015-06-08",
                    "KARE_Plot2_PIME4_L20_GE_1_2015-06-08","KARE_Plot2_PIME4_L23_GE_1_2015-06-08",
                    "KARE_Plot2_PIME4_L24_GE_1_2015-06-08","KARE_Plot2_PUGR2_L2_GE_1_2015-06-07",
                    "KARE_Plot3_FICA_L13_GE_1_2015-06-06","KARE_Plot3_FICA_L4_GE_1_2015-06-06",
                    "KARE_Plot3_FICA_L5_GE_1_2015-06-06","KARE_Plot3_PUGR2_L15_GE_1_2015-06-07",
                    "KARE_Plot3_PUGR2_L5_GE_1_2015-06-07","KARE_Plot4_FICA_L3_GE_1_2015-06-06",
                    "KARE_Plot4_FICA_L6_GE_1_2015-06-06","KARE_Plot4_PUGR2_L14_GE_1_2015-06-07",
                    "KARE_Plot4_PUGR2_L3_GE_1_2015-06-07","KARE_Plot4_PUGR2_L8_GE_1_2015-06-07",
                    "Shafter_SOTU_Plot1_L10T_GE_1_2015-06-10","Shafter_SOTU_Plot1_L11T_GE_1_2015-06-10",
                    "Shafter_SOTU_Plot2_L12T_GE_1_2015-06-10","Shafter_SOTU_Plot2_L24T_GE_1_2015-06-10",
                    "Shafter_SOTU_Plot2_L4T_GE_1_2015-06-10","Shafter_SOTU_Plot4_L13T_GE_1_2015-06-10",
                    "Shafter_SOTU_Plot4_L14T_GE_1_2015-06-10","Shafter_SOTU_Plot4_L16T_GE_1_2015-06-10",
                    "CVARS_Plot1_PHDA4_L1T_GE_1_2014-06-05","CVARS_Plot1_PHDA4_L3T_GE_3_2014-06-07",
                    "DREC_Plot1_BEVU2_L12T_GE_1_2015-06-11","REC_Plot3_BEVU2_L10T_GE_1_2015-06-11",
                    "DREC_Plot3_BEVU2_L7T_GE_1_2015-06-11","KARE_Plot1_FICA_L10_GE_1_2015-06-06",
                    "KARE_Plot1_FICA_L2large_GE_1_2015-06-05","KARE_Plot1_FICA_L3large_GE_1_2015-06-05",
                    "DREC_Plot3_BEVU2_L10T_GE_1_2015-06-11","KARE_Plot1_PUGR2_L10_GE_1_2015−06−07",
                    "DREC_Plot1_BEVU2_L11T_GE_1_2015−06−11","DREC_Plot1_BEVU2_L12T_GE_1_2015−06−11",
                    "DREC_Plot1_BEVU2_L1T_GE_1_2015−06−11","DREC_Plot1_BEVU2_L8T_GE_1_2015−06−11",
                    "DREC_Plot1_BEVU2_L9T_GE_1_2015−06−11","DREC_Plot2_BEVU2_L2T_GE_1_2015−06−11",
                    "Shafter_SOTU_Plot3_L9T_GE_1_2015−06−10",
                    "Shafter_SOTU_Plot4_L15T_GE_1_2015−06−10",
                    "Shafter_SOTU_Plot4_L25T_GE_1_2015−06−10",
                    "Shafter_SOTU_Plot4_L8T_GE_1_2015−06−10")
# Display the SampleID_num of each bad curve. -- THIS IS NO LONGER WORKING CORRECTLY
#curated_data[curated_data$SampleID %in% bad_curve_list, 'SampleID_num']

sort(unique(curated_data[curated_data$SampleID %in% bad_curve_list, 'SampleID_num']))
ls_bad_curve <- sort(unique(curated_data[curated_data$SampleID %in% bad_curve_list,
                                         'SampleID_num']))
ls_bad_curve

## Build QC table
QC_table <- cbind.data.frame(SampleID_num=c(),Record=c())

curated_data[paste(curated_data$SampleID_num,curated_data$Record) %in% 
               paste(QC_table$SampleID_num,QC_table$Record),'QC']='bad'

head(curated_data)

## Remove additional curves with less than 3 pts
n_points_curves <- tapply(X=curated_data[curated_data$QC=="ok",'Record'],
                          INDEX = curated_data[curated_data$QC=="ok",
                                               'SampleID_num'],
                          FUN = function(x){length(x)})
#short_curves=n_points_curves[n_points_curves<5]
short_curves <- n_points_curves[n_points_curves < 3]
ls_bad_curve <- c(ls_bad_curve,names(short_curves))
ls_bad_curve # this is in string format

curated_data[curated_data$SampleID_num %in% as.numeric(ls_bad_curve),'QC']='bad'

## I DONT KNOW WHAT ALL OF THIS IS DOING - SEEMS OVERLY COMPLICATED
# That is Just a PDF file whith each Aci curve. The title of the Aci curve on the pdf file is the SampleID_num.
# Each point of the Aci curve as the Record number written on it. If the point is in red it means that this point
# is bad and that it is present in the QC_table table or in the ls_bad_curve vector. 

pdf(file='1_QA_QC_Aci.pdf',)
 for(SampleID_num in seq_along(unique(curated_data$SampleID_num))) {
   plot(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],
        y=curated_data[curated_data$SampleID_num==SampleID_num,'A'],
        main=unique(paste0("Name: ",curated_data[curated_data$SampleID_num==SampleID_num,
                                       'Sample_ID_Name']," Num: ",
                          curated_data[curated_data$SampleID_num==SampleID_num,
                                 'SampleID_num'])),cex=2,xlab='Ci',ylab='A')
 if(SampleID_num%in%c(QC_table$SampleID_num,ls_bad_curve)) {
   points(x=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','Ci'],
          y=curated_data[curated_data$SampleID_num==SampleID_num&curated_data$QC=='bad','A'],
          cex=2,col='red')
 }
 text(x=curated_data[curated_data$SampleID_num==SampleID_num,'Ci'],
      y=curated_data[curated_data$SampleID_num==SampleID_num,'A'], 
      labels=curated_data[curated_data$SampleID_num==SampleID_num,'Record'],cex=0.7)
   
 }
dev.off()
 

# Keep only "good" data for the rest of the workflow
curated_data <- curated_data[curated_data$QC=='ok',]

save(curated_data,file='1_QC_ACi_data.Rdata')
