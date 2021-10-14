library(LeafGasExchange)
load('1_QC_data.Rdata',verbose=TRUE)
curated_data$Tleaf=curated_data$Tleaf+273.16 ## Conversion to kelvin
curated_data=curated_data[order(curated_data$SampleID_num,curated_data$Ci),]
pdf(file = '2_ACi_fitting_without_Tp.pdf')
result=by(data = curated_data,INDICES = list(curated_data$SampleID_num),FUN = function(x){f.fitting(measures = x,Start = list(JmaxRef=45,RdRef=1,VcmaxRef=30),param=f.make.param(TBM='FATES',TpRef=50),id.name = 'SampleID_num')})
dev.off()

pdf(file = paste('2_ACi_fitting_with_Tp.pdf','.pdf'))
result_Tp=by(data = curated_data,INDICES = list(curated_data$SampleID_num),
              FUN = function(x){
                Start = list(JmaxRef=45,RdRef=1,VcmaxRef=30)
                modify.init=TRUE
                if(!is.null(result[[unique(x$SampleID_num)]][[2]])){
                  without_Tp_Start=result[[unique(x$SampleID_num)]][[2]]@coef
                  modify.init=FALSE
                  for(value in names(Start)){Start[[value]]=without_Tp_Start[value]}
                }
                Start[['TpRef']]=Start[['VcmaxRef']]/8
                
                f.fitting(measures = x,Start = Start,param=f.make.param(TBM = 'FATES'),id.name = 'SampleID_num',modify.init =modify.init )})
dev.off()


res_nlf=unlist(lapply(result,FUN = function(x) x[[1]]$convergence))
table(res_nlf)

res_nlf=as.data.frame(t(sapply(result,FUN = function(x) c(x[[2]]@coef,BIC=BIC(x[[2]]),Tleaf=x[[3]]['Tleaf']))))
res_nlf$SampleID_num=row.names(res_nlf)

res_nlf_Tp=as.data.frame(t(sapply(result_Tp,FUN = function(x) c(x[[2]]@coef,BIC=BIC(x[[2]]),Tleaf=x[[3]]['Tleaf']))))
res_nlf_Tp$SampleID_num=row.names(res_nlf_Tp)

Bilan=merge(x=res_nlf,y=res_nlf_Tp,by='SampleID_num')
Bilan$model='Without_Tp'
Bilan[Bilan$AIC.x>Bilan$AIC.y,'model']='With_Tp'

temp1=Bilan[Bilan$model=='With_Tp',c(1,8:13,15,7)]
temp2=Bilan[Bilan$model=='Without_Tp',c(1:4,11,5,6,15,7)]
temp2$TpRef=NA
colnames(temp1)=colnames(temp2)=c('SampleID_num','sigma','JmaxRef','VcmaxRef','TpRef','RdRef','BIC','Model','Tleaf')
Bilan=rbind.data.frame(temp1,temp2)

hist(Bilan$sigma)
Bilan[Bilan$sigma>quantile(x = Bilan$sigma,probs = 0.95),'SampleID_num']
## After manual inspection, those fittings seem fine, at least for Vcmax.

hist(Bilan$VcmaxRef)
plot(x=Bilan$VcmaxRef,y=Bilan$JmaxRef,xlab='Vcmax25',ylab='Jmax25',xlim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)),ylim=c(min(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE),max(c(Bilan$VcmaxRef,Bilan$JmaxRef),na.rm=TRUE)))
abline(a=c(0,1))
abline(lm(JmaxRef~0+VcmaxRef,data=Bilan),col='red')


## Adding the SampleID column
Table_SampleID=curated_data[!duplicated(curated_data$SampleID),c('SampleID','SampleID_num')]
Bilan=merge(x=Bilan,y=Table_SampleID,by.x='SampleID_num',by.y='SampleID_num')




## Comparison with the Authors fitting

Author_fitting=read.csv(file='10_vcmax_jmax_estimates.csv')
Author_fitting=merge(x=Author_fitting,y=Bilan,by.x='fname',by.y='SampleID')
Bilan=merge(x=Bilan,y=Author_fitting[,c('fname','Vcmax','Jmax')],by.x='SampleID',by.y='fname')
save(Bilan,file='2_Result_ACi_fitting.Rdata')

param=f.make.param()
Author_fitting$Vcmax_new=f.modified.arrhenius(PRef = Author_fitting$VcmaxRef,Ha = param$VcmaxHa,Hd = param$VcmaxHd,s = param$VcmaxS,Tleaf = Author_fitting$Tleaf,TRef = 25+273.16)
plot(Author_fitting$Vcmax,Author_fitting$Vcmax_new)
plot(Author_fitting$Vcmax,Author_fitting$VcmaxRef,xlab='Vcmax25_Authors',ylab='Vcmax25_Us',xlim=c(40,150),ylim=c(40,150))
summary(lm(Author_fitting$Vcmax~Author_fitting$VcmaxRef))
abline(c(0,1))
