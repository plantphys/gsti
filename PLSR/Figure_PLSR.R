library(here)
library(ggplot2)
library(cowplot)

##################################
### Importing the PLSR results ###
##################################

path = here()
setwd(path)

load("PLSR/PLSR_model_Vcmax25.Rdata",verbose=TRUE)
plsr_model_Vcmax25 = plsr_model

load("PLSR/PLSR_model_Jmax25.Rdata",verbose=TRUE)
plsr_model_Jmax25 = plsr_model

load("PLSR/PLSR_model_Rdark25.Rdata",verbose=TRUE)
plsr_model_Rdark25 = plsr_model


##############
### Figure ###
##############

## Vcmax25
pt_size=1

a=ggplot(data=plsr_model_Vcmax25$Predictions,aes(y=Obs,x=mean_pred))+theme_bw()+
  geom_errorbar(data=plsr_model_Vcmax25$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
  geom_errorbarh(data=plsr_model_Vcmax25$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
  geom_point(size=pt_size)+coord_cartesian(xlim=c(0,300),ylim=c(0,300))+
  geom_abline(slope=1) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(V)[cmax25]))+xlab(expression(Predicted~italic(V)[cmax25]))+annotate(x=0,y=300,label=paste("R² =",round(plsr_model_Vcmax25$R2,2)),"text",hjust=0,vjust=1)+annotate(x=0,y=0.9*300,label=paste("RMSE =",round(plsr_model_Vcmax25$RMSE,1)),"text",hjust=0,vjust=1)

## Jmax25

b=ggplot(data=plsr_model_Jmax25$Predictions,aes(y=Obs,x=mean_pred))+theme_bw()+
  geom_errorbar(data=plsr_model_Jmax25$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
  geom_errorbarh(data=plsr_model_Jmax25$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
  geom_point(size=pt_size)+coord_cartesian(xlim=c(0,500),ylim=c(0,500))+
  geom_abline(slope=1) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(J)[max25]))+xlab(expression(Predicted~italic(J)[max25]))+annotate(x=0,y=500,label=paste("R² =",round(plsr_model_Jmax25$R2,2)),"text",hjust=0,vjust=1)+annotate(x=0,y=0.9*500,label=paste("RMSE =",round(plsr_model_Jmax25$RMSE,1)),"text",hjust=0,vjust=1)

## Rdark25

c=ggplot(data=plsr_model_Rdark25$Predictions,aes(y=Obs,x=mean_pred))+theme_bw()+
  geom_errorbar(data=plsr_model_Rdark25$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
  geom_errorbarh(data=plsr_model_Rdark25$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
  geom_point(size=pt_size)+coord_cartesian(xlim=c(0,3.5),ylim=c(0,3.5))+
  geom_abline(slope=1) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(R)[dark25]))+xlab(expression(Predicted~italic(R)[dark25]))+annotate(x=0,y=3.5,label=paste("R² =",round(plsr_model_Rdark25$R2,2)),"text",hjust=0,vjust=1)+annotate(x=0,y=0.9*3.5,label=paste("RMSE =",round(plsr_model_Rdark25$RMSE,1)),"text",hjust=0,vjust=1)

jpeg("Outputs/Results_PLSR.jpeg", height=180, width=180, units = 'mm',res=300)
plot_grid(a,b,c,ncol=2,labels = c('(a)','(b)','(c)'),hjust = -0.1,align = 'hv')
dev.off()