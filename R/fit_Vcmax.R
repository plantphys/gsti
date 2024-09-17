#' @param measures Aci curve dataframe with at least the columns A, Ci, Qin and Tleaf (in K)
#' @param param See f.make.param for details. Determine the parameters used for the fitting
#' @param VcmaxRef Value of VcmaxRef used to initialize the fitting procedure
#' @param JmaxRef Value of JmaxRef used to initialize the fitting procedure
#' @param RdayRef Value of RdayRef used to initialize the fitting procedure
#' @param TPURef Value of TPURef used to initialize the fitting procedure
#'
#' @return Return a dataframe (Bilan) with for each curve in row the estimated parameters as well as the model used (Ac, Ac and Aj, Ac and Aj and Ap)
#' @export
#'
#' @examples
f.fit_Aci<-function(measures,param,VcmaxRef=60, JmaxRef=120, RdayRef = 2, TPURef= 5){
## Basic checks
  if(any(measures$Ci < 0)) {stop("Ci contains negative values")}
  if(any(is.na(c(measures$A,measures$Ci,measures$Tleaf,measures$Qin,measures$SampleID_num)))) {stop("Ci, A, Tleaf or Qin have NA values")}
  if(any(measures$Tleaf > 100)) {stop("Check Tleaf values. Should be in degree celcius")}
  if(is.null(measures$SampleID_num)|is.null(measures$Ci)|is.null(measures$Tleaf)|is.null(measures$Qin)|is.null(measures$A)){stop("Your dataframe measures does not contain the colums SampleID_num or A or Tleaf or Ci")}
  n_points_curves=tapply(X=measures$SampleID_num,INDEX = measures$SampleID_num,FUN = function(x) length(x))
  min_Ci_curve=tapply(X=measures$Ci,INDEX = measures$SampleID_num,FUN = min)
  if(any(n_points_curves<3)){stop("Some of your A-Ci curves have less than 3 points")}
  if(any(min_Ci_curve>270)){stop("Some of your A-Ci curves have a minimum Ci above 270 ppm meaning that Vcmax cant be estimated")}
  
  measures$Tleaf=measures$Tleaf+273## Conversion in Kelvin
  param[['TPURef']]=9999

## Fitting of the Aci curve using Ac and Aj limitation
   pdf(file = '2_ACi_fitting_Ac_Aj.pdf')
  result_Ac_Aj=by(data = measures,INDICES = list(measures$SampleID_num),
            FUN = function(x){print(paste('SampleID_num:',unique(x$SampleID_num)))
                              f.fitting(measures = x,Start = list(JmaxRef=JmaxRef,RdayRef=RdayRef,VcmaxRef=VcmaxRef),
                                        param=param,id.name = 'SampleID_num')})
  dev.off()
  
  param[['JmaxRef']]=9999
## Fitting of the Aci curve using only the Ac limitation
  pdf(file = '2_ACi_fitting_Ac.pdf')
  result_Ac=by(data = measures,INDICES = list(measures$SampleID_num),
               FUN = function(x){print(paste('SampleID_num:',unique(x$SampleID_num)))
                                  f.fitting(measures = x,Start = list(RdayRef=RdayRef,VcmaxRef=VcmaxRef),
                                           param=param,id.name = 'SampleID_num')})
  dev.off()
  
##Fitting of the curve using the Ac, Aj and Ap limitations
  pdf(file = '2_ACi_fitting_Ac_Aj_Ap.pdf')
  result_Ac_Aj_Ap=by(data = measures,INDICES = list(measures$SampleID_num),
               FUN = function(x){
                 print(paste('SampleID_num:',unique(x$SampleID_num)))
                 Start = list(JmaxRef=JmaxRef,RdayRef=RdayRef,VcmaxRef=VcmaxRef)
                 modify.init=TRUE
                 if(!is.null(result_Ac_Aj[[as.character(unique(x$SampleID_num))]][[2]])){
                   without_Tp_Start=result_Ac_Aj[[as.character(unique(x$SampleID_num))]][[2]]@coef
                   modify.init=FALSE
                   for(value in names(Start)){Start[[value]]=without_Tp_Start[value]}
                 }
                 Start[['TPURef']]=Start[['VcmaxRef']]/8
                 
                 f.fitting(measures = x,Start = Start,
                           param=param,id.name = 'SampleID_num',modify.init =modify.init )})
  dev.off()
  
  
  ##Fitting of the curve using the Ac and Ap limitations (without Aj)
  pdf(file = '2_ACi_fitting_Ac_Ap.pdf')
  result_Ac_Ap=by(data = measures,INDICES = list(measures$SampleID_num),
                     FUN = function(x){
                       print(paste('SampleID_num:',unique(x$SampleID_num)))
                       Start = list(RdayRef=RdayRef,VcmaxRef=VcmaxRef)
                       modify.init=TRUE
                       if(!is.null(result_Ac_Aj_Ap[[as.character(unique(x$SampleID_num))]][[2]])){
                         without_Aj_Start=result_Ac_Aj_Ap[[as.character(unique(x$SampleID_num))]][[2]]@coef
                         modify.init=FALSE
                         for(value in names(Start)){Start[[value]]=without_Aj_Start[value]}
                       }
                       Start[['TPURef']]=Start[['VcmaxRef']]/8
                       
                       f.fitting(measures = x,Start = Start,
                                 param=param,id.name = 'SampleID_num',modify.init =modify.init )})
  dev.off()
  
## Extracting the fitting metrics for each model and each curve
  res_nlf_Ac_Aj=as.data.frame(t(sapply(result_Ac_Aj,FUN = function(x){
    if(!is.null(x[[2]])){
      coefs=x[[2]]@coef
      summary_mle2=summary(x[[2]])
      std_dev=sqrt(diag(x[[2]]@vcov))
      names(std_dev)=paste('StdError',names(std_dev),sep='_')
      AICcurve=AIC(x[[2]])}else {coefs=rep(NA,4)
                              std_dev=rep(NA,4)
                              AICcurve=NA}
    return(c(coefs,std_dev,AIC=AICcurve,Tleaf=x[[3]]['Tleaf']))}
    )))
  res_nlf_Ac_Aj$SampleID_num=row.names(res_nlf_Ac_Aj)
  
  res_nlf_Ac=as.data.frame(t(sapply(result_Ac,FUN = function(x){
    if(!is.null(x[[2]])){
      coefs=x[[2]]@coef
      std_dev=sqrt(diag(x[[2]]@vcov))
      names(std_dev)=paste('StdError',names(std_dev),sep='_')
      AICcurve=AIC(x[[2]])}else {coefs=rep(NA,3)
                                std_dev=rep(NA,3)
                                AICcurve=NA}
    return(c(coefs,std_dev,AIC=AICcurve,Tleaf=x[[3]]['Tleaf']))}
  )))
  res_nlf_Ac$SampleID_num=row.names(res_nlf_Ac)
  
  res_nlf_Ac_Aj_Ap=as.data.frame(t(sapply(result_Ac_Aj_Ap,FUN = function(x){
    if(!is.null(x[[2]])){
      coefs=x[[2]]@coef
      std_dev=sqrt(diag(x[[2]]@vcov))
      names(std_dev)=paste('StdError',names(std_dev),sep='_')
      AICcurve=AIC(x[[2]])}else {coefs=rep(NA,5)
                                std_dev=rep(NA,5)
                                AICcurve=NA}
    return(c(coefs,std_dev,AIC=AICcurve,Tleaf=x[[3]]['Tleaf']))}
  )))
  res_nlf_Ac_Aj_Ap$SampleID_num=row.names(res_nlf_Ac_Aj_Ap)
  
  res_nlf_Ac_Ap=as.data.frame(t(sapply(result_Ac_Ap,FUN = function(x){
    if(!is.null(x[[2]])){
      coefs=x[[2]]@coef
      std_dev=sqrt(diag(x[[2]]@vcov))
      names(std_dev)=paste('StdError',names(std_dev),sep='_')
      AICcurve=AIC(x[[2]])}else {coefs=rep(NA,4)
      std_dev=rep(NA,4)
      AICcurve=NA}
    return(c(coefs,std_dev,AIC=AICcurve,Tleaf=x[[3]]['Tleaf']))}
  )))
  res_nlf_Ac_Ap$SampleID_num=row.names(res_nlf_Ac_Ap)
  
  
  res_nlf_Ac$JmaxRef=NA
  res_nlf_Ac$TPURef=NA
  res_nlf_Ac$StdError_JmaxRef=NA
  res_nlf_Ac$StdError_TPURef=NA
  res_nlf_Ac$model='Ac'
  
  res_nlf_Ac_Aj$TPURef=NA
  res_nlf_Ac_Aj$StdError_TPURef=NA
  res_nlf_Ac_Aj$model='Ac_Aj'
  
  res_nlf_Ac_Aj_Ap$model='Ac_Aj_Ap'
  
  res_nlf_Ac_Ap$JmaxRef=NA
  res_nlf_Ac_Ap$StdError_JmaxRef=NA
  res_nlf_Ac_Ap$model='Ac_Ap'
  
  res_nlf_Ac_Aj=res_nlf_Ac_Aj[,colnames(res_nlf_Ac_Aj_Ap)]
  res_nlf_Ac=res_nlf_Ac[,colnames(res_nlf_Ac_Aj_Ap)]
  res_nlf_Ac_Ap=res_nlf_Ac_Ap[,colnames(res_nlf_Ac_Aj_Ap)]
  
## Finding the best model (Ac or Ac_Aj or Ac_Aj_Ap or Ac_Ap according to the AIC criterion)
  Bilan=res_nlf_Ac_Aj
  Bilan[which(res_nlf_Ac$AIC<res_nlf_Ac_Aj$AIC),]=res_nlf_Ac[which(res_nlf_Ac$AIC<res_nlf_Ac_Aj$AIC),]
  Bilan[which(res_nlf_Ac_Aj_Ap$AIC<Bilan$AIC),]=res_nlf_Ac_Aj_Ap[which(res_nlf_Ac_Aj_Ap$AIC<Bilan$AIC),]
  Bilan[which(res_nlf_Ac_Ap$AIC<Bilan$AIC),]=res_nlf_Ac_Ap[which(res_nlf_Ac_Ap$AIC<Bilan$AIC),]
  colnames(Bilan)=c("sigma","JmaxRef","VcmaxRef","TPURef","RdayRef","StdError_sigma","StdError_JmaxRef","StdError_VcmaxRef","StdError_TPURef","StdError_RdayRef","AIC","Tleaf","SampleID_num","model") 
  Bilan$Vcmax_method="A-Ci curve"
  
### Creating a pdf with the best model for each curve
  
  pdf(file = '2_ACi_fitting_best_model.pdf')
  A_limitations=by(data = measures,INDICES = list(measures$SampleID_num),
     FUN = function(x){
       param_leg=Bilan[Bilan$SampleID_num==unique(x$SampleID_num),c('VcmaxRef','JmaxRef','RdayRef','TPURef')]
       param_leg[is.na(param_leg)]=9999
       param['VcmaxRef']=param_leg['VcmaxRef']
       param['JmaxRef']=param_leg['JmaxRef']
       param['RdayRef']=param_leg['RdayRef']
       param['TPURef']=param_leg['TPURef']
       f.plot(measures=x,list_legend = as.list(param_leg),param = param,name =unique(x$SampleID_num))
       simu=f.Aci(PFD=x$Qin,Tleaf = x$Tleaf,ci = x$Ci,param = param)
       ## Number of points limited by Ac, Aj and Ap
       n_Ac=sum(simu$Ac<simu$Aj&simu$Ac<simu$Ap, na.rm = TRUE)
       n_Aj=sum(simu$Aj<simu$Ac&simu$Aj<simu$Ap, na.rm = TRUE)
       n_Ap=sum(simu$Ap<simu$Ac&simu$Ap<simu$Aj, na.rm = TRUE)
       n_lim=c(SampleID_num=unique(x$SampleID_num),n_Ac=n_Ac,n_Aj=n_Aj,n_Ap=n_Ap)
       return(n_lim)
     }
  )
  dev.off()
  
  A_limitations=do.call(rbind.data.frame, A_limitations)
  colnames(A_limitations)=c("SampleID_num","n_Ac","n_Aj","n_Ap")
  ## I remove estimates of Ac, Aj or Ap that are based on too few points. 
  Bilan[A_limitations$n_Ac<=2,c("VcmaxRef","StdError_VcmaxRef")]=NA
  Bilan[A_limitations$n_Aj<2,c("JmaxRef","StdError_JmaxRef")]=NA
  Bilan[A_limitations$n_Ap<2,c("TpRef","StdError_TpRef")]=NA
  
  ## Renaming Bilan so it corresponds to the standard used in this repo:
  colnames(Bilan)=c("sigma","Jmax25","Vcmax25","TPU25","Rday25","StdError_sigma","StdError_Jmax25","StdError_Vcmax25","StdError_TPU25","StdError_Rday25","AIC","Tleaf","SampleID_num","Model","Fitting_method") 
  Bilan$Tleaf=Bilan$Tleaf-273 ## Conversion to degree Celcius
  return(Bilan[,c("SampleID_num","Vcmax25","Jmax25","TPU25","Rday25","StdError_Vcmax25","StdError_Jmax25","StdError_TPU25","StdError_Rday25","Tleaf","sigma","AIC","Model","Fitting_method")])
}


#' @param measures Aci curve dataframe with at least the columns A, Ci, Qin and Tleaf (in degree celcius)
#' @param param See f.make.param for details. Determine the parameters used for the fitting
#' @return Return a dataframe (Bilan) with for each curve in row the estimated parameters as well as the model used (Ac, Ac and Aj, Ac and Aj and Ap)
#' @export
#'
#' @examples
f.fit_One_Point<-function(measures,param){
  if(any(measures$Ci < 0)) {stop("Ci contains negative values")}
  if(any(measures$Tleaf > 100)) {stop("Check Tleaf values. Should be in degree celcius")}
  if(is.null(measures$SampleID_num)|is.null(measures$Ci)|is.null(measures$Tleaf)|is.null(measures$Qin)|is.null(measures$A)){stop("Your dataframe measures do not contain the colums SampleID_num or A or Tleaf or Ci")}
  n_points_curves=tapply(X=measures$SampleID_num,INDEX = measures$SampleID_num,FUN = function(x) length(x))
  if(any(n_points_curves>1)){warning("Some of your SampleID_num have more than one measurements")}
  if(any(measures$Ci>400)){stop("Some of your Ci are above 400 ppm meaning that Vcmax cant be estimated")}
  
  measures$Tleaf=measures$Tleaf+273
  Gstar=f.arrhenius(param[['GstarRef']],param[['GstarHa']],measures$Tleaf)
  Kc=f.arrhenius(param[['KcRef']],param[['KcHa']],measures$Tleaf)
  Ko=f.arrhenius(param[['KoRef']],param[['KoHa']],measures$Tleaf)
  Km=Kc*(1+param[['O2']]/Ko)
  Vcmax=measures$A/((measures$Ci-Gstar)/(measures$Ci+Km)-0.015)
  Vcmax25=f.modified.arrhenius.inv(P = Vcmax,Ha = param[['VcmaxHa']],Hd = param[['VcmaxHd']],s = param[['VcmaxS']],Tleaf = measures$Tleaf,TRef = 273.16+25)
  return(data.frame(SampleID_num=measures$SampleID_num,Vcmax25=Vcmax25,Jmax25=NA,TPU25=NA,Rday25=NA,StdError_Vcmax25=NA,StdError_Jmax25=NA,StdError_TPU25=NA,StdError_Rday25=NA,Tleaf=measures$Tleaf-273,sigma=NA,AIC=NA,Model=NA,Fitting_method='One point'))
}
