library(reshape2)
#Download the data file and unzip it in working directory
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "proj_dataset.zip")
unzip("proj_dataset.zip")

#Load the data and feature names
features <- read.table("features.txt")
featuresselected <- grep(".*mean.*|.*std.*",features[,2])
featuresnames <- features[featuresselected,2]

featuresnames<-gsub("[-()]","",featuresnames)

activitylbl <- read.table("activity_labels.txt")

xtest<-read.table("test/X_test.txt")[featuresselected]
testact <- read.table("test/y_test.txt")
testsub <- read.table("test/subject_test.txt")


xtrain<-read.table("train/X_train.txt")[featuresselected]
trainact <- read.table("train/y_train.txt")
trainsub <- read.table("train/subject_train.txt")

#merge the test and training data set
test <- cbind(testsub,testact,xtest)
train <- cbind(trainact,trainsub,xtrain)
mergeddata <- rbind(train,test)

# Assign proper column names
colnames(mergeddata) <- c("Subject","Activity",featuresnames)
mergeddata$Activity <- factor(mergeddata$Activity, levels = activitylbl[,1], labels = activitylbl[,2])
mergeddata$Subject <- as.factor(mergeddata$Subject)

#Melt and dcast the data in required format
meltdata <- melt(mergeddata, id = c("Subject","Activity"))
dcastdata <- dcast(meltdata, Subject + Activity ~ variable,mean)

#write to the file
write.table(dcastdata,"tidy.txt",row.names = FALSE, quote = FALSE)
