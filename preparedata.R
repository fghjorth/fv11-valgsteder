setwd("/Users/frederikhjorth/GitHub/fv11-valgsteder")

#gather all files in 1 df
csvs<-list.files(pattern=".csv")
allres<-data.frame(unit=NA,allvotes=NA,sd=NA,rv=NA,kf=NA,sf=NA,la=NA,kd=NA,df=NA,ve=NA,el=NA)
for (f in csvs){
  dat<-read.csv(f,sep=";",skip=5,header=F,fileEncoding="latin1")[,2:12]
  names(dat)<-names(allres)
  dat[,1]<-iconv(dat[,1],from="latin1",to="UTF-8",sub="X")
  allres<-rbind(allres,dat)
}
allres<-allres[2:nrow(allres),]
rm(f,dat,csvs)

#ex.: reddest voting places in DK?
allres$redshare<-(allres$sd+allres$sf+allres$el)/allres$allvotes
tail(allres[order(allres$redshare),])
head(allres[order(allres$redshare),])

require(ggplot2)
ggplot(allres,aes(x=redshare)) +
  geom_histogram()
