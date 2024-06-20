#--------------------------------------------------------------------------------------------------#
list.of.packages <- c("pls","here","dplyr","plotrix","ggplot2","gridExtra","spectratrait")
invisible(lapply(list.of.packages, library, character.only = TRUE))

path <- here()
setwd(file.path(path,'/Datasets/Serbin_et_al_2019_hyspiri'))
getwd()
load('3_QC_Reflectance_data.Rdata',verbose=TRUE)
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# Script options
pls::pls.options(plsralg = "oscorespls")
pls::pls.options("plsralg")

# Default par options
opar <- par(no.readonly = T)

# What is the target variable?
inVar <- "Vcmax25" #"Jmax25"
#inVar <- "Fitted_Vcmax"

# Specify output directory, output_dir 
# Options: 
# tempdir - use a OS-specified temporary directory 
# user defined PATH - e.g. "~/scratch/PLSR"
output_dir <- "tempdir"
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
### Set working directory
if (output_dir=="tempdir") {
  outdir <- tempdir()
} else {
  if (! file.exists(output_dir)) dir.create(output_dir,recursive=TRUE)
  outdir <- file.path(path.expand(output_dir))
}
setwd(outdir) # set working directory
getwd()  # check wd
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
Start.wave <- 500
End.wave <- 2400
wv <- seq(Start.wave,End.wave,1)

names(Reflectance)[1:25]
sample_info <- Reflectance %>%
  select("SampleID_num", "SampleID", "Fitted_Vcmax","Fitted_Jmax","Fitted_Rd",
         "Vcmax25","Jmax25")
head(sample_info)

spec_data <- Reflectance %>%
  select(contains("Wave_"))
head(spec_data)
spec_data <- as.matrix(spec_data[,names(spec_data) %in% paste0("Wave_",wv)])


plsr_data <- data.frame(sample_info,Spectra=I(spec_data))
head(plsr_data)[1:3]
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
#### Example data cleaning.  End user needs to do what's appropriate for their 
#### data.  This may be an iterative process.
# Keep only complete rows of inVar and spec data before fitting
plsr_data <- plsr_data[complete.cases(plsr_data[,names(plsr_data) %in% 
                                                  c(inVar,paste0("Wave_",wv))]),]
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
#### Prepare data for fitting
# spec <- as.matrix(plsr_data[, which(names(plsr_data) %in% paste0("Wave_",wv))])
# plsr_data <- data.frame(plsr_data[, which(names(plsr_data) %notin% paste0("Wave_",wv))],
#                         Spectra=I(spec))
# head(plsr_data)[1:5]
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
### plot spectra
par(mfrow=c(1,1)) # B, L, T, R
spectratrait::f.plot.spec(Z=plsr_data$Spectra,wv=seq(Start.wave,End.wave,1),
                          plot_label="NASA HyspIRI Data")
dev.copy(png,file.path(outdir,paste0(inVar,'_Cal_Val_Spectra.png')), 
         height=2500,width=4900, res=340)
dev.off();
par(mfrow=c(1,1))
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
### Use permutation to determine the optimal number of components
if(grepl("Windows", sessionInfo()$running)){
  pls.options(parallel = NULL)
} else {
  pls.options(parallel = parallel::detectCores()-1)
}

method <- "pls" #pls, firstPlateau, firstMin
random_seed <- 2567814
seg <- 50
maxComps <- 20
iterations <- 60
prop <- 0.70
if (method=="pls") {
  nComps <- spectratrait::find_optimal_components(dataset=plsr_data, targetVariable=inVar, 
                                                  method=method, maxComps=maxComps, seg=seg, 
                                                  random_seed=random_seed)
  print(paste0("*** Optimal number of components: ", nComps))
} else {
  nComps <- spectratrait::find_optimal_components(dataset=plsr_data, targetVariable=inVar, 
                                                  method=method, maxComps=maxComps, iterations=iterations, 
                                                  seg=seg, prop=prop, random_seed=random_seed)
}
dev.copy(png,file.path(outdir,paste0(paste0(inVar,"_PLSR_Component_Selection.png"))), 
         height=2800, width=3400,  res=340)
dev.off();
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
### Fit final model
#nComps <- 10

segs <- 50
plsr.out <- plsr(as.formula(paste(inVar,"~","Spectra")),scale=FALSE,ncomp=nComps,validation="CV",
                 segments=segs, segment.type="interleaved",trace=FALSE,data=plsr_data)
fit <- plsr.out$fitted.values[,1,nComps]
pls.options(parallel = NULL)

# External validation fit stats
par(mfrow=c(1,2)) # B, L, T, R
pls::RMSEP(plsr.out)
plot(pls::RMSEP(plsr.out), main="MODEL RMSEP",
     xlab="Number of Components",ylab="Model RMSEP",lty=1,col="black",cex=1.5,lwd=2)
box(lwd=2.2)

pls::R2(plsr.out)
plot(pls::R2(plsr.out), main="MODEL R2",
     xlab="Number of Components",ylab="Model R2",lty=1,col="black",cex=1.5,lwd=2)
box(lwd=2.2)
dev.copy(png,file.path(outdir,paste0(paste0(inVar,"_RMSEP_R2_by_Component.png"))), 
         height=2800, width=4800,  res=340)
dev.off();
par(opar)
#--------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------#
### PLSR fit observed vs. predicted plot data
plsr_data.output <- data.frame(plsr_data[, which(names(plsr_data) %notin% "Spectra")], 
                               PLSR_Predicted=fit,
                               PLSR_CV_Predicted=as.vector(plsr.out$validation$pred[,,nComps]))
plsr_data.output <- plsr_data.output %>%
  mutate(PLSR_CV_Residuals = PLSR_CV_Predicted-get(inVar))
head(plsr_data.output)
cal.R2 <- round(pls::R2(plsr.out,intercept=F)[[1]][nComps],2)
cal.RMSEP <- round(sqrt(mean(plsr_data.output$PLSR_CV_Residuals^2)),2)

rng_quant <- quantile(plsr_data.output[,inVar], probs = c(0.001, 0.999))
cal_scatter_plot <- ggplot(plsr_data.output, aes(x=PLSR_CV_Predicted, y=get(inVar))) + 
  theme_bw() + geom_point() + geom_abline(intercept = 0, slope = 1, color="dark grey", 
                                          linetype="dashed", size=1.5) + xlim(rng_quant[1], rng_quant[2]) + 
  ylim(rng_quant[1], rng_quant[2]) +
  labs(x=paste0("Predicted ", paste(inVar), " (units)"),
       y=paste0("Observed ", paste(inVar), " (units)"),
       title=paste0("Calibration: ", paste0("Rsq = ", cal.R2), "; ", paste0("RMSEP = ", cal.RMSEP))) +
  theme(axis.text=element_text(size=18), legend.position="none",
        axis.title=element_text(size=20, face="bold"), 
        axis.text.x = element_text(angle = 0,vjust = 0.5),
        panel.border = element_rect(linetype = "solid", fill = NA, size=1.5))

cal_resid_histogram <- ggplot(plsr_data.output, aes(x=PLSR_CV_Residuals)) +
  geom_histogram(alpha=.5, position="identity") + 
  geom_vline(xintercept = 0, color="black", 
             linetype="dashed", size=1) + theme_bw() + 
  theme(axis.text=element_text(size=18), legend.position="none",
        axis.title=element_text(size=20, face="bold"), 
        axis.text.x = element_text(angle = 0,vjust = 0.5),
        panel.border = element_rect(linetype = "solid", fill = NA, size=1.5))

# plot cal/val side-by-side
scatterplots <- grid.arrange(cal_scatter_plot, cal_resid_histogram, nrow=2, ncol=1)
ggsave(paste0(inVar,"_Obs_vs_Pred_scatterplot.png"), plot = scatterplots, device="png", 
       width = 32, 
       height = 30, units = "cm",
       dpi = 300)
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
## Remove outliers
head(plsr_data.output)
hist(plsr_data.output$PLSR_CV_Residuals)
remove <- which(as.vector(plsr_data.output$PLSR_CV_Residuals) > 35 | 
                  as.vector(plsr_data.output$PLSR_CV_Residuals) < -35)
remove


plsr_data <- plsr_data[-remove,]
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
### Use permutation to determine the optimal number of components
if(grepl("Windows", sessionInfo()$running)){
  pls.options(parallel = NULL)
} else {
  pls.options(parallel = parallel::detectCores()-1)
}

method <- "pls" #pls, firstPlateau, firstMin
random_seed <- 2567814
seg <- 50
maxComps <- 20
iterations <- 60
prop <- 0.70
if (method=="pls") {
  nComps <- spectratrait::find_optimal_components(dataset=plsr_data, targetVariable=inVar, 
                                                  method=method, maxComps=maxComps, seg=seg, 
                                                  random_seed=random_seed)
  print(paste0("*** Optimal number of components: ", nComps))
} else {
  nComps <- spectratrait::find_optimal_components(dataset=plsr_data, targetVariable=inVar, 
                                                  method=method, maxComps=maxComps, iterations=iterations, 
                                                  seg=seg, prop=prop, random_seed=random_seed)
}
dev.copy(png,file.path(outdir,paste0(paste0(inVar,"_PLSR_Component_Selection.png"))), 
         height=2800, width=3400,  res=340)
dev.off();
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
### Fit final model
#nComps <- 10

segs <- 50
plsr.out <- plsr(as.formula(paste(inVar,"~","Spectra")),scale=FALSE,ncomp=nComps,validation="CV",
                 segments=segs, segment.type="interleaved",trace=FALSE,data=plsr_data)
fit <- plsr.out$fitted.values[,1,nComps]
pls.options(parallel = NULL)

# External validation fit stats
par(mfrow=c(1,2)) # B, L, T, R
pls::RMSEP(plsr.out)
plot(pls::RMSEP(plsr.out), main="MODEL RMSEP",
     xlab="Number of Components",ylab="Model RMSEP",lty=1,col="black",cex=1.5,lwd=2)
box(lwd=2.2)

pls::R2(plsr.out)
plot(pls::R2(plsr.out), main="MODEL R2",
     xlab="Number of Components",ylab="Model R2",lty=1,col="black",cex=1.5,lwd=2)
box(lwd=2.2)
dev.copy(png,file.path(outdir,paste0(paste0(inVar,"_RMSEP_R2_by_Component.png"))), 
         height=2800, width=4800,  res=340)
dev.off();
par(opar)
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
### PLSR fit observed vs. predicted plot data
plsr_data.output <- data.frame(plsr_data[, which(names(plsr_data) %notin% "Spectra")], 
                               PLSR_Predicted=fit,
                               PLSR_CV_Predicted=as.vector(plsr.out$validation$pred[,,nComps]))
plsr_data.output <- plsr_data.output %>%
  mutate(PLSR_CV_Residuals = PLSR_CV_Predicted-get(inVar))
head(plsr_data.output)
cal.R2 <- round(pls::R2(plsr.out,intercept=F)[[1]][nComps],2)
cal.RMSEP <- round(sqrt(mean(plsr_data.output$PLSR_CV_Residuals^2)),2)

rng_quant <- quantile(plsr_data.output[,inVar], probs = c(0.001, 0.999))
cal_scatter_plot <- ggplot(plsr_data.output, aes(x=PLSR_CV_Predicted, y=get(inVar))) + 
  theme_bw() + geom_point() + geom_abline(intercept = 0, slope = 1, color="dark grey", 
                                          linetype="dashed", size=1.5) + xlim(rng_quant[1], rng_quant[2]) + 
  ylim(rng_quant[1], rng_quant[2]) +
  labs(x=paste0("Predicted ", paste(inVar), " (units)"),
       y=paste0("Observed ", paste(inVar), " (units)"),
       title=paste0("Calibration: ", paste0("Rsq = ", cal.R2), "; ", paste0("RMSEP = ", cal.RMSEP))) +
  theme(axis.text=element_text(size=18), legend.position="none",
        axis.title=element_text(size=20, face="bold"), 
        axis.text.x = element_text(angle = 0,vjust = 0.5),
        panel.border = element_rect(linetype = "solid", fill = NA, size=1.5))

cal_resid_histogram <- ggplot(plsr_data.output, aes(x=PLSR_CV_Residuals)) +
  geom_histogram(alpha=.5, position="identity") + 
  geom_vline(xintercept = 0, color="black", 
             linetype="dashed", size=1) + theme_bw() + 
  theme(axis.text=element_text(size=18), legend.position="none",
        axis.title=element_text(size=20, face="bold"), 
        axis.text.x = element_text(angle = 0,vjust = 0.5),
        panel.border = element_rect(linetype = "solid", fill = NA, size=1.5))

# plot cal/val side-by-side
scatterplots <- grid.arrange(cal_scatter_plot, cal_resid_histogram, nrow=2, ncol=1)
ggsave(paste0(inVar,"_Obs_vs_Pred_scatterplot.png"), plot = scatterplots, device="png", 
       width = 32, 
       height = 30, units = "cm",
       dpi = 300)
#--------------------------------------------------------------------------------------------------#

