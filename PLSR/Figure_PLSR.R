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
range_Vcmax25=diff(range(c(training$Vcmax25,validation$Vcmax25)))
## Vcmax25
pt_size=1

a=ggplot(data=plsr_model_Vcmax25$Predictions,aes(y=Obs,x=mean_pred))+theme_bw()+
  geom_errorbar(data=plsr_model_Vcmax25$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
  geom_errorbarh(data=plsr_model_Vcmax25$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
  geom_point(size=pt_size)+coord_cartesian(xlim=c(0,310),ylim=c(0,310))+
  geom_abline(slope=1) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(V)[cmax25]))+xlab(expression(Predicted~italic(V)[cmax25]))+
  annotate(x=0,y=310,label=paste("R² =",round(plsr_model_Vcmax25$R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*310,label=paste("RMSE =",round(plsr_model_Vcmax25$RMSE,1)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.8*310,label=paste("%RMSE =",round(plsr_model_Vcmax25$RMSE/range_Vcmax25*100,1)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.7*310,label=paste("N comp =",plsr_model_Vcmax25$nComp),"text",hjust=0,vjust=1)


## Jmax25

load("PLSR/PLSR_model_Jmax25.Rdata",verbose=TRUE)
plsr_model_Jmax25 = plsr_model
range_Jmax25=diff(range(c(training$Jmax25,validation$Jmax25)))


b=ggplot(data=plsr_model_Jmax25$Predictions,aes(y=Obs,x=mean_pred))+theme_bw()+
  geom_errorbar(data=plsr_model_Jmax25$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
  geom_errorbarh(data=plsr_model_Jmax25$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
  geom_point(size=pt_size)+coord_cartesian(xlim=c(0,500),ylim=c(0,500))+
  geom_abline(slope=1) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(J)[max25]))+xlab(expression(Predicted~italic(J)[max25]))+
  annotate(x=0,y=500,label=paste("R² =",round(plsr_model_Jmax25$R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*500,label=paste("RMSE =",round(plsr_model_Jmax25$RMSE,1)),"text",hjust=0,vjust=1) +
  annotate(x=0,y=0.8*500,label=paste("%RMSE =",round(plsr_model_Jmax25$RMSE/range_Jmax25*100,1)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.7*500,label=paste("N comp =",plsr_model_Jmax25$nComp),"text",hjust=0,vjust=1)

## TPU25

load("PLSR/PLSR_model_TPU25.Rdata",verbose=TRUE)
plsr_model_TPU25 = plsr_model
range_TPU25=diff(range(c(training$TPU25,validation$TPU25)))


c=ggplot(data=plsr_model_TPU25$Predictions,aes(y=Obs,x=mean_pred))+theme_bw()+
  geom_errorbar(data=plsr_model_TPU25$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
  geom_errorbarh(data=plsr_model_TPU25$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
  geom_point(size=pt_size)+coord_cartesian(xlim=c(0,25),ylim=c(0,25))+
  geom_abline(slope=1) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(TPU)[25]))+xlab(expression(Predicted~italic(TPU)[25]))+
  annotate(x=0,y=25,label=paste("R² =",round(plsr_model_TPU25$R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*25,label=paste("RMSE =",round(plsr_model_TPU25$RMSE,1)),"text",hjust=0,vjust=1) +
  annotate(x=0,y=0.8*25,label=paste("%RMSE =",round(plsr_model_TPU25$RMSE/range_TPU25*100,1)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.7*25,label=paste("N comp =",plsr_model_TPU25$nComp),"text",hjust=0,vjust=1)


## Rdark25

load("PLSR/PLSR_model_Rdark25.Rdata",verbose=TRUE)
plsr_model_Rdark25 = plsr_model
range_Rdark25=diff(range(c(training$Rdark25,validation$Rdark25)))

d=ggplot(data=plsr_model_Rdark25$Predictions,aes(y=Obs,x=mean_pred))+theme_bw()+
  geom_errorbar(data=plsr_model_Rdark25$Predictions,aes(x=mean_pred,ymin=lwr_obs,ymax=upr_obs),col="grey")+
  geom_errorbarh(data=plsr_model_Rdark25$Predictions,aes(y=Obs,xmin=lwr_conf,xmax=upr_conf),col="grey")+
  geom_point(size=pt_size)+coord_cartesian(xlim=c(0,5),ylim=c(0,5))+
  geom_abline(slope=1) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  ylab(expression(Observed~italic(R)[dark25]))+xlab(expression(Predicted~italic(R)[dark25]))+
  annotate(x=0,y=5,label=paste("R² =",round(plsr_model_Rdark25$R2,2)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.9*5,label=paste("RMSE =",round(plsr_model_Rdark25$RMSE,1)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.8*5,label=paste("%RMSE =",round(plsr_model_Rdark25$RMSE/range_Rdark25*100,1)),"text",hjust=0,vjust=1)+
  annotate(x=0,y=0.7*5,label=paste("N comp =",plsr_model_Rdark25$nComp),"text",hjust=0,vjust=1)

jpeg("Outputs/Results_PLSR.jpeg", height=180, width=180, units = 'mm',res=300)
plot_grid(a,b,c,d,ncol=2,labels = c('(a)','(b)','(c)','(d)'),hjust = -0.1,align = 'hv')
dev.off()