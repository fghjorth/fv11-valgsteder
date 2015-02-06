#setwd("/Users/frederikhjorth/GitHub/fv11-valgsteder") #mac
setwd("/Users/fh/Documents/GitHub/fv11-valgsteder") #pc

#gather all files in 1 df
csvs<-list.files(pattern=".csv")[2:11]
allres<-data.frame(unit=NA,allvotes=NA,sd=NA,rv=NA,kf=NA,sf=NA,la=NA,kd=NA,df=NA,ve=NA,el=NA)
for (f in csvs){
  dat<-read.csv(f,sep=";",skip=5,header=F,fileEncoding="latin1")[,2:12]
  names(dat)<-names(allres)
  dat[,1]<-iconv(dat[,1],from="latin1",to="UTF-8",sub="X")
  allres<-rbind(allres,dat)
}
allres<-allres[2:nrow(allres),]
rm(f,dat,csvs)

#remove higher level units
allres<-allres[-which(grepl("STORKREDS",as.character(allres$unit))),]
allres<-allres[-which(grepl("OPSTILLINGSKREDS",as.character(allres$unit))),]

#standardize names
allres$unit<-tolower(allres$unit)

allres$unit<-gsub("æ","ae",allres$unit)
allres$unit<-gsub("ø","oe",allres$unit)
allres$unit<-gsub("å","aa",allres$unit)

#ex.: reddest voting places in DK?
allres$redshare<-(allres$sd+allres$sf+allres$el)/allres$allvotes
tail(allres[order(allres$redshare),])
head(allres[order(allres$redshare),])

require(ggplot2)
ggplot(allres,aes(x=redshare)) +
  geom_histogram()

write.csv(allres,file="allres.csv")
