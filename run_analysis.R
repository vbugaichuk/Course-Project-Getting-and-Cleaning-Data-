#downloading data
urlpath <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(urlpath, destfile = "dataset.zip")
unzip(zipfile = "dataset.zip", exdir = "./data")

#Loading data
X_train <- read.table("E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/data/UCI HAR Dataset/train/y_train.txt")
S_train <- read.table("E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/data/UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/data/UCI HAR Dataset/test/y_test.txt")
S_test <- read.table("E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/data/UCI HAR Dataset/test/subject_test.txt")

#Merging the training set and test sets to create one data set
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
S <- rbind(S_train, S_test)

#Loading features and activities
features <- read.table("E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/data/UCI HAR Dataset/features.txt")
activities <- read.table("E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/data/UCI HAR Dataset/activity_labels.txt")
activities[,2] <- as.character(activities[,2])

#Extracting only the measurements on the mean and standard deviation for each measurement
Cols <- grep("-(mean|std).*", as.character(features[,2]))
ColNames <- features[Cols, 2]
ColNames <- gsub("-mean", "Mean", ColNames)
ColNames <- gsub("-std", "Std", ColNames)
ColNames <- gsub("[-()]", "", ColNames)

#Using descriptive activity names to name the activities in the data set
X <- X[Cols]
Data <- cbind(S, Y, X)
colnames(Data) <- c("Subject", "Activity", ColNames)
Data$Activity <- factor(Data$Activity, levels = activities[,1], labels = activities[,2])
Data$Subject <- as.factor(Data$Subject)

#Tidy dataset
tempData <- melt(Data, id = c("Subject", "Activity"))
finalData <- dcast(tempData, Subject + Activity ~ variable, mean)

write.table(finalData, "E:/Data Science with R/Course-Project-Getting-and-Cleaning-Data-/finalData.txt", row.names = FALSE, quote = FALSE)