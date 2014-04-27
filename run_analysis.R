setwd ('coursera')
setwd ('UCI HAR Dataset')


##########
# 1 .Merging data sets
#########

# 1.a loading data

x_test<-read.table("test/X_test.txt", header=FALSE,sep="")
y_test<-read.table("test/y_test.txt")

subjectx<-read.table("test/subject_test.txt")


x_train<-read.table("train/X_train.txt", header=FALSE,sep="")
y_train<-read.table("train/y_train.txt")
subjectt<-read.table("train/subject_train.txt")

#1.b Mergin data
x<-rbind(x_train,x_test)
subjects<-rbind(subjectx,subjectt)
y<-rbind(y_test,y_train)

# 2.Extracting the measurements on the mean and standard devation for each measurement
# Using stuff for week 4 lectures here. It is the easiest way even though we are in week 3 now.
features<-read.table("features.txt")
indices_features<-grep("-mean\\(\\)|-std\\(\\)", features[,2])
x<-x[,indices_features]
names(x)<-features[indices_features,2]
names(x)<-gsub("\\(|\\)","",names(x))
names(x)<-tolower(names(x))

# 3. Using descriptive activity names to name the activities in the data set
# more stuff from week 4
activities<-read.table("activity_labels.txt")
activities[,2]=gsub("_","",tolower(as.character(activities[,2])))
y[,1]<-activities[y[,1],2]
names(y)<-"activity"


# 4. Labeling the data set with descriptive activity names.

names(subjects)<-"subject"
datacleaned<-cbind(subjects,y,x)
write.table(data_cleaned,"tidydataset.txt")

# 5. Creating a second independent data set with the average of each variable for 
# each activity  and each subject.
library(data.table)
datacleaneddt<-data.table(datacleaned)
dataaverages<-datacleaneddt[,lapply(.SD,mean),by=c("subject","activity")]

write.csv(dataaverages,"tidydataaverages.csv", row.names=FALSE)



