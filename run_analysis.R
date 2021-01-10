# step 0. Initialization

# loading required package
library(tidyverse)

# setting working directory
setwd("C:/Users/Evgeny/Dropbox/Coursera/Getting and cleaning data")

# downloading and unzipping data
temp <- tempfile()
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = temp, method = "auto")
unzip(temp, exdir = getwd())


# steps 1 and 2. Merging the training and the test sets to create one data set; 
# Extracting only the measurements on the mean and standard deviation for each measurement. 

# creating a vector for features names
features <- readLines(paste0(getwd(), "/UCI HAR Dataset/features.txt"))
features <- sapply(strsplit(features, " "), "[[", 2)

# importing test data
test_subject <- read.table(paste0(getwd(), "/UCI HAR Dataset/test/subject_test.txt"))
names(test_subject) <- "subject"
test_x <- read.table(paste0(getwd(), "/UCI HAR Dataset/test/X_test.txt"))
names(test_x) <- features
test_y <- read.table(paste0(getwd(), "/UCI HAR Dataset/test/y_test.txt"))
names(test_y) <- "activity"

# merging test data in a single dataframe, leaving only mean and standard deviation variables
test_df <- cbind(test_subject, test_y, test_x[, grepl("mean[(][)]|std", features)])

# importing train data
train_subject <- read.table(paste0(getwd(), "/UCI HAR Dataset/train/subject_train.txt"))
names(train_subject) <- "subject"
train_x <- read.table(paste0(getwd(), "/UCI HAR Dataset/train/X_train.txt"))
names(train_x) <- features
train_y <- read.table(paste0(getwd(), "/UCI HAR Dataset/train/y_train.txt"))
names(train_y) <- "activity"

# merging train data in a single dataframe, leaving only mean and standard deviation variables
train_df <- cbind(train_subject, train_y, train_x[, grepl("mean[(][)]|std()", features)])

# merging train and test dataframes
all_df <- rbind(test_df, train_df)


# Step 3. Adding descriptive activity names to name the activities in the data set

# creating dataframe for activities labels
activities <- read.table(paste0(getwd(), "/UCI HAR Dataset/activity_labels.txt"))
# labeling activities with descriptive names
all_df$activity <- factor(x = all_df$activity, levels = activities[, 1], labels = activities[, 2])


# Step 4. Making descriptive variables names 
names(all_df) <- str_replace(names(all_df), fixed("()"), "")
names(all_df) <- sub('^(.*)(-mean|-std)(.*)$', '\\1\\3_\\2', names(all_df))

# Step 5. Creating a new tidy data set with the average of each variable for each activity and each subject.
means_by_group <- all_df %>% group_by(subject, activity) %>% summarize_all(mean)
means_by_group <- pivot_longer(means_by_group, cols = 3:68, names_to = c("signal", "statistics"), names_sep = "_-")


# Saving tidy data to files
write.csv(all_df, file = "tidy.csv", row.names = FALSE)
write.csv(means_by_group, file = "tidy_summary.csv", row.names = FALSE)
