library(plyr);

# Read features
features     <- read.table("features.txt",header = FALSE)

# Read Train Data
trainFeatures     <- read.table("train/X_train.txt",col.names=features$V2,header = FALSE)
trainActivity <- read.table("train/Y_train.txt",col.names=c("activity"), header = FALSE)
trainSubject  <- read.table("train/subject_train.txt",col.names=c("id_subject"), header = FALSE)

# Read Test Data
testFeatures     <- read.table("test/X_test.txt",col.names=features$V2, header = FALSE)
testActivity <- read.table("test/Y_test.txt",col.names=c("activity"), header = FALSE)
testSubject  <- read.table("test/subject_test.txt",col.names=c("id_subject"), header = FALSE)

# Merge Activity, Subjects and data into three datasets
totalFeatures <- rbind(trainFeatures, testFeatures) 
totalActivity <- rbind(trainActivity, testActivity) 
totalSubject <- rbind(trainSubject, testSubject) 

# Merge again, combining the three total datasets into one
data <- cbind(totalSubject,totalActivity)
data <- cbind(data,totalFeatures)

# Extract mean and standard deviation for each measurement
data2 <- data[,(grep("*std|mean()", names(data)))]

# Set activity names in the dataset
activities <- read.table("activity_labels.txt",header = FALSE)
data$activity <- activities$V2[data$activity]

# Labels the data set with descriptive variable names
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

# Create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
# And order the final data set by id_subject and then id_activity
data3 <- aggregate(. ~id_subject + activity, data, mean)
data3 <- data3[order(data3$id_subject,data3$activity),]
write.table(data3, file ="finaldataset.txt",row.name=FALSE)
