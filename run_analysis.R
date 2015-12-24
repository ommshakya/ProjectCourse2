getwd()
setwd("D:\\01 01 0001 oms\\R.Learning")

if(!file.exists("course2"))
        dir.create("course2")

if(!file.exists("./C2ProjectData")){dir.create("./C2ProjectData")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./C2ProjectData/Dataset.zip")

list.files("./C2ProjectData")

##Unzip the file
unzip(zipfile="./C2ProjectData/Dataset.zip",exdir="./C2ProjectData")

##View all the files of unzipped folder
filePath <- file.path("./C2ProjectData" , "UCI HAR Dataset")
allFiles<-list.files(filePath, recursive=TRUE)
allFiles

##Read activity files
activityTestData  <- read.table(file.path(filePath, "test" , "Y_test.txt" ),header = FALSE)
activityTrainData <- read.table(file.path(filePath, "train", "Y_train.txt"),header = FALSE)
head(activityTestData)
head(activityTrainData)

##Read the subject files
subjectTrainData <- read.table(file.path(filePath, "train", "subject_train.txt"),header = FALSE)
subjectTestData  <- read.table(file.path(filePath, "test" , "subject_test.txt"),header = FALSE)
head(subjectTrainData)
head(subjectTestData)

##Read the features files
featuresTestData  <- read.table(file.path(filePath, "test" , "X_test.txt" ),header = FALSE)
featuresTrainData <- read.table(file.path(filePath, "train", "X_train.txt"),header = FALSE)
head(featuresTestData)
head(featuresTrainData)

##Give a look on structure of above data
str(activityTestData)
str(activityTrainData)
str(subjectTrainData)
str(subjectTestData)
str(featuresTestData)
str(featuresTrainData)

##1. Merges the training and the test sets to create one data set.
##1.1 Combine data
subjectData <- rbind(subjectTrainData, subjectTestData)
activityData<- rbind(activityTrainData, activityTestData)
featuresData<- rbind(featuresTrainData, featuresTestData)
##1.2 Naming variables
names(subjectData)<-c("subject")
names(activityData)<- c("activity")
dataFeaturesNames <- read.table(file.path(filePath, "features.txt"),head=FALSE)
names(featuresData)<- dataFeaturesNames$V2
##1.3 Merge column names and prepare Data Frame
combinedData <- cbind(subjectData, activityData)
Data <- cbind(featuresData, combinedData)
Data

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##2.1 Subset Name of Features by measurements on mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
subdataFeaturesNames

##2.2 Subset Data Frame Data by seleted names of Features
namesSelected<-c(as.character(subdataFeaturesNames), "subject", "activity" )
DataNamesSelected<-subset(Data,select=namesSelected)
##2.3 Give a look on the structure
str(DataNamesSelected)

##3 Uses descriptive activity names to name the activities in the data set
##3.1 Read descriptive activity names from “activity_labels.txt”
activityLabels <- read.table(file.path(filePath, "activity_labels.txt"),header = FALSE)
head(DataNamesSelected$activity,30)

##4 Appropriately labels the data set with descriptive variable names. 
names(DataNamesSelected)<-gsub("^t", "time", names(DataNamesSelected))
names(DataNamesSelected)<-gsub("^f", "frequency", names(DataNamesSelected))
names(DataNamesSelected)<-gsub("Acc", "Accelerometer", names(DataNamesSelected))
names(DataNamesSelected)<-gsub("Gyro", "Gyroscope", names(DataNamesSelected))
names(DataNamesSelected)<-gsub("Mag", "Magnitude", names(DataNamesSelected))
names(DataNamesSelected)<-gsub("BodyBody", "Body", names(DataNamesSelected))

names(DataNamesSelected)
##5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr);
DataSecond<-aggregate(. ~subject + activity, DataNamesSelected, mean)
DataSecond<-DataSecond[order(DataSecond$subject,DataSecond$activity),]
write.table(DataSecond, file = "tidydata.txt",row.name=FALSE)



