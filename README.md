The entire analysis is contained in one script 'run_analysis.R'.
The script assumes that the folder called 'UCI HAR Dataset' is placed in the 
working directory and that the data set folder contains the folders 'train' and 'test'  
with files subject_*.txt, X_*.txt, y_*.txt where * is either 'train' or 'test'.

To run the script:

	source("run_analysis.R")

Use the following code to read the tidy data table in 'tidy.txt':

	tidydata <- read.table("tidy.txt", header = TRUE) 
	View(tidydata)
