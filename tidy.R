# Tidy data
# Author: Sanjay Kumar
# Data: 28-OCT-2018

#initialize
data<-""
X<-""
Y<-""

# Read label data
activity_label<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/activity_labels.txt')
features<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/features.txt')
#features_info<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/features_info.txt')

# Read training data
subtrain<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/train/subject_train.txt')
X_train<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/train/X_train.txt')
Y_train<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/train/Y_train.txt')

# Read test data
subtest<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/test/subject_test.txt')
X_test<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/test/X_test.txt')
Y_test<-data.table::fread('C:/Users/sanjayx/Desktop/prog/UCI/test/Y_test.txt')



#Label data
colnames(activity_label)<-c("activity_id","activity")
colnames(features)<-c("feature_id","feature")
colnames(subtrain)<-c("subject_id")
colnames(subtest)<-c("subject_id")
colnames(X_train)<-unlist(features[,2])
colnames(X_test)<-unlist(features[,2])
colnames(Y_train)<-c("activity_id")
colnames(Y_test)<-c("activity_id")

# 1 Merges the training and the test sets to create one data set.
# Merge test and training
subject<-rbind(subtrain,subtest)
X<-rbind(X_train,X_test)
Y<-rbind(Y_train,Y_test)
data<-cbind(subject,X)
data<-cbind(data,Y)
dim(data)

#2 Extracts only the measurements on the mean and standard deviation 
# for each measurement. 
colnames=names(data)
x1=grep("subject_id",colnames)
x2<-grep("activity_id",colnames)
x3<-grep("mean",colnames)
x4<-grep("std",colnames)
x<-append(x1,x2)
x<-append(x,x3)
x<-append(x,x4)
colnames[x]

# std and mean related column subset
std_mean<-data[, names(data)[c(x)], with = FALSE]

#3 Uses descriptive activity names to name the activities in the data set
std_mean_with_name<-""
std_mean_with_name<-merge(std_mean,activity_label,by='activity_id',all.x=TRUE)

#4.Appropriately labels the data set with descriptive variable names. 
# it is already labeled with std_mean<-data[, names(data)[c(x)], with = FALSE]

#5 From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.

 tidymean<-aggregate(std_mean_with_name,list(subject_id=std_mean_with_name$subject_id,activity_id=std_mean_with_name$activity_id),mean,na.rm=TRUE)
 
data.table::fwrite(tidymean,'c:/users/sanjayx/desktop/tidydata.txt')







