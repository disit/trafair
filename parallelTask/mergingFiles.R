#unique folder creation for GFF files storage and meteopgt.all file creation containg in AllSituatons_n.met file 
library(stringr)
#set a work directory:
setwd("~/parallelTask")
#load AllSituation_n.met"
allSituations=readLines("AllSituations_n.met")
#Suppose to consider domain in flat terrain
allSituationsDB=str_sub(allSituations,18,nchar(allSituations))
allSituationsDBnoneST=str_sub(allSituations,18,nchar(allSituations)-2)
allSituationsDBunique=unique(allSituationsDBnoneST)
#let R be the number of weather situations considered
R=length(allSituationsDBunique)
#let S be the numeber of partioned classes 
S=24
#Let N be the number of elements in each class (supposing N integer)
N=R/S
#create a folder containing data - no stabilty class specifications:
dir.create("~/parallelTask/GFFstorage")
for(i in 1:S){
  nameDirectory=paste("~/parallelTask/task_",i,sep="")
  setwd(nameDirectory)
  dataFile=list.files()
  dataGFFindex=grep(".gff",dataFile)
  dataGFF=dataFile[dataGFFindex]
  dataGFF=sort(dataGFF)
  for(j in 1:N){
    pathA=paste(nameDirectory,dataGFF[j],sep="/")
    index=(i-1)*N+j
    numD=5-nchar(index)
    gffname=paste(paste(replicate(numD, "0"), collapse = ""),index,".gff",sep="")
    pathB=paste("~/parallelTask/GFFstorage/",gffname,sep="")
    file.rename(from=pathA,to=pathB)
    #in the case of fie copy.
    #file.copy(from=pathA,to=pathB)
  }
}
#Copying File for the stability class - according to the initial order of AllSituations_n.met
#set working directory:
dir.create("~/parallelTask/GFFstorageSC")
setwd("~/parallelTask/GFFstorage")
meteopgt=rep(0,length(allSituations)+2)
meteopgt[1]="10,1,0,    !Are dispersion situations classified =0 or not =1"
meteopgt[2]="Wind direction sector,Wind speed class,stability class, frequency"
dataFile=list.files()
dataGFFindex=grep(".gff",dataFile)
dataGFF=dataFile[dataGFFindex]
dataGFF=sort(dataGFF)
frequency=40
for(i in 1:length(allSituationsDBunique)){
  index=which(allSituationsDBunique[i]==allSituationsDBnoneST)
  dataWeather=strsplit(allSituations[index],",")
  pathA=paste("~/parallelTask/GFFstorage/",dataGFF[i],sep="")
  for(j in 1:length(index)){
    meteopgt[index[j]+2]=paste(dataWeather[[j]][4],dataWeather[[j]][3],dataWeather[[j]][5],frequency,sep=",")
    numD=5-nchar(index[j])
    gffname=paste(paste(replicate(numD, "0"), collapse = ""),index[j],".gff",sep="")
    pathB=paste("~/parallelTask/GFFstorageSC/",gffname,sep="")
    file.copy(from=pathA,to=pathB)
  }
}
setwd("~/parallelTask/GFFstorageSC")
write.table(meteopgt,file="~/parallelTask/GFFstorageSC/meteopgt.all",quote=FALSE,row.names = FALSE,col.names = FALSE)