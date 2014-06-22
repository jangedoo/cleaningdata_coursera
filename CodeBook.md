Data collected from the accelerometers from the Samsung Galaxy S smartphone needs to be analyzed. For full description please visit http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

For this project, the data was downloaded from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Run the 'run_analysis.R' file to obtain the average of every variable for each activity and participant. The code performs the following transformations:

* First read the column names from features.txt
* Then read the training data (features), label, and participant's id from the files X_train.txt, y_train.txt, and subject_train.txt respectively in the 'train' directory
* Assign the column names to the training data, 'y_label' for label and 'subject_id' for participant id

* Similarly read the testing data, label and participant id from files X_test.txt, y_test.txt, and subject_test.txt from the 'test' directory
* Assign the column names as above

* Bind the data together, first using cbind() function to bind the columns for testing and training data separetely and finally using rbind() to merge both training and testing data set. This will produce a data frame of 10299 rows and 536 columns.
* Extract only the columns that contain "mean" and "std", because these columns are of interest to us. This produces a filtered data of 81 columns only.
* We assign a descriptive activity name by using merge() function. This will produce a data set of 82 columns.

* To tidy up the column names a bit, we replace "(", ")", and spaces with nothing and replace hyphens and commas with an underscore.

* Finally to extract the average of each columns for each activity and participant, we use 'sqldf' library. The "tidy data" contains 180 rows with 81 columns.

In the "tidy data"
* activityName is the type of activity under consideration
* subject_id is the id of the participant
* columns with names like avg(...) are the average of some measurement for the particular activity for particular participant. For more details about the columns, see features_info.txt file in the archive downloaded from the link above.
