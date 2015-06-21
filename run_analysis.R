## some functions from other packages are used in the script
library(data.table)
library(plyr)

## read in the activity labels and give proper column names
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names=c("activity_nr","activity_name"))

## read in the list of data features
features <- read.table("./UCI HAR Dataset/features.txt")

## read in the test data set and assign proper column names
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",col.names="subject_nr")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names=features[,"V2"])
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",col.names="activity_nr")

## read in the training data set and assign proper column names
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",col.names="subject_nr")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt",col.names=features[,"V2"])
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",col.names="activity_nr")

## assign the proper activity name to activity index
y_test <- join(y_test,activity_labels)
## put together the phone data with the activities and subjects
common_test <- cbind(subject_test,y_test,X_test)

## assign the proper activity name to activity index
y_train <- join(y_train,activity_labels)
## put together the phone data with the activities and subjects
common_train <- cbind(subject_train,y_train,X_train)

## simply put the two part data sets (train,test) together
common_data <- rbind(common_test,common_train)

## find the columns that represent either a calculated mean or standard 
## deviation for any variable
nec_col <- sort(c(grep("mean..",colnames(common_data),fixed=TRUE),grep("std..",colnames(common_data),fixed=TRUE)))

## filter out the required columns found with the command above, the number 
## of the subject and activity name is included
common_data <- common_data[c(1,3,nec_col)]

## with an aggregate function the mean value of each variable is calculeted for
## each distinct subject and his activity
result_data <- aggregate(common_data,list(Subject=common_data$subject_nr,Activity=common_data$activity_name),mean)

## we delete the tidy data file to have a clear starting point
file.remove("tidy_data.txt")

## the result data is written in a tab separated text file sorted by the subject
## index, only the necessary columns are written in the file, column 3,4 do not
## carry any additional info
write.table(arrange(result_data[c(1,2,5:ncol(result_data))],Subject),"tidy_data.txt",sep="\t",row.names=FALSE)