###############################################################################
### This funciton is build upon the spectratrait plsr package               ###
### (Serbin et al. 2021 and Burnett et al. 2021) to automatically perform   ###
### a plsr model                                                            ###
###############################################################################


#' Auto PLSR model
#'
#' @param inVar Name of the variable used for the PLSR
#' @param wv Wavelength of the spectra used for the PLSR
#' @param cal.plsr.data Calibration dataset for the PLSR (also called training dataset)
#' @param val.plsr.data Validation dataset for the PLSR
#' @param file_name Name for the pdf and Rdata files that are produced by the function (do not add the file extension, only use 'file1' for example)
#' @param method Method to determine the number of components (see spectratrait package). Choose betwen 'pls', 'firstPlateau', 'firstMin' or directly give the number of components (numeric)
#'
#' @return
#' @export
#'
#' @examples
f.auto_plsr<-function(inVar,wv=500:2400,cal.plsr.data,val.plsr.data,file_name,method='pls'){
  pls::pls.options(plsralg = "oscorespls")
  `%notin%` <- Negate(`%in%`)
  print(paste("Cal observations: ",dim(cal.plsr.data)[1],sep=""))
  print(paste("Val observations: ",dim(val.plsr.data)[1],sep=""))
  
  ## Range of the data for the plots
  minX=min(c(cal.plsr.data[,paste0(inVar)],val.plsr.data[,paste0(inVar)]),na.rm=TRUE) 
  maxX=max(c(cal.plsr.data[,paste0(inVar)],val.plsr.data[,paste0(inVar)]),na.rm=TRUE)
  
  if(!is.null(file_name)){pdf(file = paste(file_name,'.pdf',sep=''))}
   cal_hist_plot <- qplot(cal.plsr.data[,paste0(inVar)],geom="histogram",
                         main = paste0("Cal. Histogram for ",inVar),
                         xlab = paste0(inVar),ylab = "Count",fill=I("grey50"),
                         col=I("black"),alpha=I(.7),xlim=c(minX,maxX))
  val_hist_plot <- qplot(val.plsr.data[,paste0(inVar)],geom="histogram",
                         main = paste0("Val. Histogram for ",inVar),
                         xlab = paste0(inVar),ylab = "Count",fill=I("grey50"),
                         col=I("black"),alpha=I(.7),xlim=c(minX,maxX))
  histograms <- grid.arrange(cal_hist_plot, val_hist_plot, ncol=2)
  
  histograms
  
  spectratrait::f.plot.spec(Z=cal.plsr.data$Spectra,wv=wv,plot_label="Calibration")
  spectratrait::f.plot.spec(Z=val.plsr.data$Spectra,wv=wv,plot_label="Validation")
  
  
  if(grepl("Windows", sessionInfo()$running)){
    pls.options(parallel = NULL)
  } else {
    pls.options(parallel = parallel::detectCores()-1)
  }
  
  
  random_seed <- 2356812
  seg <- 100
  maxComps <- 30
  iterations <- 50
  prop <- 0.70
  if (method=="pls") {
    # pls package approach - faster but estimates more components....
    nComps <- spectratrait::find_optimal_components(dataset=cal.plsr.data,method=method, 
                                                    maxComps=maxComps, seg=seg, 
                                                    random_seed=random_seed)
    print(paste0("*** Optimal number of components: ", nComps))
  } else if (method%in% c('firstPlateau', 'firstMin')) {
    nComps <- spectratrait::find_optimal_components(dataset=cal.plsr.data, method=method, 
                                                    maxComps=maxComps, 
                                                    iterations=iterations, 
                                                    seg=seg, prop=prop, 
                                                    random_seed=random_seed)
  } else { if(is.numeric(method)){
                nComps=method
                print(paste('PLSR using a fixed number of components:', method))} else {
                  print(paste('Error,',method,'is not a known method. Chose Choose betwen pls, firstPlateau, firstMin or directly give the number of components (numeric)'))
                }
          }
  
  ## Fit the final model
  segs <- 100
  plsr.out <- plsr(as.formula(paste(inVar,"~","Spectra")),scale=FALSE,ncomp=nComps,validation="CV",
                   segments=segs, segment.type="interleaved",trace=FALSE,data=cal.plsr.data)
  fit <- plsr.out$fitted.values[,1,nComps]
  pls.options(parallel = NULL)
  
  # External validation fit stats
 # par(mfrow=c(1,2)) # B, L, T, R
 # pls::RMSEP(plsr.out, newdata = val.plsr.data)
 # plot(pls::RMSEP(plsr.out,estimate=c("test"),newdata = val.plsr.data), main="MODEL RMSEP",
 #      xlab="Number of Components",ylab="Model Validation RMSEP",lty=1,col="black",cex=1.5,lwd=2)
 # box(lwd=2.2)
 # 
 # pls::R2(plsr.out, newdata = val.plsr.data)
 # plot(R2(plsr.out,estimate=c("test"),newdata = val.plsr.data), main="MODEL R2",
 #      xlab="Number of Components",ylab="Model Validation R2",lty=1,col="black",cex=1.5,lwd=2)
 # box(lwd=2.2)
  
  #calibration
  cal.plsr.output <- data.frame(cal.plsr.data[, which(names(cal.plsr.data) %notin% "Spectra")],
                                PLSR_Predicted=fit,
                                PLSR_CV_Predicted=as.vector(plsr.out$validation$pred[,,nComps]))
  cal.plsr.output <- cal.plsr.output %>%
    mutate(PLSR_CV_Residuals = PLSR_CV_Predicted-get(inVar))
  head(cal.plsr.output)
  
  
  cal.R2 <- round(pls::R2(plsr.out)[[1]][nComps],2)
  cal.RMSEP <- round(sqrt(mean(cal.plsr.output$PLSR_CV_Residuals^2)),2)
  
  
  val.plsr.output <- data.frame(val.plsr.data[, which(names(val.plsr.data) %notin% "Spectra")],
                                PLSR_Predicted=as.vector(predict(plsr.out, 
                                                                 newdata = val.plsr.data, 
                                                                 ncomp=nComps, type="response")[,,1]))
  val.plsr.output <- val.plsr.output %>%
    mutate(PLSR_Residuals = PLSR_Predicted-get(inVar))
  head(val.plsr.output)
  
  
  val.R2 <- round(pls::R2(plsr.out,newdata=val.plsr.data)[[1]][nComps],2)
  val.RMSEP <- round(sqrt(mean(val.plsr.output$PLSR_Residuals^2)),2)
  
  cal_scatter_plot <- ggplot(cal.plsr.output, aes(x=PLSR_CV_Predicted, y=get(inVar),color=dataset)) + 
    theme_bw() + geom_point() + geom_abline(intercept = 0, slope = 1, color="dark grey", 
                                            linetype="dashed", size=1.5) + xlim(minX,maxX) + 
    ylim(minX, maxX) +
    labs(x=paste0("Predicted ", paste(inVar), " (units)"),
         y=paste0("Observed ", paste(inVar), " (units)"),
         title=paste0("Calibration: ", paste0("Rsq = ", cal.R2), "; ", paste0("RMSEP = ", 
                                                                              cal.RMSEP))) +
    theme(axis.text.x = element_text(angle = 0,vjust = 0.5),
          panel.border = element_rect(linetype = "solid", fill = NA, size=1.5))
  
  cal_resid_histogram <- ggplot(cal.plsr.output, aes(x=PLSR_CV_Residuals)) +
    geom_histogram(alpha=.5, position="identity") + 
    geom_vline(xintercept = 0, color="black", 
               linetype="dashed", size=1) + theme_bw() + 
    theme(axis.text.x = element_text(angle = 0,vjust = 0.5),
          panel.border = element_rect(linetype = "solid", fill = NA, size=1.5))
  
  val_scatter_plot <- ggplot(val.plsr.output, aes(x=PLSR_Predicted, y=get(inVar),color=dataset)) + 
    theme_bw() + geom_point() + geom_abline(intercept = 0, slope = 1, color="dark grey", 
                                            linetype="dashed", size=1.5) + xlim(minX,maxX) + 
    ylim(minX,maxX) +
    labs(x=paste0("Predicted ", paste(inVar), " (units)"),
         y=paste0("Observed ", paste(inVar), " (units)"),
         title=paste0("Validation: ", paste0("Rsq = ", val.R2), "; ", paste0("RMSEP = ", 
                                                                             val.RMSEP),"; ", paste0("nComps = ", 
                                                                                                     nComps))) +
    theme(axis.text.x = element_text(angle = 0,vjust = 0.5),
          panel.border = element_rect(linetype = "solid", fill = NA, size=1.5))
  
  val_resid_histogram <- ggplot(val.plsr.output, aes(x=PLSR_Residuals)) +
    geom_histogram(alpha=.5, position="identity") + 
    geom_vline(xintercept = 0, color="black", 
               linetype="dashed", size=1) + theme_bw() + 
    theme(axis.text.x = element_text(angle = 0,vjust = 0.5),
          panel.border = element_rect(linetype = "solid", fill = NA, size=1.5))
  
  print(cal_scatter_plot)
  print(val_scatter_plot)
  
  
  
  vips <- spectratrait::VIP(plsr.out)[nComps,]
  
  par(mfrow=c(2,1))
  plot(y=plsr.out$coefficients[,1,nComps],x=wv, xlab="Wavelength (nm)",
       ylab="Regression coefficients",lwd=2,type='l')
  box(lwd=2.2)
  plot(wv,vips,xlab="Wavelength (nm)",ylab="VIP",cex=0.01)
  lines(wv,vips,lwd=3)
  abline(h=0.8,lty=2,col="dark grey")
  box(lwd=2.2)
  if(!is.null(file_name)){dev.off()}
  #save(nComps,plsr.out,file=paste(file_name,'.Rdata',sep=''))
  print(summary(lm(val.plsr.output[,inVar]~val.plsr.output[,'PLSR_Predicted'])))
  return(list(plsr.out=plsr.out,nComps=nComps,Obs=val.plsr.output[,inVar],Pred=val.plsr.output[,'PLSR_Predicted']))
}

