library(dplyr)
library(data.table)
library(tidyr)
library(reshape2)

path <- getwd()

#start to download the data file, and save it into work folder, file name: Dataset.zip. 

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


filename <- "Dataset.zip"
 
if (!file.exists(path)) {
     
     dir.create(path)
     
     }

 if (!file.exists(filename))
      {
     download.file(url, file.path(path, filename),method="curl")
 }
 
# unzip the data 
# 
 unzip(filename, exdir = ".") 
 
#read the data files 

     file_trainx<-fread("./UCI HAR Dataset/train/X_train.txt")
    
     file_trainy<-fread("./UCI HAR Dataset/train/y_train.txt")
     
     file_testx<-fread("./UCI HAR Dataset/test/X_test.txt")
     
     file_testy<-fread("./UCI HAR Dataset/test/y_test.txt")
     
     
     subj_train<-fread("./UCI HAR Dataset/train/subject_train.txt")
     subj_test<-fread("./UCI HAR Dataset/test/subject_test.txt")
     
     
     feature<-fread("./UCI HAR Dataset/features.txt")
     
     
     activity<-fread("./UCI HAR Dataset/activity_labels.txt")

     #merge the test and train data here
     data<-rbind(file_testx,file_trainx)
     
     #merge the acitivity data here and rename the col name as "activity"
     allacti<-rbind(file_testy,file_trainy)
     names(allacti)<-c("activity")
     
     #merge the subject data and rename the col name as "subject"
     
     subject<-rbind(subj_test,subj_train)
     names(subject)<-c("subject")
     
     #subset the activity name
     activitynames<-activity$V2
     
     #create newact as teh activity data with activity names
     newact<-activitynames[allacti$activity]
     names(newact)<-c("activity")
     
     #merge subject, activity and test data into newalldata and set keys
     newalldata<-cbind(subject,newact,data)
     setkey(newalldata,subject,newact)
     
     
     #start to precess features. create featurecode and rename all cols
     feature$featurecode<-feature[,paste0("V",feature$V1)]
     names(feature)<-c("featurenum","featurename","featurecode")
     
     #select dataset with cols "featurecode" and "featurename"
     feature<-select(feature,featurecode,featurename)
     
     #subset feature data, only featurenames with "mean()" and "std()" are selected
     dt_feature <- feature[grepl("mean\\(\\)|std\\(\\)", featurename)]
     
     #change "f"and "t" to "frequency" and "time". 
     dt_feature$featurename<-gsub("^t","time.",dt_feature$featurename)
     dt_feature$featurename<-gsub("^f","frequency.",dt_feature$featurename)
     
     #here start to replace "BodyAcc" etc. to instrument "accelerometer" and "gyrosope". "body" and "gravity" are for different accleration. "NA" for "gyroscope" because "acceleration" is only for measurement using accelerometer
      
     dt_feature$featurename<-gsub("*BodyAcc|*BodyBodyAcc","body.accelerometer.",dt_feature$featurename)
     dt_feature$featurename<-gsub("*BodyGyro|BodyBodyGyro","NA.gyroscope.",dt_feature$featurename)
     dt_feature$featurename<-gsub("*GravityAcc","gravity.accelerometer.",dt_feature$featurename)
     
     #here to separate "jerk","magnitue", "mean" , "std" and "xyz" axis.Use "NA" as not used items. 
     
     dt_feature$featurename<-gsub("*Jerk\\-","jerk.NA",dt_feature$featurename)
     dt_feature$featurename<-gsub("*JerkMag\\-","jerk.magnitue",dt_feature$featurename)
     dt_feature$featurename<-gsub("*Mag\\-","NA.magnitue",dt_feature$featurename)
     
     dt_feature$featurename<-gsub("*-mean\\(\\)-","NA.NA.mean.",dt_feature$featurename)
     dt_feature$featurename<-gsub("*-std\\(\\)-","NA.NA.std.",dt_feature$featurename)
     
     dt_feature$featurename<-gsub("*mean\\(\\)-",".mean.",dt_feature$featurename)
     dt_feature$featurename<-gsub("*std\\(\\)-",".std.",dt_feature$featurename)
     
     dt_feature$featurename<-gsub("*mean\\(\\)",".mean.NA",dt_feature$featurename)
     dt_feature$featurename<-gsub("*std\\(\\)",".std.NA",dt_feature$featurename)
     
     
     #subset data with featurecode, save to dt_newdata
     dt_newdata <- newalldata[, c(key(newalldata),dt_feature$featurecode), with = FALSE]
     
     #melt the data by featurecode
     dt_meltdata<-melt(dt_newdata,key(dt_newdata),variable.name = "featurecode")
     
     
     #merge data with dt_feature data by featurecode and select for cols:subject, activity, featurename and vlue,rename those cols.
     dt_mergedata<-merge(dt_meltdata,dt_feature,by="featurecode",all.x=T)
     dt_mergedata<-select(dt_mergedata,subject,newact,featurename,value)
     names(dt_mergedata)<-c("subject","activity","featurename","value")
     
     #separate: separate featuename to "domain","acceleration","instrument","Jerk","magnitue","method","Axis".  
     dt_newdata<-separate(dt_mergedata,featurename,c("domain","acceleration","instrument","Jerk","magnitue","method","Axis"),sep="\\.")
     
     
     
     #set keys for new data set and calculate the meanvalue for each measurement, save it to dataset dt_final
     
     setkey(dt_newdata,subject,activity,domain,instrument, acceleration,Jerk,magnitue,method,Axis)
     
     dt_final<-dt_newdata[, list( meanvalue = mean(value)), by=key(dt_newdata)]
     
     #write data to file "UCITidy_byCQli.txt"
     
     write.table(dt_final, file = "UCITidy_byCQLi.txt", row.names = FALSE)
     
     
     


