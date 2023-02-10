library(here)

## I downloaded this dataset from https://zenodo.org/record/4480331#.YBSNFSMrJdh


ls_files=dir(recursive = TRUE)
ls_files_Aci=ls_files[which(grepl(x=ls_files,pattern="RawDataSetPoint",ignore.case = TRUE))]
original_data=do.call("rbind", apply(X = as.matrix(ls_files_Aci),FUN = read.csv,MARGIN = 1))

WV=colnames(original_data[,31:1054])
for(i in 1:length(WV)){
  test=as.numeric(substr(WV[i],2,nchar(WV[i])))
  if(!is.na(test)){WV[i]=test}
  if(is.na(test)){WV[i]=as.numeric(substr(WV[i],2,(nchar(WV[i])-2)))}
}
WV=as.numeric(WV)
Reflectance=I(as.matrix(original_data[,31:1054]))
f.plot.spec(Z = Reflectance,wv = WV)

## The spectra needs to be interpolated and splices corrected
library(spectacles) 

Reflectance$Spectrometer="ASD FieldSpec Pro"
Reflectance$Leaf_clip="ASD Leaf Clip"
Reflectance$Reflectance=I(as.matrix(Reflectance[,11:2161]*100))
Reflectance$SampleID=Reflectance$BR_UID


save(curated_data,file='0_curated_data.Rdata')
