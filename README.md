================================================
Getting and Cleaning Data Course Project ReadMe
================================================

The script relies on tidyr and dplyr (v0.4.0) packages and requires the working directory to be set to the root of the Samsung data folder. The script contains checks if the required packages are installed, and if not - installs them. If dplyr package older than v0.4.0 is installed in R, it will be removed and re-installed to make sure the latest available version is installed.
If the script fails to read data files, it will throw an error about the working directory not being set to the root of the folder with the Samsung data and will stop execution.

The following describes how the script works:
1. All data files are read into data frames and assigned to corresponding variables (I've tried reading the files into data.table using fread() to speed up the process, but that made my R 3.1.2 crash on Mac OS (Yosemite) trying to read X_test.txt and X_train.txt). For test_df (X_test.txt) and train_df (X_train.txt) col.names are set to the names of measurements - column 2 of the 'features' data frame. All whitespace and parenthesis chars in the measurement names are converted to dots by R automatically.

2. Main test and train data frames are clipped with their corresponding 'subject' (subject_test/subject_train) and 'activity_id' (y_test.txt/y_train.txt) data frames using bind_cols() (introduced in dplyr v0.4.0)

3. Two resulting data frames are then clipped together into one large data frame (main_df) using bind_rows() (introduced in dplyr v0.4.0)

4. The main data frame (main_df) is merged with the activity_labels data frame (activity_labels.txt) by activity_label_id column, this introduces activity names column ('activity') in the main data frame.

5. 'subject', 'activity' and all measurement columns with names that contain 'mean()' and 'std()' are extracted from main_df by executing select() on main_df and re-assigning the result to itself.

6. The measurement column names are tidied by performing the following regex replacements:
	- all trailing dots are removed
	- multiple consecutive dots are replaced with one dot
	- all leading 't' chars in column names are replaced with 'time.'
	- all leading 'f' chars in column names are replaced with 'frequency.'
	
As a result, all measurement names now look as follows: 'time.BodyGyroJerk.mean.X', 'frequency.BodyBodyAccJerkMag.std', etc.

7. All measurement columns in main_df are gathered into 'measurement' and 'value' columns by executing gather() on main_df.

8. Measurement column is separated into four columns ('measurementtype', 'measurement', 'aggregation', 'axis') by executing separate() on the main_df using '.' as a separator. This introduces some NAs in the 'axis' column due to certain measurements do not contain information about axis (eg.:'tBodyBodyGyroJerkMag').

9. main_df is grouped by each variable (apart from 'value') by executing group_by() on it.

10. Average value is calculated for each group by executing summarize() on main_df and the result is stored in the 'meanvalue' column.

11. The resulting data frame is written to a file with the name "result_dataset.txt".

The resulting data set is tidy, because:
	- It has one variable in each column
	- It has one observation in each row
	- There is one table for each 'kind' of variable

The data set contains descriptive activity names instead of activity ids. The data set variable names are descriptive, they are not abbreviated, do not contain underscores/whispaces/etc.
