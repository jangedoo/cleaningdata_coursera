#read the column/feature names
colNames <- read.csv('UCI HAR Dataset/features.txt',header=FALSE, sep='', stringsAsFactors=FALSE)$V2

#read the training file
trainData <- read.csv('UCI HAR Dataset/train/X_train.txt',header=FALSE,sep='')
#set the column names
names(trainData) <- colNames

#read the training label file
trainLabel <- read.csv('UCI HAR Dataset/train/y_train.txt', header=FALSE)
#set column name
names(trainLabel) <- 'y_label'

#read the training subject id
trainSubject <- read.csv('UCI HAR Dataset/train/subject_train.txt', header=FALSE)
#set column name
names(trainSubject) <- 'subject_id'


#bind those dataframes together
train.Final = cbind.data.frame(trainData, trainLabel, trainSubject)



#read the testing file
testData <- read.csv('UCI HAR Dataset/test/X_test.txt', header=FALSE, sep='')
#set the column names
names(testData) <- colNames

#read the testing label file
testLabel <- read.csv('UCI HAR Dataset/test/y_test.txt', header=FALSE)
#set the column names
names(testLabel) <- 'y_label'

#read the testing subject id
testSubject <- read.csv('UCI HAR Dataset/test/subject_test.txt', header=FALSE)
#set the column names
names(testSubject) <- 'subject_id'


#bind the columns for test data together
test.Final <- cbind.data.frame(testData, testLabel, testSubject)



#finally merge the testing and training data
merged.Data <- rbind(train.Final, test.Final)



#### step: 2 Extract only the measurement on mean and std deviation
filtered.Data <- merged.Data[c(colNames[grepl('mean()|std()',colNames)], 'subject_id','y_label')]


#### step: 3 Apply descriptive activity names

#load the activity names
activity.Names <- read.csv('UCI HAR Dataset/activity_labels.txt', header=FALSE, sep='')
#assign column names
names(activity.Names) <- c('y_label', 'activityName')

#merge so that that the data frame has descriptive activity names
filtered.Data <- merge(filtered.Data, activity.Names)



#### Step: 4

#replace parenthesis and spaces with nothing
names(filtered.Data) <- gsub('\\(|\\)|\\s', '', names(filtered.Data))

#replace hyphens and commas with "_"
names(filtered.Data) <- gsub('-|,', '_', names(filtered.Data))

#### Step: 5
filtered.Data$y_label <- as.factor(filtered.Data$y_label)
filtered.Data$subject_id <- as.factor(filtered.Data$subject_id)
filtered.Data$activityName <- as.factor(filtered.Data$activityName)

#take mean of numeric columns only 
#(1st col is y_label, and 81st and 82nd columns are subject_id and activityName respectively)
#so omit them
workingColumns <- names(filtered.Data)[2:80]

#build a sql query for grouping and aggregation
sql<- paste(' select activityName, subject_id, ', paste('avg(', workingColumns, ')', collapse=', '), 'from [filtered.Data] group by activityName, subject_id')

#load the sqldf library
library(sqldf)

#execute the sql query to get the "tidy data"
tidy.Data <- sqldf(sql)

write.csv(tidy.Data, file='tidy.Data.txt', row.names=FALSE)
