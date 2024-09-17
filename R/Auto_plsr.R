#' Auto fit plsr function
#'
#' @param training  Dataframe for training the plsr. It must contain
#'  a sample identifier in the column SampleID of the data.frame and the spectra
#'  in a matrix present in the column Spectra of the data.frame.
#'  A column with the observed variable has to be present, as well as the sd of 
#'  this variable (called StdError_'inVar'). A column Dataset must also be present
#' @param validation Dataframe for validation of the plsr (same structure as the training data frame)
#' @param prop_internal_valid Proportion of the samples used in the inner validation
#' @param n_resamp Number of bootstrap resampling to perform
#' @param nComps_max Number of component max to use for the PLSR
#' @param nComp Number of component to use for validating the PLSR model. 
#' If null, the function will chose one automatically which is 1 sd away from the min PRESS.
#' @param inVar Column name of the variable in the training and validation datasets
#' @param pwr_transform By default 1. Use 0.5 if the input variable has to be squared.
#' @param wv Wavelengths of the spectra
#' @param file_name Name of the pdf file name for printing the plots
#'
#' @return
#' @export
#'
#' @examples
f.auto_plsr = function(training,validation,prop_internal_valid=0.7,n_resamp=1000,
                       nComps_max=30,nComp=NULL,inVar,pwr_transform=0.5,wv=450:2400,file_name=NULL){
  
  ## Number of samples in the training dataset
  n_training = nrow(training)
  print(paste('Number of training observations:', n_training))
  print(paste('Number of validation observations:', nrow(validation)))
  
  
  ## Initialization of the result matrices
  PRESS = matrix(data=NA,nrow=n_resamp,ncol=nComps_max)
  coefs = array(0,dim=c((ncol(training$Spectra)+1),n_resamp,nComps_max))
  VIPs = array(0,dim=c((ncol(training$Spectra)),n_resamp,nComps_max))
  Pred_valid = array(NA,dim=c(nrow(validation),n_resamp,nComps_max))
  
  ## Bootstrap
  print('Bootstrap starting, be patient')
  print(paste('Total of',n_resamp,'resampling, inner validation using',prop_internal_valid*100,'% of observations'))
  print('0 %')
  for(i in 1:n_resamp){
    resamp_leaves = sample(1:n_training,floor(prop_internal_valid*n_training))
    resamp_training = training[resamp_leaves,]
    resamp_validation = training[-resamp_leaves,]
    res = plsr(formula(paste("I(",inVar,"^",pwr_transform,")~","Spectra")), ncomp = nComps_max, 
             data = resamp_training,scale=FALSE,center=TRUE,validation="none",
             method = "oscorespls")
    coefs[,i,] = coef(res,intercept = TRUE,ncomp = 1:nComps_max)
    VIPs[,i,] = t(VIP(res))
    Pred_valid[,i,] = predict(res,newdata=validation)^(1/pwr_transform)
    pred_val_subset = predict(res,newdata=resamp_validation)^(1/pwr_transform)
    sq_resid = (pred_val_subset[,1,]-resamp_validation[,inVar])^2
    PRESS[i,] = apply(X = sq_resid, MARGIN = 2, FUN = sum)
    if(i %in% seq(0,n_resamp,n_resamp/10)){print(paste(i/n_resamp*100,'%'))}
  }
  
  if(!is.null(file_name)){pdf(file = paste(file_name,'.pdf',sep=''))}
## Figure to show the evolution of the PRESS with the number of components
  pressDF <- as.data.frame(PRESS)
  names(pressDF) <- as.character(seq(nComps_max))
  pressDFres <- melt(pressDF)
  bp <- ggplot(pressDFres, aes(x=variable, y=value)) + theme_bw() +
    geom_boxplot(notch=TRUE) + labs(x="Number of Components", y="PRESS") +
    theme(legend.position="none")
  
  print(bp)
  
  min_PRESS = apply(X=pressDF,MARGIN = 2,FUN = mean)[which.min(apply(X=pressDF,MARGIN = 2,FUN = mean))]
  sd_min_PRESS = apply(X=pressDF,MARGIN = 2,FUN = sd)[which.min(apply(X=pressDF,MARGIN = 2,FUN = mean))]
 
  nComp_optimal = max(which(apply(X=pressDF,MARGIN = 2,FUN = mean)>(min_PRESS+sd_min_PRESS)))+1
  print(paste('Optimal number of components:',nComp_optimal))
  if(is.null(nComp)){nComp=nComp_optimal}else{print(paste('fixed number of components used for prediction:','nComp'))}
  
  
  
  f.plot.coef(Z = t(coefs[2:(length(wv)+1),,nComp]),wv = wv)
  f.plot.coef(Z = t(VIPs[1:length(wv),,nComp]),wv = wv,type = 'VIPs')
  
  ### Calculation of the uncertainty associated with the pLSR prediction
  sd_mean=apply(X = Pred_valid[,,nComp],MARGIN = 1,FUN = sd)
  mean_pred=apply(X = Pred_valid[,,nComp],MARGIN = 1,FUN = mean)
  #mean_pred2=(validation$Spectra %*% rowMeans(coefs[2:(length(wv)+1),,nComp]) + mean(coefs[1,,nComp]))^(1/pwr_transform)
  
  
  validation$mean_pred=mean_pred
  sd_res=sd(validation[,inVar]-mean_pred)
  sd_tot=sqrt(sd_mean^2+sd_res^2)
  lwr_conf=mean_pred-1.96*sd_mean
  upr_conf=mean_pred+1.96*sd_mean
  lwr_pred=mean_pred-1.96*sd_tot
  upr_pred=mean_pred+1.96*sd_tot
  
  interval_valid=cbind.data.frame(
    lwr_conf=lwr_conf,upr_conf=upr_conf,lwr_pred=lwr_pred,upr_pred=upr_pred,
    lwr_obs=validation[,inVar]-1.96*validation[,paste('StdError_',inVar,sep='')],
    upr_obs=validation[,inVar]+1.96*validation[,paste('StdError_',inVar,sep='')],
    mean_pred=mean_pred,
    sd_pred=apply(X = Pred_valid[,,nComp],MARGIN = 1,FUN = sd),
    Dataset_name=validation$Dataset_name,
    SampleID=validation$SampleID,
    Obs=validation[,inVar],
    sd_tot=sd_tot
  )
  
  fig=(ggplot(data=interval_valid,aes(y=Obs,x=mean_pred,color=Dataset_name))
    +geom_point()
    +geom_errorbar(data=interval_valid,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs))
    #+geom_errorbarh(data=interval_valid,aes(y=Obs,xmin=lwr_pred,xmax=upr_pred),alpha=0.3)
    +geom_errorbarh(data=interval_valid,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf))
    +geom_abline(slope = 1,intercept = 0))
  
  print(fig)
  res_all=(lm(Obs~mean_pred,data=interval_valid))
  RMSE = sqrt(mean(residuals(res_all)^2))
  print(paste('Residual error sigma:',summary(res_all)$sigma))
  print(paste('Coefficient of determination R2:',summary(res_all)$r.squared))
  print(paste('RMSE',RMSE))
  if(!is.null(file_name)){dev.off()}
  
  return(list(nComp=nComp,coefs=coefs[,,nComp],VIPs=VIPs[,,nComp],Predictions=interval_valid,R2=res_all$r.squared,RMSE=RMSE))
}