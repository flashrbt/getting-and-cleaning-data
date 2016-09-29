library(dplyr)
library(data.table)
library(tidyr)
library(reshape2)

path <- getwd()

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


filename <- "Dataset.zip"
 if (!file.exists(path)) {
     
     dir.create(path)
     
     }

 if (!file.exists(filename))
      {
     download.file(url, file.path(path, filename),method="curl")
 }
 
 unzip(filename, exdir = ".") 
 
 

file_trainx<-fread("./UCI HAR Dataset/train/x_train.txt")

file_trainy<-fread("./UCI HAR Dataset/train/y_train.txt")

file_testx<-fread("./UCI HAR Dataset/test/x_test.txt")

file_testy<-fread("./UCI HAR Dataset/test/y_test.txt")


subj_train<-fread("./UCI HAR Dataset/train/subject_train.txt")
subj_test<-fread("./UCI HAR Dataset/test/subject_test.txt")


feature<-fread("./UCI HAR Dataset/features.txt")


activity<-fread("./UCI HAR Dataset/activity_labels.txt")


data<-rbind(file_testx,file_trainx)


allacti<-rbind(file_testy,file_trainy)

names(allacti)<-c("activity")



subject<-rbind(subj_test,subj_train)

names(subject)<-c("subject")


activitynames<-activity$V2


newact<-activitynames[allacti$activity]


names(newact)<-c("activity")


newalldata<-cbind(subject,newact,data)


setkey(newalldata,subject,newact)



feature$featurecode<-feature[,paste0("V",feature$V1)]

names(feature)<-c("featurenum","featurename","featurecode")

feature<-select(feature,featurecode,featurename)

dt_feature <- feature[grepl("mean\\(\\)|std\\(\\)", featurename)]
dt_feature$featurename<-gsub("^t","time|",dt_feature$featurename)
dt_feature$featurename<-gsub("^f","frequency|",dt_feature$featurename)

dt_feature$featurename<-gsub("*BodyAcc|*BodyBodyAcc","body.accelerometer|",dt_feature$featurename)

dt_feature$featurename<-gsub("*BodyGyro|BodyBodyGyro","NA.gyroscope|",dt_feature$featurename)

dt_feature$featurename<-gsub("*GravityAcc","gravity.accelerometer|",dt_feature$featurename)

dt_feature$featurename<-gsub("*Jerk\\-","jerk:NA",dt_feature$featurename)
dt_feature$featurename<-gsub("*JerkMag\\-","jerk:magnitue",dt_feature$featurename)
dt_feature$featurename<-gsub("*Mag\\-","NA:magnitue",dt_feature$featurename)

dt_feature$featurename<-gsub("*-mean\\(\\)-","NA:NA:mean:",dt_feature$featurename)
dt_feature$featurename<-gsub("*-std\\(\\)-","NA:NA:std:",dt_feature$featurename)

dt_feature$featurename<-gsub("*mean\\(\\)-",":mean:",dt_feature$featurename)
dt_feature$featurename<-gsub("*std\\(\\)-",":std:",dt_feature$featurename)

dt_feature$featurename<-gsub("*mean\\(\\)",":mean:NA",dt_feature$featurename)
dt_feature$featurename<-gsub("*std\\(\\)",":std:NA",dt_feature$featurename)

dt_newdata <- newalldata[, c(key(newalldata),dt_feature$featurecode), with = FALSE]


dt_meltdata<-melt(dt_newdata,key(dt_newdata),variable.name = "featurecode")

dt_mergedata<-merge(dt_meltdata,dt_feature,by="featurecode",all.x=T)

dt_mergedata<-select(dt_mergedata,subject,newact,featurename,value)

names(dt_mergedata)<-c("subject","activity","featurename","value")

dt_newdata<-separate(dt_mergedata,featurename,c("domain","instrument","measurement"),sep="\\|")

dt_newdata<-separate(dt_newdata,instrument,c("acceleration","instrument"),sep="\\.")

dt_newdata<-separate(dt_newdata,measurement,c("Jerk","magnitue","method","Axis"),sep="\\:")

setkey(dt_newdata,subject,activity,domain,instrument, acceleration,Jerk,magnitue,method,Axis)

dt_final<-dt_newdata[, list( meanvalue = mean(value)), by=key(dt_newdata)]

write.table(dt_final, file = "UCITidy_byCQLi.txt", row.names = FALSE)





