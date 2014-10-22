###############################################################################
# The script  does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
# Script requires the packages: dplyr, stringi
###############################################################################
#dataDir <- "../data/UCI HAR Dataset/" # for my environment
dataDir <- "./UCI HAR Dataset/" #if data is stored in subdirecory of WD

###############################################################################
## 1.Merge the training and the test sets to create one data set.
###############################################################################
# Load test data
x_test <- read.table(paste0(dataDir, "test/X_test.txt"), header = F, quote = "", 
                        colClasses = "numeric" )
y_test <- read.table(paste0(dataDir, "test/y_test.txt"), header = F, quote = "", 
                        colClasses = "numeric" )
subj_test <- read.table(paste0(dataDir, "test/subject_test.txt"), header = F, 
                            quote = "", colClasses = "numeric" )

# Build dataset fot test data
data <- cbind(subj_test, y_test, x_test)

# Release memory
rm(x_test); rm(y_test); rm(subj_test)

# Load train data
x_train <- read.table(paste0(dataDir, "train/X_train.txt"), header = F, 
                      quote = "", colClasses = "numeric" )
y_train <- read.table(paste0(dataDir, "train/y_train.txt"), header = F, 
                      quote = "", colClasses = "numeric" )
subj_train <- read.table(paste0(dataDir, "train/subject_train.txt"), header = F, 
                         quote = "", colClasses = "numeric" )

# Build dataset fot train data
train <- cbind(subj_train, y_train, x_train)

# Build the final dataframe
data <- rbind(train,data)
colnames(data)[1:2] <- c("subject", "activity")
#View (data)

# Release memory
rm(train); rm(x_train); rm(y_train); rm(subj_train) 

###############################################################################
## 2.Extract only the measurements on the mean and standard deviation 
## for each measurement
###############################################################################
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

#stringi for stri_detect_fixed(), stri_replace_first_regex() 
if (!require(stringi)) install.packages("stringi")

# Not included features which could have been included by some other author
#features[!(stri_detect_fixed(features$name, "mean()") | 
#             stri_detect_fixed(features$name, "std()")) & (stri_detect_fixed(features$name, "ean")),]

#Leave only the necessary features
features <- features[stri_detect_fixed(features$name, "mean()") | 
                     stri_detect_fixed(features$name, "std()"),]

#Leave only the necessary columns in the data frame
library (dplyr) #for select(), mutate(), group_by(), summarise_each()
data <- select (data, subject, activity, num_range("V",features$id))

###############################################################################
## 3. Set descriptive activity names to name the activities in the data set
###############################################################################
activities <- read.table(paste0(dataDir, "activity_labels.txt"), header = F, 
                         quote = "", colClasses = c ("integer", "character"))

# Decode activity as factor
activities <- factor(activities[,1], labels = activities[,2]) 
data <- mutate (data, activity = activities[activity]) 
rm(activities) # Release memory

###############################################################################
## 4. Label the data set with descriptive variable names.
###############################################################################
# Fix error in initial data names
features$newname <- stri_replace_all_fixed(features$name, "BodyBody", "Body")
#Using CamelCase notation with the first letter in lower case
#Give more descriptive names for time, frequency, acceleration and magnitude
features$newname <- stri_replace_first_regex(features$newname,"^t","time")
features$newname <- stri_replace_first_regex(features$newname,"^f","frequency")
features$newname <- stri_replace_first_regex(features$newname,"Acc","Acceleration")
features$newname <- stri_replace_first_regex(features$newname,"Mag","Magnitude")
#Convert function names to CamelCase
features$newname <- stri_replace_all_fixed(features$newname, "-mean()", "Mean")
features$newname <- stri_replace_all_fixed(features$newname, "-std()", "Std")
# Move applied function names to the end of label
features$newname <- stri_replace_first_regex(features$newname,"Mean-X","XMean")
features$newname <- stri_replace_first_regex(features$newname,"Mean-Y","YMean")
features$newname <- stri_replace_first_regex(features$newname,"Mean-Z","ZMean")
features$newname <- stri_replace_first_regex(features$newname,"Std-X","XStd")
features$newname <- stri_replace_first_regex(features$newname,"Std-Y","YStd")
features$newname <- stri_replace_first_regex(features$newname,"Std-Z","ZStd")
#head (features)
# id              name                   newname
# 1  1 tBodyAcc-mean()-X timeBodyAccelerationXMean
# 2  2 tBodyAcc-mean()-Y timeBodyAccelerationYMean
# 3  3 tBodyAcc-mean()-Z timeBodyAccelerationZMean
# 4  4  tBodyAcc-std()-X  timeBodyAccelerationXStd
# 5  5  tBodyAcc-std()-Y  timeBodyAccelerationYStd
# 6  6  tBodyAcc-std()-Z  timeBodyAccelerationZStd

colnames(data)[3:(2+nrow(features))] <- features$newname
rm(features) # Release memory
# View(data)

#What are some issues with the names of the variables in the original dataset.
#If you have a specific doubt after watching this lecture let me know.
#Given that, you should write another Codebook since it's likely that your variables 
#will have different names than the original dataset and therefore the original 
#Codebook is no longer valid.

###############################################################################
# 5. Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
###############################################################################
tidy <- 
    data %>% group_by (activity, subject) %>%
    summarise_each (funs(mean), timeBodyAccelerationXMean:frequencyBodyGyroJerkMagnitudeStd)    
# View(avedata)

#tidyr package for gather (), spread()
if (!require(tidyr)) install.packages("tidyr")

# It's possible to produce 'long', 'medium' or 'wide' tidy dataset:
# - 'wide' means keeping all variables as in the resulting data frame of step 4.
#    I don't like this approach because it gives very long variable (column) names.
# - 'long' means converting all variables into key-value pairs while keeping
#    activity and subject variables.
#    I don't like this approach because it will likely require reading several 
#    rows of data during further analysis (one observation in different rows).
# - 'medium' is in between of former two and means converting some (not all) 
#    information from the variable names into separate variables. 
#    With some sets of new separate variables  we'll get NAs 
#    among numeric values of some other variables. I don't like to have NAs also, 
#    that's why I introduce only one new variable which represents statistical 
#    function applied to initial data. This variable was chosen because
#    1) Mean and standard deviation have different nature ant it's likely that 
#    we'll use them separately in further analysis
#    2) Full name of the function applied 'mean of standard deviation' is too long
#    and it's convinient to transfer this information from variable names into 
#    separate variable's value.

#convert all long variable into key-value pairs for futher processing
tidy <- gather(tidy, variable, value, -(activity:subject))

# #Convert data domain  into separate factor variable
# tidy$domain[stri_detect_regex(tidy$variable, "^time")] <- "Time"
# tidy$variable <- stri_replace_first_regex(tidy$variable, "^time","")
# tidy$domain[stri_detect_regex(tidy$variable, "^frequency")] <- "Frequency"
# tidy$variable <- stri_replace_first_regex(tidy$variable, "^frequency","")
# tidy$domain <- as.factor(tidy$domain)

# #Convert data source into separate factor variable
# tidy$dataSource[stri_detect_fixed(tidy$variable, "Acceleration")] <- "Accelerometer"
# tidy$variable <- stri_replace_first_regex(tidy$variable, "Acceleration","")
# tidy$dataSource[stri_detect_fixed(tidy$variable, "Gyro")] <- "Gyroscope"
# tidy$variable <- stri_replace_first_regex(tidy$variable, "Gyro","")
# tidy$dataSource <- as.factor(tidy$dataSource)

#Convert statisical function applied to data into separate factor variable
tidy$functionApplied[stri_detect_fixed(tidy$variable, "Mean")] <- "MeanOfMean"
tidy$variable <- stri_replace_first_regex(tidy$variable, "Mean","")
tidy$functionApplied[stri_detect_fixed(tidy$variable, "Std")] <- "MeanOfStd"
tidy$variable <- stri_replace_first_regex(tidy$variable, "Std","")
tidy$functionApplied <- as.factor(tidy$functionApplied)

#convert 'variable' values into independent variables (columns)
tidy <- spread(tidy, variable, value)
#View (tidy)
#tidy[1:3,1:5]

# Write resulting tidy dataset to file for submission
write.table(tidy, "tidy.txt", row.names=FALSE, )

#test <- read.table("tidy.txt", header = TRUE)
# View (test)

