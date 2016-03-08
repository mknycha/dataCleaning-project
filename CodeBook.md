# Code Book

Source of the raw data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The raw data is made of tables in seperate files, from which one contains 561 variables.
In order for this script to work, unzipped folder from this source must be located in the R workspace.

##How does it work?
The script takes several steps in order to clean the data:
0. Load all the necessary data:
    -trainData (UCI HAR Dataset/train/X_train.txt)
    -trainLabels (UCI HAR Dataset/train/Y_train.txt)
    -trainSubject (UCI HAR Dataset/train/subject_train.txt)
    -testData (UCI HAR Dataset/test/X_test.txt)
    -testLabels (UCI HAR Dataset/test/Y_test.txt)
    -testSubject (UCI HAR Dataset/test/subject_test.txt)
    -features (UCI HAR Dataset/features.txt)
    -activities (UCI HAR Dataset/activity_labels.txt)
1. Filter only the measurements on the mean and standard deviation for each measurement (from features table).
2. Merge the filtered training and the filtered test sets - this way we we get:
    -A table filteredData containing filtered measurements from both sets trainData & testData (I filtered only columns, not rows!).
    -A table jointLabels containing data from both sets trainLabels & testLabels.
    -A table jointSubjects containing data from both sets trainSubject & testSubject.
3. Use descriptive activity names to name the activities in the data set.
    jointLabels includes only number corresponding to each activity. These numbers are described in activities table.
    Script replaces the numbers in jointLabels with their corresponding description.  
4. Appropriately labels the data set with descriptive variable names.
    Since the variable names should be in lower cases and not contain special characters, 
    the script removes characters "-", space, dot and brackets from the variable names and changes all of them to lower cases.
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
    Script melts the data so that there would be just four columns: subject, activity, measurement, and value related to particular measurement.
    Then, it creates a summary by calculating mean of each measurement for each activity and each subject (using ddply function)
##What is the output?
The output after running script "run_analysis.R" from the repository is "tidyData" table.
There are four columns in it:
- subject - identification number of a subject taking part in the research,
- activity - description of an activity performed by the subject,
- measurement - short code of a measurement from the research, please see features.txt file from the source for further description,
- value - value of particular measurement.
