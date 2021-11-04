#' @param VcmaxRef Maximum rate of Rubisco for carboxylation micromol.m-2.s-1
#' @param VcmaxHa Energy of activation for Vcmax in J.mol-1
#' @param VcmaxHd Energy of desactivation for Vcmax in J.mol-1
#' @param VcmaxS Entropy term for Vcmax in J.mol-1.K-1
#' @param RdRef Respiration value at the reference temperature
#' @param RdHa Energie of activation for Rd in J.mol-1
#' @param RdHd Energy of desactivation for Rd in J.mol-1
#' @param RdS Entropy term for Rd in J.mol-1.K-1
#' @param KcRef Michaelis-Menten constant of Rubisco for CO2 at the reference temperature in micromol.mol-1
#' @param KcHa Energy of activation for Kc in J.mol-1
#' @param KoRef ichaelis-Menten constant of Rubisco for CO2 at the reference temperature in milimol.mol-1
#' @param KoHa Energy of activation for Ko in J.mol-1
#' @param GstarRef CO2 compensation point in absence of respiration in micromol.mol-1
#' @param GstarHa Enthalpie of activation for Gstar in J.mol-1
#' @param VqmaxRef Maximum activity of cytochrom b6f in micro mol electron-1 m-2 s-1
#' @param VqmaxHa Energy of activation for Vqmax in J.mol-1
#' @param abso Absorptance of the leaf (0 - 1, unitless)
#' @param Beta PSII fraction of leaf absorptance
#' @param etacRef Coupling efficiency for CEF1 at the reference temperature (unitless)
#' @param etachd Energy of desactivation for etac in J.mol-1
#' @param etacS Entropy term for etac in J.mol-1
#' @param etalRef Coupling efficiency for LEF at the reference temperature (unitless)
#' @param etalhd Energy of desactivation for etal in J.mol-1
#' @param etalS Entropy term for etal in J.mol-1
#' @param phi1max Maximum photochemical yield of PS1, calculated using eq 30a, 41 c and Table 1
#'
#' @return
#' @export
#'
#' @examples
f.make.param_JB<-function(R=NA,TRef=NA,VcmaxRef=NA,
                       VcmaxHa	=NA,
                       VcmaxHd	=NA,
                       VcmaxS	=NA,
                       VqmaxRef=NA,
                       VqmaxHa=	NA,
                       TpRef=NA,
                       TpHa=NA,
                       TpHd=NA,
                       TpS=NA,
                       abso=NA,
                       Beta=NA,
                       GstarRef=NA, 
                       GstarHa=NA,
                       etacRef=NA,
                       etachd=NA,
                       etacS=NA,
                       etalRef=NA,
                       etalhd=NA,
                       etalS=NA,
                       phi1max=NA,
                       KcRef=	NA,
                       KcHa=	NA,
                       KcQ10=NA,
                       KoRef=	NA,
                       KoHa=	NA,
                       RdRef=NA,
                       RdHa=	NA,
                       RdHd= NA,
                       RdS=NA,
                       O2=NA
                       ){
  param=list(R=8.314,TRef=298.16,VcmaxRef=100,VcmaxHa	=65330,VcmaxHd	=149250,VcmaxS	=485,
             VqmaxRef=350,VqmaxHa=	43540,TpRef=9999,TpHa=53100,TpHd=150650,TpS=490,
             abso=0.85,Beta=0.52,GstarRef=42.75, GstarHa	=37830,etacRef=1,etachd=152040,etacS=495,etalRef=0.75,etalhd=152040,etalS=495,phi1max=0.96,
             KcRef=	404.9,KcHa=	79430,KoRef=	278.4,KoHa=	36380,
             RdRef=1.5,RdHa=46390,RdHd=150650,RdS=490,O2=210)
  param_fun=list(R=R,TRef=TRef,VcmaxRef=VcmaxRef,VcmaxHa=VcmaxHa,VcmaxHd	=VcmaxHd,VcmaxS	=VcmaxS,
             VqmaxRef=VqmaxRef,VqmaxHa=	VqmaxHa,TpRef=TpRef,TpHa=TpHa,TpHd=TpHd,TpS=TpS,
             abso=abso,Beta=Beta,GstarRef=GstarRef, GstarHa	=GstarHa,etacRef=etacRef,etachd=etachd,etacS=etacS,etalRef=etalRef,etalhd=etalhd,etalS=etalS,phi1max=phi1max,
             KcRef=	KcRef,KcHa=	KcHa,KoRef=	KoRef,KoHa=KoHa,
             RdRef=RdRef,RdHa=RdHa,RdHd=RdHd,RdS=RdS,O2=O2)
  modified=which(lapply(X=param_fun,FUN = is.na)==FALSE)
  if(length(modified)>0){
    for(i in 1: length(modified)){param[names(modified[i])]=param_fun[modified[i]]}
  }
  param_fun[names(param)]=param
  return(param_fun)
}

f.desactivation<-function(PRef,Hd,s,Tleaf,TRef=298.16,R=8.314){
  P=PRef*(1+exp((s*TRef-Hd)/(R*TRef)))/(1+exp((s*Tleaf-Hd)/(R*Tleaf)))
  return(P)
}

f.Aci_JB<-function(PFD,Tleaf,Ci,param){
  Kc=f.arrhenius(PRef = param[['KcRef']],Ha = param[['KcHa']],Tleaf=Tleaf)
  Ko=f.arrhenius(PRef = param[['KoRef']],Ha = param[['KoHa']],Tleaf=Tleaf)
  Gstar=f.arrhenius(PRef = param[['GstarRef']],Ha = param[['GstarHa']],Tleaf = Tleaf)
  
  ## Mitochondrial respiration
  Rd=f.modified.arrhenius(PRef=param[['RdRef']],Ha = param[['RdHa']],Hd = param[['RdHd']],s=param[['RdS']],Tleaf = Tleaf)
  
  Vcmax=f.modified.arrhenius(PRef=param[['VcmaxRef']],Ha = param[['VcmaxHa']],Hd = param[['VcmaxHd']],s = param[['VcmaxS']],Tleaf = Tleaf)
  etal=f.desactivation(PRef=param[['etalRef']],Hd = param[['etalhd']],s = param[['etalS']],Tleaf=Tleaf)
  etac=f.desactivation(PRef=param[['etacRef']],Hd = param[['etachd']],s = param[['etacS']],Tleaf=Tleaf)
  
  Vqmax=f.arrhenius(PRef=param[['VqmaxRef']],Ha = param[['VqmaxHa']],Tleaf = Tleaf)
  
  eta=1-etal/etac+(3+7*Gstar/Ci)/(4+8*Gstar/Ci) ## Eq 15 c
  
  Tp=f.modified.arrhenius(PRef=param[['TpRef']],param[['TpHa']],param[['TpHd']],param[['TpS']],Tleaf)
  
  alpha2=param[['abso']]*param[['Beta']]
  alpha1=param[['abso']]-alpha2

  JP700j=Vqmax*PFD/(Vqmax/(alpha1*param[['phi1max']])+PFD) ## Eq 30
  JP680j=JP700j/eta ## Eq 30
  
  Aj=JP680j/(4+8*Gstar/Ci)*(1-Gstar/Ci) ## Eq 31 without Rd
  Ac=Vcmax*Ci/(Ci+Kc*(1+param[['O2']]/Ko))*(1-Gstar/Ci) ## Eq 32 without Rd
  
  JP680c=Ac*(4+8*Gstar/Ci)/(1-Gstar/Ci) ##Eq 33a and 32
  JP700c=JP680c/eta
  
  JP700=pmin(JP700c,JP700j)## Johnson and Berry use a smoothing function, here I keep simple for now
  JP680=pmin(JP680c,JP680j)
  
  Ag=pmin(Ac,Aj)*as.numeric(Ci>Gstar)+ pmax(Ac,Aj)*as.numeric(Ci<=Gstar)
  An=Ag-Rd
  result=data.frame(A=An,Ag=Ag,Aj=Aj-Rd,Ac=Ac-Rd)
  return(result)
}


#' @title Fitting function for photosynthesis datadata (light curve or Aci curve)
#' @description Function to fit model to data. The parameters to fit have to be described in the list Start.
#' All the other parameters of the f.Aci functions have to be in param. If the parameters from Start are repeated in param, the later one will be ignored.
#' This function uses two methods to fit the data. First by minimizing the residual sum-of-squares of the residuals and then by maximizing the likelihood function. The first method is more robust but the second one allows to calculate the confident interval of the parameters.
#' @param measures Data frame of measures obtained from gas exchange analyser with at least the columns A, Ci, Qin and Tleaf (in K). If RHs, Tair, Patm, VPDleaf are also present, there mean will be added in the output, but those columns are not needed to estimate the parameters
#' @param id.name Name of the colums in measures with the identifier for the curve.
#' @param Start List of parameters to fit with their initial values.
#' @param param See f.make.param() for details.
#' @param modify.init TRUE or FALSE, allows to modify the Start values before fitting the data
#' @param do.plot TRUE or FALSE, plot data and fitted curves ?
#' @return Return a list with 3 components, 1 the result of the optim function which is used to estimate the parameters, 2 the output of the function bbmle, 3 the mean variable of the environment during the measurement
#' @export
#'
#' @examples ##Simulation of a CO2 curve
#' data=data.frame(Tleaf=rep(300,20),
#' Ci=seq(40,1500,75),Qin=rep(2000,20),Tair=300,RHs=70,VPDleaf=2,Patm=101,A=f.Aci_JB(PFD=2000,Tleaf=300,Ci=seq(40,1500,75),
#' param=f.make.param_JB())$A+rnorm(n = 20,mean = 0,sd = 0.5))
#'
#' f.fitting(measures=data,id.name=NULL,Start=list(JmaxRef=90,VcmaxRef=70,RdRef=1),param=f.make.param(TBM='FATES'))
f.fitting_JB<-function(measures,id.name=NULL,Start=list(VqmaxRef=90,VcmaxRef=70,RdRef=1),param=f.make.param_JB(),modify.init=TRUE,do.plot=TRUE,type='Aci'){
  Fixed=param[!names(param)%in%names(Start)]
  if(modify.init){
    if('VqmaxRef'%in%names(Start)){Start[['VqmaxRef']]=f.arrhenius.inv(P = 6*1.6*(max(measures$A,na.rm=TRUE)+1),Ha = param[['VqmaxHa']],Tleaf = mean(measures$Tleaf,na.rm=TRUE),TRef = param[['TRef']],R = param[['R']])}
    if('VqmaxRef'%in%names(Start)&'VcmaxRef'%in%names(Start)){Start[['VcmaxRef']]=Start[['VqmaxRef']]/2.5}
    grille=expand.grid(lapply(X = Start,FUN = function(x){x*c(0.2,1,2)}))
    grille.list=apply(X=grille,MARGIN = 1,FUN=as.list)
    value=9999999
    l_param=0
    for(l in 1:nrow(grille)){
      MoindresCarres=optim(par=grille.list[[l]],fn=f.SumSq_JB,data=measures,Fixed=Fixed)
      if(!is.null(MoindresCarres)&MoindresCarres$value<value){value=MoindresCarres$value;l_param=l}
    }
    Start=grille.list[[l_param]]
  }
  
  if(is.null(id.name)){name=''}else{name=unique(measures[,id.name])}
  MoindresCarres<-Estimation2<-NULL
  try({
    MoindresCarres<-optim(par=Start,fn=f.SumSq_JB,data=measures,Fixed=Fixed)
    print(MoindresCarres)
    print(paste('sd',sqrt(MoindresCarres$value/NROW(measures))))
    Start$sigma=sqrt(MoindresCarres$value/NROW(measures))
    for(l.name in names(MoindresCarres$par)){Start[l.name]=MoindresCarres$par[[l.name]]}
    for(l.name in names(MoindresCarres$par)){param[l.name]=MoindresCarres$par[[l.name]]}
    #if(do.plot){f.plot(measures=measures,name=name,param =param,list_legend = Start,type=type)}
  })
  
  try({
    Estimation2=mle2(minuslogl = f.MinusLogL_JB,start = Start,fixed = Fixed,data = list(data=measures))
    print(summary(Estimation2))
    #conf=confint(Estimation2)
    #print(conf)
    for(i in names(Estimation2@coef[names(Estimation2@coef)%in%names(param)])){param[i]=Estimation2@coef[i]}
    if(do.plot){f.plot_JB(measures=measures,name=name,param =param,list_legend = as.list(Estimation2@coef),type=type)}
  })
  Envir=NA
  try({
    Envir=c(Tair=mean(measures$Tair,na.rm=TRUE),Tleaf=mean(measures$Tleaf,na.rm=TRUE),RHs=mean(measures$RHs,na.rm=TRUE),VPDleaf=mean(measures$VPDleaf,na.rm=TRUE),Qin=mean(measures$Qin,na.rm=TRUE),Patm=mean(measures$Patm,na.rm=TRUE))
  })
  return(list(MoindresCarres,Estimation2,Envir))
}


f.MinusLogL_JB<-function(data,sigma,R=NA,TRef=NA,VcmaxRef=NA,
                         VcmaxHa	=NA,
                         VcmaxHd	=NA,
                         VcmaxS	=NA,
                         VqmaxRef=NA,
                         VqmaxHa=	NA,
                         TpRef=NA,
                         TpHa=NA,
                         TpHd=NA,
                         TpS=NA,
                         abso=NA,
                         Beta=NA,
                         GstarRef=NA, 
                         GstarHa=NA,
                         etacRef=NA,
                         etachd=NA,
                         etacS=NA,
                         etalRef=NA,
                         etalhd=NA,
                         etalS=NA,
                         phi1max=NA,
                         KcRef=	NA,
                         KcHa=	NA,
                         KcQ10=NA,
                         KoRef=	NA,
                         KoHa=	NA,
                         RdRef=NA,
                         RdHa=	NA,
                         RdHd= NA,
                         RdS=NA,
                         O2=NA
                      ){
  
  param=list(R=R,TRef=TRef,VcmaxRef=VcmaxRef,VcmaxHa=VcmaxHa,VcmaxHd	=VcmaxHd,VcmaxS	=VcmaxS,
             VqmaxRef=VqmaxRef,VqmaxHa=	VqmaxHa,TpRef=TpRef,TpHa=TpHa,TpHd=TpHd,TpS=TpS,
             abso=abso,Beta=Beta,GstarRef=GstarRef, GstarHa	=GstarHa,etacRef=etacRef,etachd=etachd,etacS=etacS,etalRef=etalRef,etalhd=etalhd,etalS=etalS,phi1max=phi1max,
             KcRef=	KcRef,KcHa=	KcHa,KoRef=	KoRef,KoHa=KoHa,
             RdRef=RdRef,RdHa=RdHa,RdHd=RdHd,RdS=RdS,O2=O2)
  A_pred=f.Aci_JB(Ci=data$Ci,PFD=data$Qin,Tleaf=data$Tleaf,param=param)
  
  y<-dnorm(x=data$A,mean=A_pred$A,sd=(sigma),log=TRUE)
  return(-sum(y))
}

f.SumSq_JB<-function(Fixed,data,Start){
  param=c(Fixed,Start)
  y<-data$A-f.Aci_JB(Ci=data$Ci,PFD=data$Qin,Tleaf=data$Tleaf,param=param)$A
  return(sum(y^2))
}


f.plot_JB<-function(measures=NULL,list_legend,param,name='',type='Aci'){
  # Plot all data points
  if(type=='Aci'){x=measures$Ci
  xlab=expression(italic(C)[i]~ppm)}
  if(type%in%c('Aq','AQ')){x=measures$Qin
  xlab=expression(italic(Q)['in']~mu*mol~m^-2~s^-1)}
  if(!type%in%c('Aci','AQ','Aq')){print('type should be Aci or Aq')}
  plot(x=x,y=measures$A, main=name, xlab=xlab, ylab=expression(italic(A)~mu*mol~m^-2~s^-1),ylim=c(min(measures$A,na.rm = TRUE),1.15*max(measures$A,na.rm = TRUE)))
  if(!is.null(list_legend)){
    list_legend=list_legend[order(names(list_legend))]
    legend("bottomright",legend=mapply(FUN = function(x, i){paste(i,'=', round(x,2))}, list_legend, names(list_legend)),bty="n",cex=1)
  }
  legend("topleft",legend=c(expression(italic(A)[c]),expression(italic(A)[j]),expression(italic(A)[p]),expression(italic(A)),"Obs"),lty=c(2,2,2,1,0),
         pch=c(NA,NA,NA,NA,21),
         col=c("dark blue","dark red","dark green","dark grey","black"),bty="n",lwd=c(2,2,2,1,1),
         seg.len=2,cex=1,pt.cex=1)
  result=f.Aci_JB(Ci=measures$Ci,Tleaf=measures$Tleaf,PFD=measures$Qin,param=param)
  lines(x=x,y=result$A,col="dark grey",lwd=1)
  lines(x=x,y=result$Ac,lwd=2,col="dark blue",lty=2)
  lines(x=x,y=result$Aj,lwd=2,col="dark red",lty=2)
  box(lwd=1)
}



##### Test
data=data.frame(Tleaf=rep(300,20),
                Ci=seq(40,1500,75),
                Qin=rep(2000,20),
                Tair=300,RHs=70,
                VPDleaf=2,Patm=101,
                A=f.Aci_JB(PFD=2000,Tleaf=300,Ci=seq(40,1500,75),
                           param=f.make.param_JB())$A+rnorm(n = 20,mean = 0,sd = 0.5))

f.fitting_JB(measures=data,id.name=NULL,Start=list(VqmaxRef=90,VcmaxRef=70,RdRef=1),param=f.make.param_JB())
