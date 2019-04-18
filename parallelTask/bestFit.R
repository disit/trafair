# bestFit.R function returns the fitted data in the meteopgt.all file according with the mettimeseries.dat syntax.
library(stringr)
bestFit <- function(date,timeSeriesIndex,windSpeed,windDirection,stabilityClass){
  #covert the input data in numeric data
  windSpeed=as.numeric(windSpeed)
  windDirection=as.numeric(windDirection)
  stabilityClass=as.numeric(stabilityClass)
  #read the whole meteopgt.all file
  meteopgt=readLines("~/parallelTask/GFFstorageSC/meteopgt.all")
  meteopgtData=strsplit(meteopgt,",")
  lmeteo=length(meteopgtData)
  dataSpeed=c()
  dataDirection=c()
  dataSC=c()
  for(i in 3:length(meteopgtData)){
    dataSpeed=c(dataSpeed,as.numeric(meteopgtData[[i]][2]))
    dataDirection=c(dataDirection,as.numeric(meteopgtData[[i]][1]))
    dataSC=c(dataSC,as.numeric(meteopgtData[[i]][3]))
  }
  #data selection procedure:
  deltaSpeed=abs(dataSpeed-windSpeed)
  indexSpeed=which(deltaSpeed==min(deltaSpeed))
  deltaDirection=abs(dataDirection[indexSpeed]-windDirection)
  indexDirection=which(deltaDirection==min(deltaDirection))
  deltaSC=abs(dataSC[indexSpeed[indexDirection]]-stabilityClass)
  indexSC=which(deltaSC==min(deltaSC))
  index=indexSpeed[indexDirection[indexSC]]
  #unique data control
  if(length(index)>1){
    index=index[1]
  }
  print(paste("select meteopgt.all data at line:",index+2,sep=" "))
  mettimeseriesLine=paste(date,timeSeriesIndex,dataSpeed[index],dataDirection[index],dataSC[index],sep=",")
  print(paste("corresponding mettimeseries.dat line:",mettimeseriesLine,sep=" "))
  return(mettimeseriesLine)
}
