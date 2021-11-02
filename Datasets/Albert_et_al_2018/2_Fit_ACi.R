library(LeafGasExchange)
library(here)
path=here()
setwd(paste(path,'/Datasets/Albert_et_al_2018',sep=''))


load('1_QC_data.Rdata',verbose=TRUE)
curated_data$Tleaf=curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

load('1_QC_data.Rdata',verbose=TRUE)
curated_data$Tleaf=curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]

## A lot of curves are not Aj limited
pdf(file = '2_ACi_fitting_without_Tp.pdf')
result=by(data = curated_data,INDICES = list(curated_data$SampleID_num),
          FUN = function(x){f.fitting(measures = x,Start = list(JmaxRef=120,RdRef=2,VcmaxRef=60),
                                      param=f.make.param(TBM='FATES',TpRef=50),id.name = 'SampleID_num')})
dev.off()

pdf(file = '2_ACi_fitting_without_Aj.pdf')
result_Ac=by(data = curated_data,INDICES = list(curated_data$SampleID_num),
             FUN = function(x){f.fitting(measures = x,Start = list(RdRef=2,VcmaxRef=60),
                                         param=f.make.param(TBM='FATES',TpRef=50,JmaxRef=1000),id.name = 'SampleID_num')})
dev.off()


pdf(file = '2_ACi_fitting_with_Tp.pdf')
result_Tp=by(data = curated_data,INDICES = list(curated_data$SampleID_num),
             FUN = function(x){
               Start = list(JmaxRef=120,RdRef=2,VcmaxRef=60)
               modify.init=TRUE
               if(!is.null(result[[as.character(unique(x$SampleID_num))]][[2]])){
                 without_Tp_Start=result[[as.character(unique(x$SampleID_num))]][[2]]@coef
                 modify.init=FALSE
                 for(value in names(Start)){Start[[value]]=without_Tp_Start[value]}
               }
               Start[['TpRef']]=Start[['VcmaxRef']]/8
               
               f.fitting(measures = x,Start = Start,
                         param=f.make.param(TBM = 'FATES'),id.name = 'SampleID_num',modify.init =modify.init )})
dev.off()



res_nlf=unlist(lapply(result,FUN = function(x) x[[1]]$convergence))
table(res_nlf)


res_nlf=as.data.frame(t(sapply(result,FUN = function(x) c(x[[2]]@coef,BIC=BIC(x[[2]]),Tleaf=x[[3]]['Tleaf']))))
res_nlf$SampleID_num=row.names(res_nlf)

res_nlf_Ac=as.data.frame(t(sapply(result_Ac,FUN = function(x) c(x[[2]]@coef,BIC=BIC(x[[2]]),Tleaf=x[[3]]['Tleaf']))))
res_nlf_Ac$SampleID_num=row.names(res_nlf_Ac)

res_nlf_Tp=as.data.frame(t(sapply(result_Tp,FUN = function(x) c(x[[2]]@coef,BIC=BIC(x[[2]]),Tleaf=x[[3]]['Tleaf']))))
res_nlf_Tp$SampleID_num=row.names(res_nlf_Tp)

res_nlf_Ac$JmaxRef=NA
res_nlf_Ac$TpRef=NA
res_nlf$TpRef=NA
res_nlf$model='Without_Tp'
res_nlf_Ac$model='Without_Aj'
res_nlf_Tp$model='With_Tp'

res_nlf=res_nlf[,colnames(res_nlf_Tp)]
res_nlf_Ac=res_nlf_Ac[,colnames(res_nlf_Tp)]


Bilan=res_nlf
Bilan[which(res_nlf_Ac$BIC<res_nlf$BIC),]=res_nlf_Ac[which(res_nlf_Ac$BIC<res_nlf$BIC),]
Bilan[which(res_nlf_Tp$BIC<Bilan$BIC),]=res_nlf_Tp[which(res_nlf_Tp$BIC<Bilan$BIC),]
colnames(Bilan)=c("sigma","JmaxRef","VcmaxRef","TpRef","RdRef","BIC","Tleaf","SampleID_num","model") 

### Creating a pdf with the best model for each curve

pdf(file = '2_ACi_fitting_best_model.pdf')
by(data = curated_data,INDICES = list(curated_data$SampleID_num),
   FUN = function(x){
     param=Bilan[Bilan$SampleID_num==unique(x$SampleID_num),c('VcmaxRef','JmaxRef','RdRef','TpRef')]
     param_leg=param
     param[is.na(param)]=9999
     param_curve=f.make.param(VcmaxRef = param[['VcmaxRef']],JmaxRef=param[['JmaxRef']],RdRef=param[['RdRef']],TpRef=param[['TpRef']])
     f.plot(measures=x,list_legend = as.list(param_leg),param = param_curve,name =unique(x$SampleID_num) )
   }
)

dev.off()

## After seeing the pdf, I removed a lot of curves: 
## 8,12,15,17,18,20,21,32,47,48,56,58,68,86.
## Some were very noisy, or probably measured at a too low light irradiance


Bilan[Bilan$sigma>quantile(x = Bilan$sigma,probs = 0.95),'SampleID_num']
## After manual inspection, those fittings seem fine, at least for Vcmax.

hist(Bilan$VcmaxRef)
plot(x=Bilan$VcmaxRef,y=Bilan$JmaxRef,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)),ylim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(JmaxRef~0+VcmaxRef,data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')

save(Bilan,file='2_Result_ACi_fitting.Rdata')



