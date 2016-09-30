#Getting and Cleaning Data project

This is the repository to save the code and support document (readme.md,codebook.m) for the course Getting and Cleaning data.

##Project description:


> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

>http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
> 
> Here are the data for the project:
> 
> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
> 
> You should create one R script called run_analysis.R that does the following.
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names.
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
> Good luck!

##Files description

- run_analysis.R: R script does above 5 steps
- UCITidy\_byCQLi.txt: tidy data set created by run_analysis.R script. 
- readme.md: readme markdown file
- codebook.md: markdown file explains the vairables in script and tidy data file "UCITidy\_byCQLi.txt"


##Explanation of run_analysis.R

This script load following libraries: dplyr,data.table,tidyr,reshape2, and get current working directory

    library(dplyr)
    library(data.table)
    library(tidyr)
    library(reshape2)
    
    path <- getwd()

Next, check if the zip file is in the working directory. If the zip file has not been downloaded, this script will download the file. Then unzip the zip file into current working directory. 
       
    
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

After all the files extracted, script will load data files which will be processed in the script.

        file_trainx<-fread("./UCI HAR Dataset/train/x_train.txt")
    
     	file_trainy<-fread("./UCI HAR Dataset/train/y_train.txt")
    	.....



Finally, a tidy data set ("dt_final") is created, the average of each variable for each activity and each subject is calculated. 
    
    	setkey(dt_newdata,subject,activity,domain,instrument, acceleration,Jerk,magnitue,method,Axis)
     
    	 dt_final<-dt_newdata[, list( meanvalue = mean(value)), by=key(dt_newdata)]

For the details, please refer to the comments in the script.

##Output

- Data file "UCITidy\_byCQLi.txt" contains the tidy data set required in step 5. It is a tab-delimited text file.  
