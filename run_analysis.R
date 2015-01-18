# check if dplyr package is installed, if not - install it
if (!require("dplyr")) {
        message("dplyr package not installed, installing now...")
        install.packages("dplyr")
        if(!require("dplyr")) {
                stop("unable to load dplyr, execution stopped")
        }
# if a version of dplyr older than 0.4.0 was installed in R - remove and reinstall
# the most recent one (4.0.1 at the time of writing)
} else if (installed.packages()["dplyr",][["Version"]] < "0.4.0") {
        message("dplyr installed, but it is older than v0.4.0, attempting to re-install..")
        remove.packages("dplyr")
        install.packages("dplyr")
        if(!require("dplyr")) {
                stop("unable to load dplyr, execution stopped")
        }
}
# check if tidyr is intalled, if not - install it
if (!require("tidyr")) {
        message("tidyr package not installed, installing now...")
        install.packages("tidyr")
        if(!require("tidyr")) {
                stop("unable to load tidyr, execution stopped")
        }
}

# check to see if WD was set correcrtly
if (!file.exists("activity_labels.txt")) {
        stop("Please make sure working directory is set to the root of the Samsung data folder")
}

message("reading data files...")
# read all data files to data frames and assign to variables
activity_labels <- 
        read.table("activity_labels.txt", header = F, col.names = c("id", "activity"))
features <- 
        read.table("features.txt", header = F)
# features[[2]] is the names of the measurements column
test_df <- 
        read.table("test/X_test.txt", header = F, col.names = features[[2]])
activity_ids_test <- 
        read.table("test/y_test.txt", header = F, col.names = "activity_label_id")
subject_test <- 
        read.table("test/subject_test.txt", header = F, col.names = "subject")
train_df <- 
        read.table("train/X_train.txt", header = F, col.names = features[[2]])
activity_ids_train <- 
        read.table("train/y_train.txt", header = F, col.names = "activity_label_id")
subject_train <- 
        read.table("train/subject_train.txt", header = F, col.names = "subject")

message("merging data frames...")
# column-bind the main data sets and corresponding subject + activity 
# data sets together
test_df <- bind_cols(subject_test, activity_ids_test, test_df)
train_df <- bind_cols(subject_train, activity_ids_train, train_df)

# row-bind the test and the train data frames
main_df <- bind_rows(test_df, train_df)
# merge the resulting data frame with the activity_labels data frame
main_df <- merge(main_df, activity_labels, 
                 by.x = "activity_label_id", by.y = "id", sort = FALSE)

message("applying modifications to the main data frame...")
# subset the main data frame by selecting the 'subject', 'activity' and all the 
# measurement columns that contained mean() and std() 
# (note: parenthesis were converted to dots by R)
main_df <- 
        select(main_df, subject, activity, contains(".mean."), contains(".std."))
# remove all trailing dots from variable names
names(main_df) <- gsub("[.]+$","", names(main_df))
# replace multiple consecutive dots with one dot
names(main_df) <- gsub("[.]+",".", names(main_df))
# replace 't' at the beginning of all variable names with 'time'
names(main_df) <- gsub("^t","time.", names(main_df))
# replace 'f' at the beginning of all variable names with 'frequency'
names(main_df) <- gsub("^f","frequency.", names(main_df))

main_df <- main_df %>% 
        # gather data from all measurements columns into 'measurement' and 'value'
        gather(measurement, value, 3:ncol(main_df), -subject, -activity) %>% 
        # separate measurements into four columns  by splitting the 'measurement' 
        # variable into 4 variables ('.' is used as a separator silently).
        # Some NAs will be introduced in the 'axis' column for measurements that 
        # do not contain 'X', 'Y' or 'Z' axis in their names
        separate(measurement, 
                c("measurementtype","measurement", "aggregation", "axis"), 
                 extra = "drop") %>%
        # group data frame by all variables (apart from 'value' of course).
        # This is where step 4 of the course project instructions ends and step 
        # 5 begins. A local variable could be introduced here to separate the 
        # 'source' and the 'final' data sets if necessary but it hurts to break 
        # the cool dplyr chain :)
        group_by(subject, activity, measurementtype, 
                 measurement, aggregation, axis) %>%
        # calculate the mean for each group
        summarize(meanvalue = mean(value))

message("writing resulting data set to a file...")
# write the resulting data frame to a file
write.table(main_df, file = "result_dataset.txt", row.name = FALSE)

message("all done")
