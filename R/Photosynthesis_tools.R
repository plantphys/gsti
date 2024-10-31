library(bbmle)
library(readxl)

## The code below was adapted from the LeafGasExchange package (Lamour & Serbin, 2021) 
## available on github: https://github.com/TESTgroup-BNL/LeafGasExchange
## More information is given on the package github.
## Note that Rd was renamed Rday and Tp was renamed TPU in this code
## ci was renamed in Ci


#' @title Arrhenius function to calculate the temperature effect on some parameters
#' @param PRef Value of the parameter at the reference temperature
#' @param TRef Reference temperature
#' @param Ha Enthalpie of activation in J.mol-1
#' @param Tleaf Temperature of the leaf in Kelvin
#' @param R Ideal gas constant
#'
#' @return Value of the parameter at the temperature of the leaf
#' @export
#' @references VON CAEMMERER, S. (2013), Steady state models of photosynthesis. Plant Cell Environ, 36: 1617-1630. doi:10.1111/pce.12098
#'  Bernacchi, C.J., Singsaas, E.L., Pimentel, C., Portis Jr, A.R. and Long, S.P. (2001), Improved temperature response functions for models of Rubisco‐limited photosynthesis. Plant, Cell & Environment, 24: 253-259. doi:10.1111/j.1365-3040.2001.00668.x
#' @examples plot(x=seq(25,35,0.1),y=f.arrhenius(PRef=1,Ha=46390,Tleaf=seq(273.15+25,273.15+35,0.1),R=8.314),xlab='Temperature degree C',ylab='Rday')

f.arrhenius<-function(PRef,Ha,Tleaf,TRef=298.16,R=8.314){
  P=PRef*exp(Ha/(R*TRef)-Ha/(R*Tleaf))
  return(P)
}

#' @title Temperature dependence of Gamma star, Ko, Kc and Rday
#' @details Retrieve the value of the parameter at TRef knowing its value at Tleaf
#' @inheritParams f.arrhenius
#' @param P Value of the parameter at Tleaf
#' @return
#' @export
#'
#' @examples
f.arrhenius.inv<-function(P,Ha,Tleaf,TRef=298.16,R=8.314){
  PRef=P/exp(Ha/(R*TRef)-Ha/(R*Tleaf))
  return(PRef)
}

#' @title Temperature dependence of Jmax and Vcmax
#' @description The temperature dependence of the photosynthetic parameters Vcmax, the maximum catalytic rate of the enzyme Rubisco, and Jmax, the maximum electron transport rate is modelled by a modified Arrehenius equation. It is modified to account for decreases in each parameter at high temperatures.
#' @param PRef Value of the parameter, here Vcmax or Jmax, at the reference temperature in micromol.m-2.s-1
#' @param Ha Energy of activation in J.mol-1
#' @param Hd Energy of desactivation in J.mol-1
#' @param s Entropy term in J.mol-1.K-1
#' @param Tleaf Temperature of the leaf in Kelvin
#' @param TRef Reference temperature
#' @param R Ideal gas constant
#'
#' @return Value of the parameter Jmax or Vcmax at a given temperature
#' @references Leuning, R. (2002), Temperature dependence of two parameters in a photosynthesis model. Plant, Cell & Environment, 25: 1205-1210. doi:10.1046/j.1365-3040.2002.00898.x
#' @export
#'
#' @examples plot(x=seq(25,35,0.1),y=f.modified.arrhenius(PRef=50,Ha=73637,Hd=149252,s=486,Tleaf=seq(273.15+25,273.15+35,0.1)),xlab='Temperature degree C',ylab='Vcmax')
f.modified.arrhenius<-function(PRef,Ha,Hd,s,Tleaf,TRef=298.16,R=8.314){
  P=PRef*(1+exp((s*TRef-Hd)/(R*TRef)))*exp(Ha/(R*TRef)*(1-TRef/Tleaf))/(1+exp((s*Tleaf-Hd)/(R*Tleaf)))
  return(P)
}

#' @title Temperature dependence of Jmax and Vcmax
#' @description Retrieve the reference temperature value of a parameter knowing its value at Tleaf
#' @param P Value of the parameter, here Vcmax or Jmax, at the leaf temperature in micromol.m-2.s-1
#' @inheritParams f.modified.arrhenius
#'
#' @return
#' @export
#'
#' @examples
f.modified.arrhenius.inv<-function(P,Ha,Hd,s,Tleaf,TRef=298.16,R=8.314){
  PRef=P/(1+exp((s*TRef-Hd)/(R*TRef)))/exp(Ha/(R*TRef)*(1-TRef/Tleaf))*(1+exp((s*Tleaf-Hd)/(R*Tleaf)))
  return(PRef)
}

#' @title Photosynthesis model parameters
#' @description Function to create a list of parameters to be used in most of the functions of this package.
#' @details The call of this function is made using f.make.param(). If a parameter is modified for example writting f.make.param(VcmaxRef=10), this function will return all the default parameters from FATES TBM with VcmaxRef = 10 instead of its default value
#' @param R Ideal gas constant
#' @param O2 O2 concentration in ppm
#' @param TRef Reference temperature for Kc, Ko, Rday,GammaStar Vcmax, Jmax
#' @param Patm Atmospheric pressure in kPa
#' @param JmaxRef Maximum electron transport rate in micromol.m-2.s-1
#' @param JmaxHa Energy of activation for Jmax in J.mol-1
#' @param JmaxHd Energy of desactivation for Jmax in J.mol-1
#' @param JmaxS Entropy term for Jmax in J.mol-1.K-1
#' @param VcmaxRef Maximum rate of Rubisco for carboxylation micromol.m-2.s-1
#' @param VcmaxHa Energy of activation for Vcmax in J.mol-1
#' @param VcmaxHd Energy of desactivation for Vcmax in J.mol-1
#' @param VcmaxS Entropy term for Vcmax in J.mol-1.K-1
#' @param TPURef Triose Phosphate Utilization rate in micromol.m-2.s-1
#' @param TPUHa Energy of activation for TPU in J.mol-1
#' @param TPUHd Energy of desactivation for TPU in J.mol-1
#' @param TPUS Entropy term for TPU in J.mol-1.K-1
#' @param thetacj Smoothing factor of the collatz equation between Ac and Aj limitations
#' @param thetaip Smoothing factor of the collatz equation between Aj and Ap limitations
#' @param RdayRef Respiration value at the reference temperature
#' @param RdayHa Energie of activation for Rday in J.mol-1
#' @param KcRef Michaelis-Menten constant of Rubisco for CO2 at the reference temperature in micromol.mol-1
#' @param KcHa Energy of activation for Kc in J.mol-1
#' @param KoRef ichaelis-Menten constant of Rubisco for CO2 at the reference temperature in milimol.mol-1
#' @param KoHa Energy of activation for Ko in J.mol-1
#' @param GstarRef CO2 compensation point in absence of respiration in micromol.mol-1
#' @param GstarHa Enthalpie of activation for Gstar in J.mol-1
#' @param abso Absorptance of the leaf in the photosynthetic active radiation wavelenghts
#' @param aQY Apparent quantum yield
#' @param Theta Theta is the empirical curvacture factor for the response of J to PFD. It takes its values between 0 and 1.
#' @return List of parameters that can be used in f.A
#' @references Bernacchi, C.J., Singsaas, E.L., Pimentel, C., Portis Jr, A.R. and Long, S.P. (2001), Improved temperature response functions for models of Rubisco‐limited photosynthesis. Plant, Cell & Environment, 24: 253-259. doi:10.1111/j.1365-3040.2001.00668.x
#' CLM4.5: http://www.cesm.ucar.edu/models/cesm2/land/CLM45_Tech_Note.pdf
#' ORCHIDEE: https://forge.ipsl.jussieu.fr/orchidee/wiki/Documentation/OrchideeParameters AND https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2003GB002199
#' JULES: https://www.geosci-model-dev.net/4/701/2011/gmd-4-701-2011.pdf
#' FATES: https://fates-docs.readthedocs.io/en/latest/fates_tech_note.html#
#' Medlyn, B.E., Duursma, R.A., Eamus, D., Ellsworth, D.S., Colin Prentice, I., Barton, C.V.M., Crous, K.Y., de Angelis, P., Freeman, M. and Wingate, L. (2012), Reconciling the optimal and empirical approaches to modelling stomatal conductance. Glob Change Biol, 18: 3476-3476. doi:10.1111/j.1365-2486.2012.02790.x
#' Leuning, R., Kelliher, F. M., De Pury, D. G. G., & Schulze, E. D. (1995). Leaf nitrogen, photosynthesis, conductance and transpiration: scaling from leaves to canopies. Plant, Cell & Environment, 18(10), 1183-1200.
#' Ball, J. T., Woodrow, I. E., & Berry, J. A. (1987). A model predicting stomatal conductance and its contribution to the control of photosynthesis under different environmental conditions. In Progress in photosynthesis research (pp. 221-224). Springer, Dordrecht.

#' @export
#'
#' @examples param1=f.make.param(JmaxRef=100,VcmaxRef=60,RdayRef=1,TPURef=10)

f.make.param<-function(R=NA,O2=NA,TRef=NA,
                       Patm=NA,JmaxRef=	NA,
                       JmaxHa=	NA,
                       JmaxHd=	NA,
                       JmaxS= NA,
                       VcmaxRef=NA,
                       VcmaxHa	=NA,
                       VcmaxHd	=NA,
                       VcmaxS	=NA,
                       TPURef=NA,
                       TPUHa=NA,
                       TPUHd=NA,
                       TPUS=NA,
                       thetacj=NA,
                       thetaip=NA,
                       RdayRef=	NA,
                       RdayHa=	NA,
                       RdayHd=NA,
                       RdayS=NA,
                       KcRef=	NA,
                       KcHa=	NA,
                       KoRef=	NA,
                       KoHa=	NA,
                       GstarRef= NA,
                       GstarHa	=NA,
                       abso=	NA,
                       aQY=NA,
                       Theta=NA
                       ){
  
  ## Default parameters
    param=list(R=8.314,O2=210,TRef=298.16,Patm=101,
               JmaxRef=	83.5,JmaxHa=	43540,JmaxHd=	152040,JmaxS	=495,
               VcmaxRef=	50,VcmaxHa	=65330,VcmaxHd	=149250,VcmaxS	=485,
               TPURef=1/6*50,TPUHa=53100,TPUHd=150650,TPUS=490,
               thetacj=0.999,thetaip=0.999,
               RdayRef=	1.43,RdayHa=	46390,RdayHd=150650,RdayS=490,
               KcRef=	404.9,KcHa=	79430,KoRef=	278.4,KoHa=	36380,GstarRef=	42.75,GstarHa	=37830,
               abso=	0.85,aQY=	0.425,Theta=(0.7))
  
  ## Param modified in the call of the function by the user (default is NA if the user dont modify the parameters)
  param_fun=list(R=R,O2=O2,TRef=TRef,Patm=Patm,JmaxRef=JmaxRef,JmaxHa=	JmaxHa,
                 JmaxHd=	JmaxHd,JmaxS	=JmaxS,VcmaxRef=VcmaxRef,VcmaxHa	= VcmaxHa,VcmaxHd	=VcmaxHd,
                 VcmaxS	=VcmaxS,
                 TPURef=TPURef,TPUHa=TPUHa,TPUHd=TPUHd,TPUS=TPUS,
                 thetacj=thetacj,thetaip=thetaip,
                 RdayRef=RdayRef,RdayHa=RdayHa, RdayHd=RdayHd,RdayS=RdayS,
                 KcRef= KcRef,KcHa=	KcHa,KoRef=KoRef,KoHa=	KoHa,GstarRef=	GstarRef,
                 GstarHa	=GstarHa,abso=	abso,aQY=aQY,Theta=Theta)
  ## Finding modified parameters if any in param_fun
  modified=which(lapply(X=param_fun,FUN = is.na)==FALSE)
  ## Modifying the defaut parametrization with the user inputs:
  if(length(modified)>=1){
    for(i in 1: length(modified)){
      param[names(modified[i])]=param_fun[modified[i]]}
  }
  param_fun[names(param)]=param
  return(param_fun)
}

#' @title Photosynthesis model
#' @description Calculate the CO2 assimilation according to Farquhar, von Caemmerer and Berry (1980) equations for C3 species.
#' @inheritParams f.make.param
#' @param param List of parameters, see f.make.param for details
#' @param PFD Photosynthetic flux density (i.e light) at the surface of the leaf, micro mol m-2 s-1
#' @param Ci Intercellular CO2 concentration, ppm or micro mol mol-1
#' @param Tleaf Leaf temperature in Kelvin
#' @return The function returns a dataframe with as columns:
#'    - A, the net photosynthesis rate, micro mol m-2 s-1
#'    - Ac, the potential rate of photosynthesis limited by the rubisco carboxylation rate, micro mol m-2 s-1
#'    - Aj, the potential rate of photosynthesis limited by the electron transport rate, micro mol m-2 s-1
#'    - Ap, the potential rate of photosynthesis limited by the triose phosphate utilization rate, micro mol m-2 s-1
#'    - Ag, the gross photosynthesis rate, i.e, without accounting for the respiration, micro mol m-2 s-1
#' @export
#'
#' @examples Ci=seq(40,1500,10)
#' plot(x=Ci,y=f.ACi(PFD=2000,Ci=Ci,Tleaf=300,param=f.make.param())$A,xlab="Ci micromol m-2 s-1",ylab = "A micromol m-2 s-1")
f.ACi<-function(PFD,Ci,Tleaf,param=f.make.param()){
  ## Calculating the temperature dependence of the photosynthetic parameters:
  Kc=f.arrhenius(param[['KcRef']],param[['KcHa']],Tleaf)
  Ko=f.arrhenius(param[['KoRef']],param[['KoHa']],Tleaf)
  Gstar=f.arrhenius(param[['GstarRef']],param[['GstarHa']],Tleaf)
  
  Rday=f.modified.arrhenius(PRef=param[['RdayRef']],param[['RdayHa']],param[['RdayHd']],param[['RdayS']],Tleaf)
  Vcmax=f.modified.arrhenius(PRef=param[['VcmaxRef']],param[['VcmaxHa']],param[['VcmaxHd']],param[['VcmaxS']],Tleaf)
  Jmax=f.modified.arrhenius(PRef=param[['JmaxRef']],param[['JmaxHa']],param[['JmaxHd']],param[['JmaxS']],Tleaf)
  TPU=f.modified.arrhenius(PRef=param[['TPURef']],param[['TPUHa']],param[['TPUHd']],param[['TPUS']],Tleaf)
  
  ## Calculating the electron transport rate
  I2=PFD*param[['abso']]*(param[['aQY']])
  J=(I2+Jmax-((I2+Jmax)^2-4*(param[['Theta']])*I2*Jmax)^0.5)/(2*(param[['Theta']]))
  
  ## Calculating the different photosynthesis limiting rates Wc, Wj, and Wp
  Wp=3*TPU
  Wc=Vcmax*(Ci-Gstar)/(Ci+Kc*(1+param[['O2']]/Ko))
  Wj=J/4*(Ci-Gstar)/(Ci+2*Gstar)
  
  ## Smoothing the transitions between photosynthesis limitations
  Ai=f.smooth(A1 = Wc,A2 = Wj,theta=param[['thetacj']])*as.numeric(Ci>Gstar)+f.smooth(A1 = Wc,A2 = Wj,theta=param[['thetacj']],root = 2)*as.numeric(Ci<=Gstar)
  A=f.smooth(A1=Ai,A2=Wp,theta=param[['thetaip']])-Rday
 
  result=data.frame(A=A,Ac=Wc-Rday,Aj=Wj-Rday,Ap=Wp-Rday,Ag=A+Rday)
  return(result)
}


#' @title Smoothing functions between photosynthesis limitations (for example between rubisco carboxylation and light limitation)
#' @param A1
#' @param A2
#' @param theta Smoothing factor
#' @return Smoothed value
#' @export
#'
#' @examples A1= seq(0,20,1)
#' A2= seq(9,11,2/20)
#' Asmooth=f.smooth(A1=A1,A2=A2,theta=0.99)
#' plot(A1,type='l')
#' lines(A2)
#' lines(Asmooth,col='blue')
f.smooth=function(A1,A2,theta,root=1){
  if(root==1){sol=((A1+A2)-sqrt((A1+A2)^2-4*theta*A1*A2))/(2*theta)}else{sol=((A1+A2)+sqrt((A1+A2)^2-4*theta*A1*A2))/(2*theta)}
  return(sol)
}

#' @title Plot data and model
#' @description Plot a generic graphic with observed data and predictions. Be careful to sort the data.frame beforehand.
#' @param measures Data frame obtained from CO2 or light curve with at least columns A, Ci, Qin and Tleaf
#' Data frame obtained from CO2 or light curve with at least columns A, Ci, Qin and Tleaf
#' @param type Type of the curve to plot (light curve: AQ or CO2 curve ACi)
#' @param list_legend Named list where the name and values will appear in the legend
#' @inheritParams f.A
#' @param name Name of the curve to be displayed
#'
#' @return Plot a figure
#' @export
#'
#' @examples
#' param=f.make.param()
#' A=f.ACi(PFD=2000,Tleaf=300,Ci=seq(40,1500,50),param=param)$A+rnorm(n = 30,mean = 0,sd = 0.5)
#' data=data.frame(Tleaf=rep(300,30),Ci=seq(40,1500,50),Qin=rep(2000,30),A=A)
#' f.plot(measures=data,param=param,list_legend=param['VcmaxRef'],name='Example 01',type='ACi')

f.plot<-function(measures=NULL,list_legend,param,name='',type='ACi'){
  # Plot all data points
  if(type=='ACi'){x=measures$Ci
  xlab=expression(italic(C)[i]~ppm)}
  if(type%in%c('Aq','AQ')){x=measures$Qin
  xlab=expression(italic(Q)['in']~mu*mol~m^-2~s^-1)}
  if(!type%in%c('ACi','AQ','Aq')){print('type should be ACi or Aq')}
  plot(x=x,y=measures$A, main=name, xlab=xlab, ylab=expression(italic(A)~mu*mol~m^-2~s^-1),ylim=c(min(measures$A,na.rm = TRUE),1.15*max(measures$A,na.rm = TRUE)))
  if(!is.null(list_legend)){
    list_legend=list_legend[order(names(list_legend))]
    legend("bottomright",legend=mapply(FUN = function(x, i){paste(i,'=', round(x,2))}, list_legend, names(list_legend)),bty="n",cex=1)
  }
  legend("topleft",legend=c(expression(italic(A)[c]),expression(italic(A)[j]),expression(italic(A)[p]),expression(italic(A)),"Obs"),lty=c(2,2,2,1,0),
         pch=c(NA,NA,NA,NA,21),
         col=c("dark blue","dark red","dark green","dark grey","black"),bty="n",lwd=c(2,2,2,1,1),
         seg.len=2,cex=1,pt.cex=1)
  result=f.ACi(Ci=measures$Ci,Tleaf=measures$Tleaf,PFD=measures$Qin,param=param)
  lines(x=x,y=result$A,col="dark grey",lwd=1)
  lines(x=x,y=result$Ac,lwd=2,col="dark blue",lty=2)
  lines(x=x,y=result$Aj,lwd=2,col="dark red",lty=2)
  lines(x=x,y=result$Ap,lwd=2,col="dark green",lty=2)
  box(lwd=1)
}


#' @title Compute the sum square of the difference between obervations and predictions
#' @description Function used to fit the parameters of a CO2 curve
#' @param x List of parameters to fit
#' @param data Data frame obtained from CO2 curve with at least columns A, Ci, Qin and Tleaf
#' @keywords internal
#' @return Sum square of the difference between predictions and observations
#' @export
#'
#' @examples
f.SumSq<-function(Fixed,data,Start){
  param=c(Fixed,Start)
  y<-data$A-f.ACi(Ci=data$Ci,PFD=data$Qin,Tleaf=data$Tleaf,param=param)$A
  return(sum(y^2))
}

#' Title
#'
#' @inheritParams f.make.param
#' @param sigma Sigma value
#' @return
#' @export
#' @keywords internal
#'
#' @examples
f.MinusLogL<-function(data,sigma,R=0.75,O2=0.75,TRef=0.75,
                      Patm=0.75,JmaxRef=	0.75,
                      JmaxHa=	0.75,
                      JmaxHd=	0.75,
                      JmaxS= 0.75,
                      VcmaxRef=0.75,
                      VcmaxHa	=0.75,
                      VcmaxHd	=0.75,
                      VcmaxS	=0.75,
                      TPURef=0.75,
                      TPUHa=0.75,
                      TPUHd=0.75,
                      TPUS=0.75,
                      thetacj=0.75,
                      thetaip=0.75,
                      RdayRef=	0.75,
                      RdayHa=	0.75,
                      RdayHd=0.75,
                      RdayS=0.75,
                      KcRef=	0.75,
                      KcHa=	0.75,
                      KoRef=	0.75,
                      KoHa=	0.75,
                      GstarRef= 0.75,
                      GstarHa	=0.75,
                      abso=	0.75,
                      aQY=0.75,
                      Theta=0.75){
  
  param=list(R=R,O2=O2,TRef=TRef,Patm=Patm,JmaxRef=JmaxRef,JmaxHa=	JmaxHa,
             JmaxHd=	JmaxHd,JmaxS	=JmaxS,VcmaxRef=VcmaxRef,VcmaxHa	= VcmaxHa,VcmaxHd	=VcmaxHd,
             VcmaxS	=VcmaxS,
             TPURef=TPURef,TPUHa=TPUHa,TPUHd=TPUHd,TPUS=TPUS,
             thetacj=thetacj,thetaip=thetaip,
             RdayRef=RdayRef,RdayHa=RdayHa, RdayHd=RdayHd,RdayS=RdayS,
             KcRef= KcRef,KcHa=	KcHa,KoRef=KoRef,KoHa=KoHa,GstarRef=	GstarRef,
             GstarHa	=GstarHa,abso=	abso,aQY=aQY,Theta=Theta)
  A_pred=f.ACi(Ci=data$Ci,PFD=data$Qin,Tleaf=data$Tleaf,param=param)
  
  y<-dnorm(x=data$A,mean=A_pred$A,sd=(sigma),log=TRUE)
  return(-sum(y))
}

#' @title Fitting function for photosynthesis datadata (light curve or ACi curve)
#' @description Function to fit the C3 photosynthesis model to the data. The parameters to estimate have to be listed in the list Start, with approximate initializing values.
#' All the other parameters of the f.ACi functions have to be listed in the variable param. If the parameters from Start are repeated in param, the later one will be ignored.
#' This function uses two methods to fit the data. First by minimizing the residual sum-of-squares and then by maximizing the likelihood function. The first method is more robust but the second one allows to calculate the confidence interval of the parameters.
#' @param measures Data frame of measures obtained from gas exchange analyser with at least the columns A, Ci, Qin and Tleaf in Kelvin. If RHs, Tair, Patm, VPDleaf are also present, there mean will be added in the output, but those columns are not needed to estimate the parameters
#' @param id.name Name of the columns in measures with the identifier for the curve.
#' @param Start List of parameters to fit with their initial values.
#' @param param See f.make.param() for details.
#' @param modify.init TRUE or FALSE, allows to modify the Start values before fitting the data
#' @param do.plot TRUE or FALSE, plot data and fitted curves ?
#' @return Return a list with 3 components, 1 the result of the optim function which is used to estimate the parameters, 2 the output of the function bbmle, 3 the mean variable of the environment during the measurement
#' @export
#'
#' @examples ##Simulation of a CO2 curve
#' data=data.frame(Tleaf=rep(300,20),
#' Ci=seq(40,1500,75),Qin=rep(2000,20),Tair=300,RHs=70,VPDleaf=2,Patm=101,A=f.ACi(PFD=2000,Tleaf=300,Ci=seq(40,1500,75),
#' param=f.make.param())$A+rnorm(n = 20,mean = 0,sd = 0.5))
#'
#' f.fitting(measures=data,id.name=NULL,Start=list(JmaxRef=90,VcmaxRef=70,RdayRef=1),param=f.make.param())
f.fitting<-function(measures,id.name=NULL,Start=list(JmaxRef=90,VcmaxRef=70,RdayRef=1),param=f.make.param(),modify.init=TRUE,do.plot=TRUE,type='ACi'){
  Fixed=param[!names(param)%in%names(Start)]
  
  ## Here I use some empirical tricks to create a list of initial values for the estimated parameters that span a large range of possible values
  ## so we increase the chance to find a good solution and not a local minimum
  if(modify.init){
    if('JmaxRef'%in%names(Start)){Start[['JmaxRef']]=f.modified.arrhenius.inv(P = 6*(max(measures$A,na.rm=TRUE)+1),Ha = param[['JmaxHa']],Hd = param[['JmaxHd']],s = param[['JmaxS']],Tleaf = mean(measures$Tleaf,na.rm=TRUE),TRef = param[['TRef']],R = param[['R']])}
    if('JmaxRef'%in%names(Start)&'VcmaxRef'%in%names(Start)){Start[['VcmaxRef']]=Start[['JmaxRef']]/2}
    grille=expand.grid(lapply(X = Start,FUN = function(x){x*c(0.2,1,2)}))
    grille.list=apply(X=grille,MARGIN = 1,FUN=as.list)
    value=9999999
    l_param=0
    for(l in 1:nrow(grille)){
      MoindresCarres=optim(par=grille.list[[l]],fn=f.SumSq,data=measures,Fixed=Fixed)
      if(!is.null(MoindresCarres)&MoindresCarres$value<value){value=MoindresCarres$value;l_param=l}
    }
    Start=grille.list[[l_param]]
  }
  
  if(is.null(id.name)){name=''}else{name=unique(measures[,id.name])}
  MoindresCarres<-Estimation2<-NULL
  try({
    MoindresCarres<-optim(par=Start,fn=f.SumSq,data=measures,Fixed=Fixed)
    print(MoindresCarres)
    print(paste('sd',sqrt(MoindresCarres$value/NROW(measures))))
    Start$sigma=sqrt(MoindresCarres$value/NROW(measures))
    for(l.name in names(MoindresCarres$par)){Start[l.name]=MoindresCarres$par[[l.name]]}
    for(l.name in names(MoindresCarres$par)){param[l.name]=MoindresCarres$par[[l.name]]}
    #if(do.plot){f.plot(measures=measures,name=name,param =param,list_legend = Start,type=type)}
  })
  
  try({
    Estimation2=mle2(minuslogl = f.MinusLogL,start = Start,fixed = Fixed,data = list(data=measures))
    print(summary(Estimation2))
    #conf=confint(Estimation2)
    #print(conf)
    for(i in names(Estimation2@coef[names(Estimation2@coef)%in%names(param)])){param[i]=Estimation2@coef[i]}
    if(do.plot){f.plot(measures=measures,name=name,param =param,list_legend = as.list(Estimation2@coef),type=type)}
  })
  
  ## Here, I compute the average environmental conditions during the curve 
  Envir=NA
  try({
    Envir=c(Tair=mean(measures$Tair,na.rm=TRUE),Tleaf=mean(measures$Tleaf,na.rm=TRUE),RHs=mean(measures$RHs,na.rm=TRUE),VPDleaf=mean(measures$VPDleaf,na.rm=TRUE),Qin=mean(measures$Qin,na.rm=TRUE),Patm=mean(measures$Patm,na.rm=TRUE))
  })
  return(list(MoindresCarres,Estimation2,Envir))
}


#' @title Import Licor 6400 file
#' @description This functions allows to import the text file produced by LICOR as a data.frame
#' @param file File to import by the function
#' @param column_display The first lines of the file which are part of this list are displayed by this function after being imported.
#' @references Adapted from https://ericrscott.com/posts/2018-01-17-li-cor-wrangling/index.html#tidying-up-raw-text
#' @return dataframe
#' @export
#'
#' @examples
f.import_licor6400<-function(file,column_display=c('Photo','Cond','PARi','Ci','Leaf_Barcode','Species','Tree Canopy','Age','file')){
  print(file)
  header_pattern <- "\"OPEN \\d\\.\\d\\.\\d"
  data_pattern <- "\\$STARTOFDATA\\$"
  text.raw <- readr::read_file(file)
  #splits into individual bouts
  raw_split <- stringr::str_split(text.raw, header_pattern, simplify = TRUE)
  
  #splits further to separate headers from actual data
  raw_split2 <- stringr::str_split(raw_split, data_pattern, simplify = FALSE)
  
  #extract just the second element, the actual data
  raw_split3 <- raw_split2 %>%
    map(`[`, 2) %>% #equivalent to doing raw_split2[[i]][2] for every element "i"
    flatten_chr() #converts to a vector
  
  #remove empty elements
  raw_split3 <- raw_split3[!is.na(raw_split3)]
  
  input <- raw_split3 %>%
    map(read_tsv, skip = 1)
  
  input.all <-do.call('rbind',lapply(X=input,FUN = function(x){x[as.vector(!is.na(x[,'HHMMSS'])),]}))#Supress comments
  imported=as.data.frame(input.all)
  imported=cbind(imported,file=rep(file,nrow(imported)))
  print(head(imported[,column_display]))
  return(imported)
}


#' @title Import Licor 6800 file
#' @description This functions allows to import the excel files produced by LICOR as a data.frame.
#' IMPORTANT: The excel files must be opened and saved before using this function (the Excel calculations are not done until the file is open, so the calculated colums will show 0s if not saved before being imported)
#' @param nskip_header Number of lines to skip in the Excel files to find the column names
#' @param nskip_data Number of lines to skip in the Excel files to find the data
#' @param do.print Print the 5 top lines of the file?
#' @param file File path
#' @param column_display Column you want to display after the import to verify if it worked correctly
#'
#' @examples
f.import_licor6800<-function(nskip_header=16,nskip_data=18,do.print=TRUE,file,column_display=c('A','gsw','Qin','Ci','Species','Canopy','Pheno_Age','Barcode','file')){
  if(do.print){print(file)}
  header=make.names(as.data.frame(readxl::read_excel(path = file,skip = nskip_header,n_max = 1,.name_repair = 'minimal',col_names = FALSE)))##'minimal' to speed up the import
  data_6800=as.data.frame(readxl::read_excel(path = file,skip = nskip_data,col_names = header,.name_repair = 'minimal'))
  data_6800[,'date']=data_6800[1,'date']
  data_6800=cbind(data_6800,file=rep(file,nrow(data_6800)))
  if(do.print){print(head(data_6800[,column_display]))}
  if(all(data_6800$A==0)){print(paste('Open and save the file first',file))}
  return(data_6800)
}
