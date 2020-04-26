#downloading data
urlpath <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(urlpath, destfile = "../dataset/dataset.zip")
unzip(zipfile = "../dataset/dataset.zip", exdir = "./data")
X_train <- read.table(unz(temp, "../train/X_train.txt"))

#Loading data
X_train <- read.table("../data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("../data/UCI HAR Dataset/train/Y_train.txt")
S_train <- read.table("../data/UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("../data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("../data/UCI HAR Dataset/test/Y_test.txt")
S_test <- read.table("../data/UCI HAR Dataset/test/subject_test.txt")

#Merging the training set and test sets to create one data set
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
S <- rbind(S_train, S_test)

#Loading features and activities
features <- read.table("../data/UCI HAR Dataset/features.txt")
activities <- read.table("../data/UCI HAR Dataset/activity_labels.txt")
activities <- as.character(activities[,2])

#Extracting only the measurements on the mean and standard deviation for each measurement
Cols <- grep("-(mean|std).*", as.character(feature[,2]))
ColNames <- feature[Cols, 2]
ColNames <- gsub("-mean", "Mean", ColNames)
ColNames <- gsub("-std", "Std", ColNames)
ColNames <- gsub("[-()]", "", ColNames)

#Using descriptive activity names to name the activities in the data set
X <- X[Cols]
Data <- cbind(S, Y, X)
colnames(Data) <- c("Subject", "Activity", ColNames)
Data$Activity <- factor(Data$Activity, levels = a_label[,1], labels = a_label[,2])
Data$Subject <- as.factor(Data$Subject)

#Tidy dataset
tempData <- melt(Data, id = c("Subject", "Activity"))
finalData <- dcast(tempData, Subject + Activity ~ variable, mean)

write.table(finalData, "../finalData.txt", rownames = FALSE, quote = FALSE)