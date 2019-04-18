library(stringr)
#Suppose to consider all the weather data combination:
#set a work directory:
setwd("~/parallelTask")
#load "AllSituation_n.met" the combinations file coming from developers
allSituations=readLines("AllSituations_n.met")
#Suppose to consider domain in flat terrain
#The variation is considered only for speed wind and speed direction. Unifing the data.
allSituationsDBnoneST=str_sub(allSituations,18,nchar(allSituations)-2)
allSituationsDBunique=unique(allSituationsDBnoneST)
#let R be the number of weather situations considered
R=length(allSituationsDBunique)
#let S be the numeber of partioned classes 
S=24
#Let N be the number of elements in each class (supposing N integer)
N=R/S
#Start date computing
dateComp=Sys.Date()
#folders' creation for dataComputing. Partition of the weather data in S classes
for(i in 1:S){
  nameDirectory=paste("~/parallelTask/task_",i,sep="")
  dir.create(nameDirectory)
  setwd(nameDirectory)
  dataSpeed=c()
  dataDirection=c()
  meteopgt=c()
  mettimeseries=c()
  meteopgt[1]="10,1,0,    !Are dispersion situations classified =0 or not =1"
  meteopgt[2]="Wind direction sector,Wind speed class,stability class, frequency"
  reprStClass=4
  frequency=40
  for(j in 1:N){
    dataSpeed[j]=strsplit(allSituationsDBunique[(i-1)*N+j],",")[[1]][1]
    dataDirection[j]=strsplit(allSituationsDBunique[(i-1)*N+j],",")[[1]][2]
    meteopgt[j+2]=paste(dataDirection[j],dataSpeed[j],reprStClass,frequency,sep=",")
    mettimeseries[j]=paste(dateComp,j,dataSpeed[j],dataDirection[j],reprStClass,sep=",")
    # example=paste("task:",i,"-line:",j,sep="")
    # numD=5-nchar(j)
    # gffname=paste(paste(replicate(numD, "0"), collapse = ""),j,".gff",sep="")
    # write.table(example,file=paste(nameDirectory,gffname,sep="/"),quote=FALSE,row.names = FALSE,col.names = FALSE)
  }
  write.table(mettimeseries,file=paste(nameDirectory,"/mettimeseries.dat",sep=""),quote=FALSE,row.names = FALSE,col.names = FALSE)
  write.table(meteopgt,file=paste(nameDirectory,"/meteopgt.all",sep=""),quote=FALSE,row.names = FALSE,col.names = FALSE)
}


