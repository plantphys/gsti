#' @param measures Aci curve dataframe with at least the columns A, Ci, Qin and Tleaf (in K)
#' @param param See f.make.param for details. Determine the parameters used for the fitting
#' @param VcmaxRef Value of VcmaxRef used to initialize the fitting procedure
#' @param JmaxRef Value of JmaxRef used to initialize the fitting procedure
#' @param RdRef Value of RdRef used to initialize the fitting procedure
#' @param TpRef Value of TpRef used to initialize the fitting procedure
#'
#' @return Return a dataframe (Bilan) with for each curve in row the estimated parameters as well as the model used (Ac, Ac and Aj, Ac and Aj and Ap)
#' @export
#'
#' @examples
f.fit_Aci<-function(measures,param,VcmaxRef=60, JmaxRef=120, RdRef = 2, TpRef= 5){
 
  param[['TpRef']]=9999
## Fitting of the Aci curve using Ac and Aj limitation
   pdf(file = '2_ACi_fitting_Ac_Aj.pdf')
  result_Ac_Aj=by(data = measures,INDICES = list(measures$SampleID_num),
            FUN = function(x){print(paste('SampleID_num:',unique(x$SampleID_num)))
                              f.fitting(measures = x,Start = list(JmaxRef=JmaxRef,RdRef=RdRef,VcmaxRef=VcmaxRef),
                                        param=param,id.name = 'SampleID_num')})
  dev.off()
  
  param[['JmaxRef']]=9999
## Fitting of the Aci curve using only the Ac limitation
  pdf(file = '2_ACi_fitting_Ac.pdf')
  result_Ac=by(data = measures,INDICES = list(measures$SampleID_num),
               FUN = function(x){print(paste('SampleID_num:',unique(x$SampleID_num)))
                                  f.fitting(measures = x,Start = list(RdRef=RdRef,VcmaxRef=VcmaxRef),
                                           param=param,id.name = 'SampleID_num')})
  dev.off()
  
##Fitting of the curve using the Ac, Aj and Ap limitations
  pdf(file = '2_ACi_fitting_Ac_Aj_Ap.pdf')
  result_Ac_Aj_Ap=by(data = measures,INDICES = list(measures$SampleID_num),
               FUN = function(x){
                 print(paste('SampleID_num:',unique(x$SampleID_num)))
                 Start = list(JmaxRef=JmaxRef,RdRef=RdRef,VcmaxRef=VcmaxRef)
                 modify.init=TRUE
                 if(!is.null(result_Ac_Aj[[as.character(unique(x$SampleID_num))]][[2]])){
                   without_Tp_Start=result_Ac_Aj[[as.character(unique(x$SampleID_num))]][[2]]@coef
                   modify.init=FALSE
                   for(value in names(Start)){Start[[value]]=without_Tp_Start[value]}
                 }
                 Start[['TpRef']]=Start[['VcmaxRef']]/8
                 
                 f.fitting(measures = x,Start = Start,
                           param=param,id.name = 'SampleID_num',modify.init =modify.init )})
  dev.off()
  
## Extracting the fitting metrics for each model and each curve
  res_nlf_Ac_Aj=as.data.frame(t(sapply(result_Ac_Aj,FUN = function(x){
    if(!is.null(x[[2]])){
      coefs=x[[2]]@coef
      AICcurve=AIC(x[[2]])}else {coefs=rep(NA,4)
                              AICcurve=NA}
    return(c(coefs,AIC=AICcurve,Tleaf=x[[3]]['Tleaf']))}
    )))
  res_nlf_Ac_Aj$SampleID_num=row.names(res_nlf_Ac_Aj)
  
  res_nlf_Ac=as.data.frame(t(sapply(result_Ac,FUN = function(x){
    if(!is.null(x[[2]])){
      coefs=x[[2]]@coef
      AICcurve=AIC(x[[2]])}else {coefs=rep(NA,3)
      AICcurve=NA}
    return(c(coefs,AIC=AICcurve,Tleaf=x[[3]]['Tleaf']))}
  )))
  res_nlf_Ac$SampleID_num=row.names(res_nlf_Ac)
  
  res_nlf_Ac_Aj_Ap=as.data.frame(t(sapply(result_Ac_Aj_Ap,FUN = function(x){
    if(!is.null(x[[2]])){
      coefs=x[[2]]@coef
      AICcurve=AIC(x[[2]])}else {coefs=rep(NA,5)
      AICcurve=NA}
    return(c(coefs,AIC=AICcurve,Tleaf=x[[3]]['Tleaf']))}
  )))
  res_nlf_Ac_Aj_Ap$SampleID_num=row.names(res_nlf_Ac_Aj_Ap)
  
  res_nlf_Ac$JmaxRef=NA
  res_nlf_Ac$TpRef=NA
  res_nlf_Ac_Aj$TpRef=NA
  res_nlf_Ac_Aj$model='Ac_Aj'
  res_nlf_Ac$model='Ac'
  res_nlf_Ac_Aj_Ap$model='Ac_Aj_Ap'
  
  res_nlf_Ac_Aj=res_nlf_Ac_Aj[,colnames(res_nlf_Ac_Aj_Ap)]
  res_nlf_Ac=res_nlf_Ac[,colnames(res_nlf_Ac_Aj_Ap)]
  
## Finding the best model (Ac or Ac_Aj or Ac_Aj_Ap according to the AIC criterion)
  
  Bilan=res_nlf_Ac_Aj
  Bilan[which(res_nlf_Ac$AIC<res_nlf_Ac_Aj$AIC),]=res_nlf_Ac[which(res_nlf_Ac$AIC<res_nlf_Ac_Aj$AIC),]
  Bilan[which(res_nlf_Ac_Aj_Ap$AIC<Bilan$AIC),]=res_nlf_Ac_Aj_Ap[which(res_nlf_Ac_Aj_Ap$AIC<Bilan$AIC),]
  colnames(Bilan)=c("sigma","JmaxRef","VcmaxRef","TpRef","RdRef","AIC","Tleaf","SampleID_num","model") 
  Bilan$Vcmax_method="A-Ci curve"
  
### Creating a pdf with the best model for each curve
  
  pdf(file = '2_ACi_fitting_best_model.pdf')
  by(data = measures,INDICES = list(measures$SampleID_num),
     FUN = function(x){
       param_leg=Bilan[Bilan$SampleID_num==unique(x$SampleID_num),c('VcmaxRef','JmaxRef','RdRef','TpRef')]
       param_leg[is.na(param_leg)]=9999
       param['VcmaxRef']=param_leg['VcmaxRef']
       param['JmaxRef']=param_leg['JmaxRef']
       param['RdRef']=param_leg['RdRef']
       param['TpRef']=param_leg['TpRef']
       f.plot(measures=x,list_legend = as.list(param_leg),param = param,name =unique(x$SampleID_num))
     }
  )
  dev.off()
  
  return(Bilan)
}






