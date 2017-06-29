library(plyr)

## Download and unzip the dataset:

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
directory<-"data.zip"
download.file(fileUrl,directory)
unzip(directory)
setwd('./UCI HAR Dataset/')

# Step 1
# Merge the training and test sets to create one data set


x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")


x_data <- rbind(x_train, x_test)    # create 'x' data set
y_data <- rbind(y_train, y_test)    # create 'y' data set
subject_data <- rbind(subject_train, subject_test)    # create 'subject' data set


# Step 2
# Extract the columns that contain the mean or the standard deviation

features <- read.table("features.txt")
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])# get columns with mean() or std() in their names
x_data <- x_data[, mean_std]     # subset with the selected columns
names(x_data) <- features[mean_std, 2]   # correct the column names


# Step 3
# Label the activities names in the data set with the descriptive activity data

activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]   # update values with correct activity names
names(y_data) <- "activity"   # correct column name


# Step 4
# Label the data set with descriptive variable names

names(subject_data) <- "subject"   # correct column name
complete_data <- cbind(subject_data, y_data, x_data)  # join all the data in a one data set


# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

average_data <- ddply(complete_data, .(subject, activity), function(x) colMeans(x[, 3:68]))
write.table(average_data, "average_data.txt", row.name=FALSE)



