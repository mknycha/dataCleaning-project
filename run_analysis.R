##Loading data
trainData<-read.csv("./UCI HAR Dataset/train/X_train.txt", sep="")
trainLabels<-read.csv("./UCI HAR Dataset/train/Y_train.txt", sep="")
trainSubject<-read.csv("./UCI HAR Dataset/train/subject_train.txt", sep="")
testData<-read.csv("./UCI HAR Dataset/test/X_test.txt", sep="")
testLabels<-read.csv("./UCI HAR Dataset/test/Y_test.txt", sep="")
testSubject<-read.csv("./UCI HAR Dataset/test/subject_test.txt", sep="")
features<-read.csv("./UCI HAR Dataset/features.txt", sep="", header=FALSE)
activities<-read.csv("./UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

##Load necessary packages 
library(plyr)
library(dplyr)
library(tidyr)


##2.Extracts only the measurements on the mean and standard deviation for each measurement.
##Filtering variables for those calculating mean and standard deviation
meanFilter<-grep("mean()",features[,2], fixed=TRUE)
stdFilter<-grep("std()",features[,2], fixed=TRUE)
varFilter<-unique(c(meanFilter,stdFilter))
filteredData1<-testData[,varFilter]
colnames(filteredData1)<-features[varFilter,2]
filteredData2<-trainData[,varFilter]
colnames(filteredData2)<-features[varFilter,2]


##1.Merges the training and the test sets to create one data set.

##I have done it the other way, just to join two smaller data sets.
filteredData<-rbind(filteredData1,filteredData2)
##I am also merging the same way two other tables - for Labels and Subjects
jointLabels<-rbind(trainLabels,testLabels)
colnames(trainSubject)<-colnames(testSubject)
jointSubjects<-rbind(trainSubject,testSubject)


##3.Uses descriptive activity names to name the activities in the data set

##For the table containing label data, I am changing the number into activity name
label<-function(x) {as.character((filter(activities,V1==x)$V2))}
for (i in seq_along(jointLabels$X5)) {
    jointLabels$X5[i]<-label((jointLabels$X5[i]))
}
##Changing the column name in the table with labels and adding this 
##column to filteredData 
colnames(jointLabels)<-"activity"
filteredData<-cbind(filteredData,jointLabels)
##Changing the column name in the table with subjects and adding this 
##column to filteredData
colnames(jointSubjects)<-"subject"
filteredData<-cbind(filteredData,jointSubjects)


##4.Appropriately labels the data set with descriptive variable names.
colnames(filteredData)<-gsub("[- .()]","",colnames(filteredData))
colnames(filteredData)<-tolower(colnames(filteredData))


##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Melting data
tempData<-gather(filteredData, subject, activty, tbodyaccmeanx:fbodybodygyrojerkmagstd)
##Changing column names
colnames(tempData)[3:4]<-c("measure","value")
##Using ddply to calculate the average of each variable for each activity and each subject
tidyData<-ddply(tempData, .(activity, subject, measure),summarize, averagevalue=mean(value))
##Ordering table by subject no.
tidyData<-arrange(tidyData, subject)