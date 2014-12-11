# Load necessary libraries

library(data.table)
library(dplyr)
library(tidyr)

#Set directory where data is located, assuming UCI folder is placed in working
#directory
wd<-getwd()
datadir<-paste0(wd,"/",grep("^UCI",list.files("."),value = T))

# PRELIMINARY STEP: Load file contents into workspace

#Read features vector from text file, drop the numbers and just save the names 

second <- function(x){x[2]} #function for extracting second element of vector

features <- sapply(
                    strsplit(
                            readLines(paste0(datadir,"/features.txt"),encoding="UTF-8")          
                            ," ")

                    ,second)
#Read activity labels from text file, drop the numbers and just save the names
activity <- sapply(
                  strsplit(
                            readLines(paste0(datadir,"/activity_labels.txt"),encoding="UTF-8")
                          ," ")
                  ,second)

#Read train dataset
dirtrain = paste0(datadir,"/train/")
trainfiles = grep("txt$",list.files(dirtrain,include.dirs = T),value = T)
train = as.data.table(
                      lapply( 
                              sapply(dirtrain,paste0,trainfiles)   
                      ,readLines)
                      )

#Read test dataset
dirtest = paste0(datadir,"/test/")
testfiles = grep("txt$",list.files(dirtest,include.dirs = T),value = T)
test = as.data.table(
                     lapply( 
                            sapply(dirtest,paste0,testfiles)   
                     ,readLines)
                     )

# STEP 1: Merge train and test dataset
data<-rbind.data.frame(train,test)
rm(train,test)

# Rename variables
setnames(data, c("subject","feature_vector","activity"))
#Subject as integer (just for arranging purposes) and activity as factor
data[,c("subject","activity"):=list(as.integer(subject),as.factor(activity))]


# STEP 2: Extract only the measurements on the mean and standard deviation for
# each measurement.

# Find feature variables that are mean and std only
indexmean = grep("-mean.)",features) #This regular expression excludes features with 'meanFreq'
indexstd = grep("-std",features)


#Define function that extracts just the values of the feature vector (a long
#string) that correspond to mean and std
feat<- function(x,indexmean,indexstd){
  x = unlist( strsplit(x," ") ) #split longstring and save into character vector
  x = x[sapply(x,nchar)>0] # drop null strings
  as.numeric(x)[c(indexmean,indexstd)] #choose only elements with 'mean' and 'std'
}


#Loop through the entire number of observations to create a 10299 x 66 numeric
#matrix
temp_data=NULL
for (i in seq(1,nrow(data)))
{  temp_data= rbind(temp_data,feat(data$feature_vector[i],indexmean,indexstd))
}

temp_data=as.data.table(temp_data)

#Delete long string feature vector column
data[,feature_vector:=NULL]


# STEP 3 Use descriptive activity names to name the activities in the data set 
setattr(data$activity,"levels",activity)

# STEP 4: Appropriately label the data set with descriptive variable names
# Drop '()' and replace '-' with '_'
namefeat_mean_std<-gsub("-","_",gsub(".)","",features[c(indexmean,indexstd)]))
setnames(temp_data,namefeat_mean_std)

#Append columns of feature variables to data table 'data'
data<-cbind.data.frame(data,temp_data)
rm(temp_data)


#Data is now at its final form and is ready for STEP 5

# STEP 5: From the data set in step 4, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.

data<-tbl_dt(data)


mean_subjectactivity <-
  data %>%
  arrange(subject) %>%
  group_by(subject,activity)%>%
  summarise_each(funs(mean))

write.table(mean_subjectactivity,"tidy.txt",row.name=FALSE)
