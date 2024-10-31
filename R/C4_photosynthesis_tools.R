#######################################################################
### This code lists several functions for the modeling and fitting  ###
### of C4 photosynthesis. It is similar to the C3 code with the     ###
### same functions called with the same name appended with .C4      ###
### This code also uses the generic function for the C3             ###
### photosynthesis model (example Arrhenius functions for the       ###
### temperature dependence so the C3 functions need to be           ###
### loaded first                                                    ###
#######################################################################


#' @param Kc25 Michaelis constant of Rubisco for CO2 at 25°C in micromol.mol-1
#' @param O2 O2 concentration in ppm
#' @param KcHa Energy of activation for Kc in J.mol-1
#' @param Ko25 Michaelis constant of Rubisco for O2 at 25°C in milimol.mol-1
#' @param KoHa Energy of activation for Ko in J.mol-1
#' @param Kpc25 Michaelis constant of PEP carboxylase for CO2 at 25°C in micromol.mol-1
#' @param KpcHa Energy of activation for Kpc in J.mol-1
#' @param Vpmax25 Maximum rate of PEP carboxylation micromol in m-2.s-1
#' @param VpmaxHa Energy of activation for PEP carboxylation in J.mol-1
#' @param Jmax25 Maximum electron transport rate in micromol.m-2.s-1
#' @param JmaxHa Energy of activation for Jmax in J.mol-1
#' @param JmaxHd Energy of desactivation for Jmax in J.mol-1
#' @param JmaxS Entropy term for Jmax in J.mol-1.K-1
#' @param Vcmax25 Maximum rate of Rubisco for carboxylation in micromol.m-2.s-1
#' @param VcmaxHa Energy of activation for Vcmax in J.mol-1
#' @param Rday25 Respiration value at the reference temperature
#' @param RdayHa Energie of activation for Rday in J.mol-1
#' @param gammastar25 Half the reciprocal of Rubisco specificity
#' @param gammastarHa Energy of activation for gammastar in J.mol-1
#' @param gbs Bundle sheath conductance to CO2 in mol.m-2.s-1
#' @param ao25 Ratio of solubility and diffusivity of O2 to CO2 at 25°C
#' @param aoHa Energy of activation for ao in J.mol-1
#' @param Vpr PEP regeneration rate in micromol.m-2.s-1
#' @param fRdRm Fraction of Rday respiration that happens in the mesophyll
#' @param Fraction of PSII activity in the bundle sheath
#' @param Absorptance of the leaf in the photosynthetic active radiation wavelenghts
#' @param f Correction factor for the spectral quality of the light
#' @param fcyc Fraction of cyclic electron transport
#' @param Theta Theta is the empirical curvacture factor for the response of J to PFD
#' @param h Number of protons required per ATP generated
#' @param x Partitioning factor of electron transport rate
f.make.param.C4 <- function(O2= NA,
                            Kc25 = NA,
                            KcHa = NA,
                            Ko25 = NA,
                            KoHa = NA,
                            Kpc25 = NA,
                            KpcHa = NA,
                            Vpmax25 = NA,
                            VpmaxHa = NA,
                            Jmax25 = NA,
                            JmaxHa = NA,
                            JmaxHd = NA,
                            JmaxS = NA,
                            Vcmax25 = NA,
                            VcmaxHa = NA,
                            gammastar25 = NA,
                            gammastarHa = NA,
                            gbs = NA,
                            ao25 = NA,
                            aoHa = NA,
                            Vpr = NA,
                            fRdRm = NA,
                            Rday25 = NA,
                            RdayHa = NA,
                            alpha = NA,
                            abso = NA,
                            fcyc = NA,
                            f = NA,
                            Theta = NA,
                            h = NA,
                            x = NA) {
  ## Default parameters (Reference: Susanne von Caemmerer, Updating the steady-state model of C4 photosynthesis, Journal of Experimental Botany, Volume 72, Issue 17, 2 September 2021, Pages 6003–6017, https://doi.org/10.1093/jxb/erab266))
  param=list(O2 = 210, Kc25 = 1210,KcHa = 64200,Ko25 = 292, KoHa = 10500,Kpc25 = 82, KpcHa = 38300, 
             Vpmax25 = 200, VpmaxHa = 50100, Jmax25 = 248,JmaxHa = 43540, JmaxHd = 152040, JmaxS = 495, Vcmax25 = 40, VcmaxHa = 78000,
             gammastar25 = 0.5/1310,gammastarHa = -31100,
             gbs = 0.003, ao25 = 0.047, aoHa = -1630, Vpr = 80,
             fRdRm = 0.5, Rday25 = 0.8, RdayHa = 66400,
             alpha = 0,
             abso = 0.85, fcyc = 0.3,f = 0.15, Theta = 0.7, h = 4, x = 0.4)
  
  ## Param modified in the call of the function by the user (default is NA if the user don't modify the parameters)
  param_fun=list(O2 = O2, Kc25 = Kc25, KcHa = KcHa, Ko25 = Ko25, KoHa = KoHa, Kpc25 = Kpc25, KpcHa = KpcHa, 
                 Vpmax25 = Vpmax25, VpmaxHa = VpmaxHa, Jmax25 = Jmax25,JmaxHa = JmaxHa, JmaxHd = JmaxHd, JmaxS = JmaxS, Vcmax25 = Vcmax25, VcmaxHa = VcmaxHa,
                 gammastar25 = gammastar25, gammastarHa = gammastarHa,
                 gbs = gbs, ao25 = ao25, aoHa = aoHa, Vpr = Vpr,
                 fRdRm = fRdRm, Rday25 = Rday25, RdayHa = RdayHa,
                 alpha = alpha,
                 abso = abso, fcyc = fcyc,f = f, Theta = Theta, h = h, x = x)
  
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

#' @title C4 Photosynthesis model
#' @description Calculate the assimilation according to Caemmerer 2021 equations
#' @inheritParams f.make.param.C4
#' @param param List of parameters, see f.make.param for details
#' @param PFD Photosynthetic light at the leaf surface in micromol m-2 s-1
#' @param Ci Intercellular CO2 concentration (ppm or micromol mol-1)
#' @param Tleaf Leaf temperature in Kelvin
#' @references Susanne von Caemmerer, Updating the steady-state model of C4 photosynthesis, Journal of Experimental Botany, Volume 72, Issue 17, 2 September 2021, Pages 6003–6017, https://doi.org/10.1093/jxb/erab266
#' @return The function returns a list of three variables: 
#'    - A, the photosynthesis rate in micromol m-2 s-1
#'    - Ac, the photosynthesis potential rate limited by the rubisco carboxylation
#'    - Aj, the photosynthesis potential rate limited by electron transport
#' @export
#'
#' @examples Ci=seq(0,1500,10)
#' plot(x=Ci,y=f.ACi.C4(PFD=2000,Ci=Ci,Tleaf=300,param=f.make.param.C4())$A)

f.ACi.C4 <- function(PFD,Ci,Tleaf,param=f.make.param.C4()){
  
  ## Assuming infinite mesophyll conductance 
  Cm = Ci
  
  ## Calculating the temperature dependence of the photosynthetic parameters:
  Kc = f.arrhenius(param[['Kc25']],param[['KcHa']],Tleaf)
  Ko = f.arrhenius(param[['Ko25']],param[['KoHa']],Tleaf)
  Kpc = f.arrhenius(param[['Kpc25']],param[['KpcHa']],Tleaf)
  Vpmax = f.arrhenius(param[['Vpmax25']],param[['VpmaxHa']],Tleaf)
  Jmax = f.modified.arrhenius(PRef=param[['Jmax25']],param[['JmaxHa']],param[['JmaxHd']],param[['JmaxS']],Tleaf)
  Vcmax = f.arrhenius(param[['Vcmax25']],param[['VcmaxHa']],Tleaf)
  gammastar = f.arrhenius(param[['gammastar25']],param[['gammastarHa']],Tleaf)
  ao = f.arrhenius(param[['ao25']],param[['aoHa']],Tleaf)
  Rday = f.arrhenius(param[['Rday25']],param[['RdayHa']],Tleaf)
  Rm = param[['fRdRm']]*Rday # Rday in the mesophyll
  Rbs = param[['fRdRm']]*Rday # Rday in the bundle sheath compartment
  
  ## Calculation of the Rubisco limited rate of CO2 assimilation
  Vp = pmin(Cm * Vpmax/(Cm + Kpc), param[['Vpr']]) # Eqn 19, von Caemmerer (2021)
  a = 1- param[['alpha']]/ao*Kc/Ko # Corrected from Eqn 22, von Caemmerer (2021)
  b = -((Vp - Rm + param[['gbs']]*Cm)+Vcmax - Rday + param[['gbs']]*(Kc*(1+param[['O2']]/Ko)) + param[['alpha']]/ao*(gammastar*Vcmax+Rday*Kc/Ko)) # Eqn 23, von Caemmerer (2021)
  c = (Vcmax - Rday)*(Vp - Rm + param[['gbs']]*Cm)-(Vcmax*param[['gbs']]*gammastar*param[['O2']]+Rday*param[['gbs']]*Kc*(1+param[['O2']]/Ko)) # Eqn 24, von Caemmerer (2021)
  Ac = (-b-sqrt(b^2-4*a*c))/(2*a) # Eqn 20, von Caemmerer (2021)
  
  ## Calculation of the electron transport rate limitation of CO2 assimilation
  I2 = PFD*param[['abso']]*((1-param[['fcyc']])/(2-param[['fcyc']]))*(1-param[['f']]) # Eqn 35, von Cammerer (2021)
  J = (I2+Jmax-((I2+Jmax)^2-4*(param[['Theta']])*I2*Jmax)^0.5)/(2*(param[['Theta']])) # Solution of Eqn 34, von Caemmerer (2021)
  z = (3 - param[['fcyc']]) / (param[['h']]*(1-param[['fcyc']])) # Eqn 31, von Cammerer (2021)
  a = 1-7*gammastar*param[['alpha']]/(3*ao) # Eqn 41, von Cammerer (2021)
  b = -((z/2*param[['x']]*J-Rm+param[['gbs']]*Cm) + (z/3*(1-param[['x']])*J-Rday) + param[['gbs']]*7*gammastar*param[['O2']]/3 + param[['alpha']]*gammastar/ao*(z/3*(1-param[['x']])*J+7/3*Rday)) # Eqn 42, von Cammerer (2021)
  c = (z/2*param[['x']]*J-Rm+param[['gbs']]*Cm)*(z/3*(1-param[['x']])*J-Rday) - param[['gbs']]*gammastar*param[['O2']]*(z/3*(1-param[['x']])*J+7/3*Rday)# Eqn 43, von Cammerer (2021)
  Aj = (-b-sqrt(b^2-4*a*c))/(2*a) # Eqn 40, von Caemmerer (2021)
  
  A = pmin(Ac,Aj)
  result=data.frame(A=A,Ac=Ac,Aj=Aj)
  return(result)
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
f.SumSq.C4<-function(Fixed,data,Start){
  param=c(Fixed,Start)
  y<-data$A-f.ACi.C4(Ci=data$Ci,PFD=data$Qin,Tleaf=data$Tleaf,param=param)$A
  return(sum(y^2))
}

f.MinusLogL.C4<-function(data,sigma,O2= NA,
                         Kc25 = NA,
                         KcHa = NA,
                         Ko25 = NA,
                         KoHa = NA,
                         Kpc25 = NA,
                         KpcHa = NA,
                         Vpmax25 = NA,
                         VpmaxHa = NA,
                         Jmax25 = NA,
                         JmaxHa = NA,
                         JmaxHd = NA,
                         JmaxS = NA,
                         Vcmax25 = NA,
                         VcmaxHa = NA,
                         gammastar25 = NA,
                         gammastarHa = NA,
                         gbs = NA,
                         ao25 = NA,
                         aoHa = NA,
                         Vpr = NA,
                         fRdRm = NA,
                         Rday25 = NA,
                         RdayHa = NA,
                         alpha = NA,
                         abso = NA,
                         fcyc = NA,
                         f = NA,
                         Theta = NA,
                         h = NA,
                         x = NA){
  
  param=list(O2 = O2, Kc25 = Kc25, KcHa = KcHa, Ko25 = Ko25, KoHa = KoHa, Kpc25 = Kpc25, KpcHa = KpcHa, 
             Vpmax25 = Vpmax25, VpmaxHa = VpmaxHa, Jmax25 = Jmax25,JmaxHa = JmaxHa, JmaxHd = JmaxHd, JmaxS = JmaxS, Vcmax25 = Vcmax25, VcmaxHa = VcmaxHa,
             gammastar25 = gammastar25, gammastarHa = gammastarHa,
             gbs = gbs, ao25 = ao25, aoHa = aoHa, Vpr = Vpr,
             fRdRm = fRdRm, Rday25 = Rday25, RdayHa = RdayHa,
             alpha = alpha,
             abso = abso, fcyc = fcyc,f = f, Theta = Theta, h = h, x = x)
  A_pred=f.ACi.C4(Ci=data$Ci,PFD=data$Qin,Tleaf=data$Tleaf,param=param)
  
  y<-dnorm(x=data$A,mean=A_pred$A,sd=(sigma),log=TRUE)
  return(-sum(y))
}


#' @title Plot data and model
#' @description Plot a generic graphic with observed data and predictions. Be careful to sort the data.frame beforehand.
#' @param measures Data frame obtained from CO2 or light curve with at least columns A, Ci, Qin and Tleaf
#' Data frame obtained from CO2 or light curve with at least columns A, Ci, Qin and Tleaf
#' @param type Type of the curve to plot (light curve: AQ or CO2 curve ACi)
#' @param list_legend Named list where the name and values will appear in the legend
#' @inheritParams f.ACi.C4  
#' @param name Name of the curve to be displayed
#'
#' @return Plot a figure
#' @export
#'
#' @examples
#' param=f.make.param.C4()
#' A=f.ACi.C4(PFD=2000,Tleaf=300,Ci=seq(0,1500,10),param=param)$A+rnorm(n = 151,mean = 0,sd = 0.2)
#' data=data.frame(Tleaf=rep(300,151),Ci=seq(0,1500,10),Qin=rep(2000,151),A=A)
#' f.plot.C4(measures=data,param=param,list_legend=param['Vcmax25'],name='Example 01',type='ACi')

f.plot.C4<-function(measures=NULL,list_legend,param,name='',type='ACi'){
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
  legend("topleft",legend=c(expression(italic(A)[c]),expression(italic(A)[j]),expression(italic(A)),"Obs"),lty=c(2,2,1,0),
         pch=c(NA,NA,NA,21),
         col=c("dark blue","dark red","dark grey","black"),bty="n",lwd=c(2,2,1,1),
         seg.len=2,cex=1,pt.cex=1)
  result=f.ACi.C4(Ci=measures$Ci,Tleaf=measures$Tleaf,PFD=measures$Qin,param=param)
  lines(x=x,y=result$A,col="dark grey",lwd=1)
  lines(x=x,y=result$Ac,lwd=2,col="dark blue",lty=2)
  lines(x=x,y=result$Aj,lwd=2,col="dark red",lty=2)
  box(lwd=1)
}



#' @title Fitting function for C4 photosynthesis data (ACi curve)
#' @description Function to fit the C4 photosynthesis model to the data. The parameters to fit have to be described in the list "Start".
#' All the other parameters of the f.ACi.C4 function have to be detailed in the input variable "param". If the parameters from Start are repeated in param, the later one will be ignored.
#' This function uses two methods to fit the data. First by minimizing the residual sum-of-squares of the residuals and then by maximizing the likelihood function. The first method is more robust but the second one allows to calculate the confidence interval of the parameters.
#' @param measures Data frame of measures obtained from gas exchange analyser with at least the columns A, Ci, Qin and Tleaf (in K). If RHs, Tair, Patm, VPDleaf are also present, there mean will be added in the output, but those columns are not needed to estimate the parameters
#' @param id.name Name of the colums in measures with the identifier for the curve.
#' @param Start List of parameters to fit with their initial values.
#' @param param See f.make.param.C4() for details.
#' @param modify.init TRUE or FALSE, allows to modify the Start values before fitting the data
#' @param do.plot TRUE or FALSE, plot data and fitted curves ?
#' @return Return a list with 3 components, 1 the result of the optim function which is used to estimate the parameters, 2 the output of the function bbmle, 3 the mean variable of the environment during the measurement
#' @export
#'
#' @examples ##Simulation of a CO2 curve
#' data=data.frame(Tleaf=rep(300,151),
#' Ci=seq(0,1500,10),Qin=rep(2000,151),Tair=300,RHs=70,VPDleaf=2,Patm=101,A=f.ACi.C4(PFD=2000,Tleaf=300,Ci=seq(0,1500,10),
#' param=f.make.param.C4(Jmax25=1000))$A+rnorm(n = 151,mean = 0,sd = 0.2))
#'
#' f.fitting.C4(measures=data,id.name=NULL,Start=list(Vcmax25=70,Rday25=1,Vpmax25=200),param=f.make.param.C4(Jmax25=1000))

f.fitting.C4<-function(measures,id.name=NULL,Start=list(Vcmax25=40,Vpmax25=200,Rday25=1),param=NULL,modify.init=TRUE,do.plot=TRUE,type='ACi'){
  Fixed=param[!names(param)%in%names(Start)]
  
 
  if(modify.init){
    ## Here I create a list of initial values for the estimated parameters that span a large range of possible values
    ## so we increase the chance to find a good solution and not a local minimum
    grille=expand.grid(lapply(X = Start,FUN = function(x){x*c(0.2,1,2)}))
    grille.list=apply(X=grille,MARGIN = 1,FUN=as.list)
    value=9999999
    l_param=0
    
    ## I fit the model to the data using all the combination of initial parameters
    for(l in 1:nrow(grille)){
      MoindresCarres=optim(par=grille.list[[l]],fn=f.SumSq.C4,data=measures,Fixed=Fixed)
      if(!is.null(MoindresCarres)&MoindresCarres$value<value){value=MoindresCarres$value;l_param=l}
    }
    
    ## I keep the start list which has the best result
    Start=grille.list[[l_param]]
  }
  
  ## I fit the model to the data using the best Start values
  if(is.null(id.name)){name=''}else{name=unique(measures[,id.name])}
  MoindresCarres<-Estimation2<-NULL
  try({
    MoindresCarres<-optim(par=Start,fn=f.SumSq.C4,data=measures,Fixed=Fixed)
    print(MoindresCarres)
    print(paste('sd',sqrt(MoindresCarres$value/NROW(measures))))
    Start$sigma=sqrt(MoindresCarres$value/NROW(measures))
    for(l.name in names(MoindresCarres$par)){Start[l.name]=MoindresCarres$par[[l.name]]}
    for(l.name in names(MoindresCarres$par)){param[l.name]=MoindresCarres$par[[l.name]]}
    #if(do.plot){f.plot(measures=measures,name=name,param =param,list_legend = Start,type=type)}
  })
  
  ## The parameter estimation was done by minimizing the sum of square of the residuals. This method is robust
  ## and can converge to a solution in most cases. I then use an other method which should gives better estimates by 
  ## maximising the likelihood
  try({
    Estimation2=mle2(minuslogl = f.MinusLogL.C4,start = Start,fixed = Fixed,data = list(data=measures))
    print(summary(Estimation2))
    #conf=confint(Estimation2)
    #print(conf)
    for(i in names(Estimation2@coef[names(Estimation2@coef)%in%names(param)])){param[i]=Estimation2@coef[i]}
    if(do.plot){f.plot.C4(measures=measures,name=name,param =param,list_legend = as.list(Estimation2@coef),type=type)}
  })
  
  ## Here, I compute the average environmental conditions during the curve 
  Envir=NA
  try({
    Envir=c(Tair=mean(measures$Tair,na.rm=TRUE),Tleaf=mean(measures$Tleaf,na.rm=TRUE),RHs=mean(measures$RHs,na.rm=TRUE),VPDleaf=mean(measures$VPDleaf,na.rm=TRUE),Qin=mean(measures$Qin,na.rm=TRUE),Patm=mean(measures$Patm,na.rm=TRUE))
  })
  return(list(MoindresCarres,Estimation2,Envir))
}






#' @param measures ACi curve dataframe with at least the columns SampleID_num, A, Ci, Qin and Tleaf (in degree Celcius). SampleID_num is a needed identifier of the A-CI curve (the name of the leaf for example) 
#' @param param List of the C4 photosynthesis model parameters. See f.make.param.C4 for details. List of the C4 photosynthesis model parameters
#' @param Vcmax25 Value of Vcmax25 used to initialize the fitting procedure
#' @param Vpmax25 Value of Vpmax25 used to initialize the fitting procedure
#' @param Rday25 Value of Rday25 used to initialize the fitting procedure
#'
#' @return Return a dataframe (Bilan) with the estimated parameters for each A-Ci curve 
#' @export
#'
#' @examples
#' data1=data.frame(Tleaf=rep(25,151),
#' Ci=seq(0,1500,10),Qin=rep(2000,151),Tair=25,RHs=70,VPDleaf=2,Patm=101,A=f.ACi.C4(PFD=2000,Tleaf=25+273.16,Ci=seq(0,1500,10),
#' param=f.make.param.C4(Vcmax25=70, Vpmax25=210,Jmax25=1000))$A+rnorm(n = 151,mean = 0,sd = 0.1),SampleID_num=1)
#' data2=data.frame(Tleaf=rep(25,151),
#' Ci=seq(0,1500,10),Qin=rep(2000,151),Tair=25,RHs=70,VPDleaf=2,Patm=101,A=f.ACi.C4(PFD=2000,Tleaf=25+273.16,Ci=seq(0,1500,10),
#' param=f.make.param.C4(Vcmax25=20, Vpmax25=100,Jmax25=1000))$A+rnorm(n = 151,mean = 0,sd = 0.1),SampleID_num=2)
#' measures=rbind.data.frame(data1,data2)
#'
#' f.fit_ACi.C4(measures=measures,param=f.make.param.C4(Jmax25=1000))

f.fit_ACi.C4<-function(measures,param,Vcmax25=40, Vpmax25=120, Rday25 = 2){
  ## Basic checks
  #if(any(measures$Ci < 0)) {stop("Ci contains negative values")}
  if(any(is.na(c(measures$A,measures$Ci,measures$Tleaf,measures$Qin,measures$SampleID_num)))) {stop("Ci, A, Tleaf or Qin have NA values")}
  if(any(measures$Tleaf > 100)) {stop("Check Tleaf values. Should be in degree celcius")}
  if(is.null(measures$SampleID_num)|is.null(measures$Ci)|is.null(measures$Tleaf)|is.null(measures$Qin)|is.null(measures$A)){stop("Your dataframe measures does not contain the colums SampleID_num or A or Tleaf or Ci")}
  n_points_curves=tapply(X=measures$SampleID_num,INDEX = measures$SampleID_num,FUN = function(x) length(x))
  min_Ci_curve=tapply(X=measures$Ci,INDEX = measures$SampleID_num,FUN = min)
  if(any(n_points_curves<3)){stop("Some of your A-Ci curves have less than 3 points")}
  if(any(min_Ci_curve>270)){stop("Some of your A-Ci curves have a minimum Ci above 270 ppm meaning that Vcmax cant be estimated")}
  
  measures$Tleaf=measures$Tleaf+273## Conversion in Kelvin
  
  param[["Jmax25"]]=1000 ## We assume that Aj is never limiting photosynthesis, an assumption used in several protocols
  ## Fitting of the Aci curve using Ac and Aj limitation
  pdf(file = '2_ACiC4_fitting.pdf')
  result=by(data = measures,INDICES = list(measures$SampleID_num),
                  FUN = function(x){print(paste('SampleID_num:',unique(x$SampleID_num)))
                    f.fitting.C4(measures = x,Start = list(Vcmax25=Vcmax25,Rday25=Rday25,Vpmax25=Vpmax25),
                              param=param,id.name = 'SampleID_num')})
  dev.off()
  
  
  ## Extracting the fitting metrics for each model and each curve
  res_nlf=as.data.frame(t(sapply(result,FUN = function(x){
  if(!is.null(x[[2]])){
      coefs=x[[2]]@coef
      summary_mle2=summary(x[[2]])
      std_dev=sqrt(diag(x[[2]]@vcov))
      names(std_dev)=paste('StdError',names(std_dev),sep='_')
      AICcurve=AIC(x[[2]])}else {coefs=rep(NA,3)
      std_dev=rep(NA,3)
      AICcurve=NA}
    return(c(coefs,std_dev,AIC=AICcurve,Tleaf=x[[3]]['Tleaf']))}
  )))
  res_nlf$SampleID_num=row.names(res_nlf)
  res_nlf$Jmax25=NA
  res_nlf$TPU25=NA
  res_nlf$StdError_Jmax25=NA
  res_nlf$StdError_TPU25=NA
  res_nlf$Model='Ac'
  
  Bilan=res_nlf
  Bilan$Fitting_method="A-Ci curve"
  Bilan$Tleaf=Bilan$Tleaf-273 ## Conversion to degree Celcius
 
  return(Bilan[,c("SampleID_num","Vcmax25","Jmax25","TPU25","Rday25","StdError_Vcmax25","StdError_Jmax25","StdError_TPU25","StdError_Rday25","Tleaf","sigma","AIC","Model","Fitting_method")])
}



## Some tests
#PFD = 2000
#Ci = seq(5,1500,20)
#Tleaf = 25 + 273.16
#param = f.make.param.C4(Jmax25=1000,Vcmax25=20,Vpmax25=100)
#
#simu= f.ACi.C4(PFD=2000, Ci = Ci, Tleaf= 25+273.16,param=param)
#simu$A_random=simu$A+rnorm(n = length(simu$A),mean = 0,sd = 0.5)
#plot(x=Ci,y=simu$A,type="l",col="grey",ylim=c(0,50))
#points(y=simu$A_random,x=Ci)
#
#measures=data.frame(A=simu$A_random,Ci=Ci,Tleaf=Tleaf,Qin=PFD,SampleID_num=1)
#res=f.fitting.C4(measures = measures,param = param)
#param[["Rday25"]]
#param[["Vcmax25"]]
#param[["Vpmax25"]]
#measures$Tleaf=25
#f.fit_ACi.C4(measures = measures,param = param)



