SETUP: Human Activity Recognition Using Smartphones Dataset published in [1]

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012 


'Raw' data: 
Data set is divided into train and test with text files containing data on: 
	subject   [subject_train.txt, subject_test.txt] (30 subjects identified by integers 1 to 30, divided into train (70%) 	and test groups (30%)) ;
	activity [y_train.txt, y_test.txt] (integers 1 to 6 corresponding to activities indicated in activity_labels.txt);
	features   [X_train.txt, X_test.txt] (measurement values of 561 feature vector whose variable names are indicated in 	features.txt);

Goals:
1. Merge training and test sets to create one data set. 
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set. 
4. Appropriately label the data set with descriptive variable names. 
5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.


Codebook:

PRELIMINARY STEP: Load file contents into workspace.
	Read feature variable names from features.txt, drop the numbers and just save the names.
	Read activity labels activity_labels.txt, drop the numbers and just save the names.
	Read train dataset into 'train'.
	Read test dataset into 'test'.

STEP 1: Merge 'train' and 'test' data tables into a data table called 'data'.
	Rename variables of 'data' as "subject","feature_vector","activity" 
	corresponding to reading files 'subject_*.txt', 'X_*.txt', and 'y_*.txt' respectively:
		subject is saved as an integer (just for arranging purposes); 
		feature_vector initially a long string;
		activity is saved as a factor

STEP 2: Extract only the measurements on the mean and standard deviation for each measurement.
	Find feature variables that are mean and std only, those with 'mean-()' and 'std-()'.
	This results to 66 feature-variables out of the 561 features.
	meanFrequency measurements are rejected since these do not correspond to the mean of a certain 
	variable but is instead the weighted average of the frequency components to obtain a mean frequency.

	A function is defined to extract just the values of the feature vector (a long string) 
	that correspond to mean and std and returns it as a numeric column vector. 
	This function is looped through the entire number of observations to create a 10299 x 66 numeric data table.
	Then the long string 'feature_vector' column is deleted from the preliminary data set. 

STEP 3: Use descriptive activity names for 'activity' column in 'data'. 
	1 to 'WALKING'
	2 to 'WALKING_UPSTAIRS'
	3 to 'WALKING_DOWNSTAIRS'
	4 to 'SITTING'
	5 to 'STANDING'
	6 to 'LAYING'

STEP 4: Appropriately label the data set with descriptive variable names.
	Names in features.txt are used but '()' in the names are dropped and '-' are replaced with '_'.
	ex: 'tBodyAcc-mean()-X' to 'tBodyAcc_mean_X'.
	The columns of feature variables are then appended to the data table 'data'.


'data' is now at its final form with 10299 observations and 68 variables (subject, activity, 66 features )
and is ready for STEP 5.

STEP 5: From 'data' a second, independent tidy data set called 'mean_subjectactivity' 
with the average of each variable for each activity and each subject is created by
grouping 'data' by subject and activity and then applying the average to the 66 feature variables.
Variable names are still the same but the size of the data table is reduced from 10299 x 68
to 180 x 68, 180 coming from 30 (subjects) x 6 (activities). 

This tidy data table is written out into 'tidy.txt' in the current working directory.
