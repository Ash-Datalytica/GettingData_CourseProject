###############################################################################
# The script  does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
###############################################################################
dataDir <- "../data/UCI HAR Dataset/"
#dataDir <- "./UCI HAR Dataset/" #if data is stored in subdirecory of WD

## 1.Merge the training and the test sets to create one data set.
# Load test data
x_test <- read.table(paste0(dataDir, "test/X_test.txt"), header = F, quote = "",colClasses = "numeric" )
y_test <- read.table(paste0(dataDir, "test/y_test.txt"), header = F, quote = "",colClasses = "numeric" )
subj_test <- read.table(paste0(dataDir, "test/subject_test.txt"), header = F, quote = "",colClasses = "numeric" )

# Build dataset fot test data
data <- cbind(subj_test, y_test, TRUE,  x_test)

# Release memory
rm(x_test); rm(y_test); rm(subj_test)

# Load train data
x_train <- read.table(paste0(dataDir, "train/X_train.txt"), header = F, quote = "",colClasses = "numeric" )
y_train <- read.table(paste0(dataDir, "train/y_train.txt"), header = F, quote = "",colClasses = "numeric" )
subj_train <- read.table(paste0(dataDir, "train/subject_train.txt"), header = F, quote = "",colClasses = "numeric" )

# Build dataset fot train data
train <- cbind(subj_train, y_train, FALSE,  x_train)

# Make col names for rbind()
colnames(data)[1:3]  <- c("subject", "activity", "isTest")
colnames(train)[1:3] <- c("subject", "activity", "isTest")

# Build the final dataframe
data <- rbind(train,data)

# Release memory
rm(train); rm(x_train); rm(y_train); rm(subj_train) 

## 2.Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table(paste0(dataDir, "features.txt"), header = F, quote = "",
                       colClasses = c ("integer", "character"))
colnames(features) <- c("id", "name")
# ft <- table(features$name)
# length(ft[ft>1]) #42
# So, we have 42 feature names which repeat 3 times each
# We don't care about them now because we need only means and stds
# Going to use stringi package to operate with strings because
# stri_detect_fixed()  is faster then grepl(), 
# see http://stackoverflow.com/questions/10128617/test-if-characters-in-string-in-r
if (!("stringi" %in% installed.packages()[,1])) install.packages("stringi")
library(stringi) #for stri_detect_fixed() 

#Leave only the necessary features
features <- features[stri_detect_fixed(features$name, "mean()") | 
                     stri_detect_fixed(features$name, "std()"),]

#Leave only the necessary columns in the data frame
library (dplyr) #for select(), mutate(), group_by(), summarise_each()
data <- select (data, subject, activity, isTest, num_range("V",features$id))

## 3. Set descriptive activity names to name the activities in the data set
activities <- read.table(paste0(dataDir, "activity_labels.txt"), header = F, quote = "",
                       colClasses = c ("integer", "character"))
data <- mutate (data, activity = activities[activity,2]) # Decode activity
rm(activities) # Release memory

## 4. Label the data set with descriptive variable names.
features$name <- stri_replace_all_fixed(features$name, "()", "") # Eliminate "()" from names
features$name <- stri_replace_all_fixed(features$name, "-", ".") # Replace "-" with "."
colnames(data)[4:(3+nrow(features))] <- features$name
rm(features) # Release memory
# View(data)

# 5. Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
avedata <- 
    data %>% group_by (activity, subject) %>%
    summarise_each (funs(mean), tBodyAcc.mean.X:fBodyBodyGyroJerkMag.std)    
# View(avedata)

# Write resulting tidy dataset to file for submission
write.table(avedata, "../data/tidy5.txt", row.names=FALSE)
