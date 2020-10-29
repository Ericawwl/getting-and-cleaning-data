files<-list.files("./UCI HAR Dataset", recursive = T)
path<-file.path('./UCI HAR Dataset')
getwd()
setwd("/Users/ericawang/learning/learning/getting and cleaning data")t
Ytest<-read.table(file.path(path, 'test', 'Y_test.txt'), header = F)
Ytrain<-read.table(file.path(path, 'train', 'Y_train.txt'), header = F)
Stest<-read.table(file.path(path, 'test', "subject_test.txt"), header = F)
Strain<-read.table(file.path(path, 'train', 'Subject_train.txt'), header=F)
Xtest<-read.table(file.path(path, 'test', "X_test.txt"), header = F)
Xtrain<-read.table(file.path(path, 'train', 'X_train.txt'), header=F)
lapply(c(Xtest, Xtrain),str)

subject<-rbind(Strain, Stest)
activity<-rbind(Ytrain, Ytest)
features<-rbind(Xtrain,Xtest)
featurenames<-read.table(file.path(path, "features.txt"), header=F)
names(features)<-featurenames$V2
names(subject)<-c('subject')
names(activity)<-c('activity')
data<-cbind(subject, activity,features)
subdatafeturename<-featurenames$V2[grep('mean\\(\\)|std\\(\\)', featurenames$V2)]
selectednames<-c(as.character(subdatafeturename), "subject", "activity")

data2<-data[,names(data) %in% selectednames]
activity_names<-read.table(file.path(path, 'activity_labels.txt'), header = F)
head(activity_names)
data2$activity<-factor(data2$activity, levels=activity_names$V1, labels = activity_names$V2)
data2$subject<-as.factor(data2$subject)
names(data2)<-gsub("^t", "time", names(data2))
names(data2)<-gsub('^f', 'frequency', names(data2))
names(data2)<-gsub('Acc', "Accelerometer", names(data2))
names(data2)<-gsub("Gyro", "Gyroscope", names(data2))
names(data2)<-gsub("Mag", "Magnitute", names(data2))
names(data2)<-gsub("BodyBody", "Body", names(data2))
names(data2)

library(dplyr)
data3<-aggregate(.~subject+activity, data2, mean)
head(data3)

write.table(data3, file = 'tidydata.txt', row.names = F)
