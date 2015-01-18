### Getting and Cleaning Data Course Project ReadMe


The script relies on tidyr and dplyr (v0.4.0) packages and requires the working directory to be set to the root of the Samsung data folder. The script contains checks if the required packages are installed, and if not - installs them. If dplyr package older than v0.4.0 is installed in R, it will be removed and re-installed to make sure the latest available version is installed.  
If the script fails to read data files, it will throw an error about the working directory not being set to the root of the folder with the Samsung data and will stop execution.

The following describes how the script works:

1. All data files are read into data frames and assigned to corresponding variables (*I've tried reading the files into data.table using fread() to speed up the process, but that consistently made my R 3.1.2 crash on Mac OS (Yosemite) trying to read X\_test.txt and X\_train.txt*). For test\_df (X\_test.txt) and train\_df (X\_train.txt) col.names are set to the names of measurements - column 2 of the 'features' data frame. All whitespaces and parenthesis chars in the measurement names are converted to dots by R automatically.

2. Main test and train data frames are clipped with their corresponding 'subject' (subject_test/subject\_train) and 'activity\_id' (y\_test.txt/y\_train.txt) data frames using bind\_cols() (introduced in dplyr v0.4.0)

3. Two resulting data frames are then clipped together into one large data frame (main\_df) using bind\_rows() (introduced in dplyr v0.4.0)

4. The main data frame (main\_df) is merged with the activity\_labels data frame (activity\_labels.txt) by activity\_label\_id column, this introduces activity names column ('activity') in the main data frame.

5. 'subject', 'activity' and all measurement columns with names that contain 'mean()' and 'std()' are extracted from main\_df by executing select() on main\_df and re-assigning the result to itself.

6. The measurement column names are tidied by performing the following regex replacements:

	* all trailing dots are removed  
	* multiple consecutive dots are replaced with one dot  
	* all leading 't' chars in column names are replaced with 'time.'  
	* all leading 'f' chars in column names are replaced with 'frequency.'
	* as a result, all measurement names now look as follows: 'time.BodyGyroJerk.mean.X', 'frequency.BodyBodyAccJerkMag.std', etc.

7. All measurement columns in main\_df are gathered into 'measurement' and 'value' columns by executing gather() on main\_df.

8. Measurement column is separated into four columns ('measurementtype', 'measurement', 'aggregation', 'axis') by executing separate()  on the main_df using '.' as a separator. This introduces some NAs in the 'axis' column due to certain measurements do not contain information about axis (eg.:'tBodyBodyGyroJerkMag').

9. main\_df is grouped by each variable (apart from 'value') by executing group\_by() on it.

10. Average value is calculated for each group by executing summarize() on main\_df and the result is stored in the 'meanvalue' column.

11. The resulting data frame is written to a file with the name "result\_dataset.txt".

The resulting data set is tidy because:

* It has one variable in each column
* It has one observation in each row
* There is one table for each 'kind' of variable

The data set contains descriptive activity names instead of activity ids. The data set variable names are descriptive, they are not abbreviated, do not contain underscores/whitespaces/etc.
