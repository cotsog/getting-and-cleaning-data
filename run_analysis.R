library(reshape2)

# 1. Merges the training and the test sets to create one data set.

# Load feature names
features <- read.table('dataset/features.txt')

# Load all training set files
train_subject <- read.table('dataset/train/subject_train.txt')
train_x <- read.table('dataset/train/X_train.txt')
train_y <- read.table('dataset/train/y_train.txt')

# Add column names to training set
colnames(train_subject) <- c('subject')
colnames(train_y) <- c('activity')
colnames(train_x) <- features[, 2]

# Load all test set files
test_subject <- read.table('dataset/test/subject_test.txt')
test_x <- read.table('dataset/test/X_test.txt')
test_y <- read.table('dataset/test/y_test.txt')

# Add column names to test set
colnames(test_subject) <- c('subject')
colnames(test_y) <- c('activity')
colnames(test_x) <- features[, 2]

# Merge both training and test data sets
all_subject <- rbind(train_subject, test_subject)
all_y <- rbind(train_y, test_y)
all_x <- rbind(train_x, test_x)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
columns_to_keep <- grep('mean\\(\\)|std\\(\\)', names(all_x))
all_x <- all_x[ , columns_to_keep]

# 3. Uses descriptive activity names to name the activities in the data set
activity_names <- read.table("dataset/activity_labels.txt")

# 4. Appropriately labels the data set with descriptive activity names.
all_y[,1] = activity_names[all_y[,1], 2]

# Merge and save all the data
all_data <- cbind(all_subject, all_y, all_x)
write.table(all_data, "all_data.txt")

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
melt_data <- melt(all_data, id=c("subject", "activity"))
tidy_data <- dcast(melt_data, activity + subject ~ variable, mean)
write.table(tidy_data, "tidy_data.txt")
