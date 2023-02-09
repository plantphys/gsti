LICOR6400_column=c('','Obs','Photo','Ci','CO2S','CO2R','Cond','Press','PARi','RH_S','Tleaf')
ESS_column=c('SampleID','Record','A','Ci','CO2s','CO2r','gsw','Patm','Qin','RHs','Tleaf')

LICOR6400toESS=as.data.frame(t(ESS_column))
colnames(LICOR6400toESS)=LICOR6400_column
