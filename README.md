Getting and Cleaning Data Course Project
=========================

This repository contains the Course project for the "Getting and Cleaning Data" course.

The goal of the code provided is to take input data from [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and prepare tidy data that can be used for later analysis.

##How repository is organized

Important files in this repository are:

- **run_analysis.R** - R code which processes the input data and writes resulting tidy dataset in file "tidy.txt" in the working directory.
- **tidy.txt** - the result of run_analysis.R.
- **CodeBook.MD** - code book describing the resulting data in **tidy.txt**.
- **README.MD** - this document.

**_The Repo doesn't contain input data!_**

##How to run the code
If you want just to examine resulting tidy data, it can be loaded in R with the following command
`read.table("tidy.txt", header = TRUE)`.

First, [download](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) the input data set and unzip it into your working directory preserving archive folder structure. If you'd like to have the data in other directory modify variable `dataDir` in the beggining of **run_analysis.R**.  

Then run **run_analysis.R** in RStudio (R, etc.) and get the resulting file **tidy.txt** in your's working directory.

##What the script does
Script **run_analysis.R** does the following.

**1. Merges the training and the test sets to create one data set.**

First, the script takes test data from initial data set which are in X_text.txt, y_test.txt, subject_test.txt files in the "UCI HAR Dataset/test/" subdirectory. This data are glued together into one wide dataset by `cbind()`.  
Then, the script loads in the similar way train data X_train.txt, y_train.txt, subject_train.txt from the "UCI HAR Dataset/train/" subdirectory.  
Finally, loaded test and train data are merged by columns into one dataset by `rbind()`.

**2. Extracts only the measurements on the mean and standard deviation for each measurement. **
 
The script eliminates all the variables which don't have "mean()" or "std()" at the end of their name and ends up with 66 measurement variables. 
I decided not to include measurements of the following types in the data frame, because they are _not true means_:

- meanFreq(): _Weighted_ average of the frequency components to obtain a mean frequency.
- angle() of some mean vaule (e.g. `angle(X,gravityMean)`): _Angle_ between two vectors.
 
According to [David's project FAQ](https://class.coursera.org/getdata-008/forum/thread?thread_id=24), section **"what columns are measurements on the mean and standard deviation"**, the approach used is aсceptable.

**3. Uses descriptive activity names to name the activities in the data set**

At this point, activity is represented in the coded format as integers 1 to 6. It's possible to decode them into descriptive character names such as "WALKING", "WALKING_USTAIRS" etc. using data provided in the "UCI HAR Dataset/activity_labels.txt" file.  

The script loads **activity_labels.txt** and converts activity integer values in the data frame into descriptive character values taken from this file.

**4. Appropriately labels the data set with descriptive variable names. **

The script changes names of measurement variables to more descriptive names. I decided to use [CamelCase notation](http://en.wikipedia.org/wiki/CamelCase) with the first letter in lower case.  

This notation was chosen because it doesn't contain any separation symbols (like dots, underscores, spaces etc) and thus conforms to recomendations given in the "Editing text variables" Week 4 lecture. But when variable name consists of several words it'd be more easy to read it if the begining of each word is Capital. Also names of statistical functions applied to data where shifted to the end of variable name. Standard deviation was left as "Std" because it is a commonly used abbreviation. For example, "tBodyAcc-mean()-X" was converted into "timeBodyAccelerationXMean", "tBodyAcc-std()-Z" into  "timeBodyAccelerationZStd".

The resulting variable names meet the following principles:

```
Names of variables should be
 - All lower case when possible
 - Descriptive (Diagnosis versus Dx)
 - Not duplicated
 - Not have underscores or dots or white spaces
```

**5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**

The script calculates means for every measurement variable in the data frame from the previous step. As a result we should get variables with too long names, such as "timeBodyAccelerationXMeanOfMean". To avoid this the script  tidies up the resulting data frame by transferring information about the statistical functions apllied into new variable "functionApplied". The script writes the resulting tidied data frame into "tidy.txt" file in the working directory.

I'd like to provide a short explanation why such decision was made.  It's possible to produce 'long', 'medium' or 'wide' tidy dataset (see [this](https://class.coursera.org/getdata-008/forum/thread?thread_id=94) discussion for more detail):

* 'wide' means keeping all variables as in the resulting data frame of step 4.
   It's a normal approach, but I don't like it because it gives _very_ long variable (column) names.
* 'long' or 'narrow' means converting all variables into key-value pairs while keeping activity and subject variables.
   I don't like this approach because it will likely require reading several 
   rows of data during further analysis (one observation in _different_ rows is bad for tidy data).
* 'medium' is in between of former two and means converting some (not all) information from the variable names into separate variables. We should be careful here because with some sets of new separate variables we'll get NAs 
   among numeric values of some other variables. I don't like to have NAs also, 
   that's why I introduce only one new variable "functionApplied" which represents statistical function applied to initial data. This variable was chosen because
    + Mean and standard deviation have different nature and it's likely that we'll use them separately in further analysis.
    + Full name of the function applied 'mean of standard deviation' or 'mean of std' is too long
   and it's convinient to transfer this information from variable names into a separate variable's value.
  
  Like at Step #4 I use common abbreviation "Std" for "Standard deviation".
  
  Example of the resulting dataset:
  
```
> tidy[1:3,1:5]
  activity subject functionApplied frequencyBodyAccelerationJerkMagnitude frequencyBodyAccelerationJerkX
1  WALKING       1      MeanOfMean                             -0.0571194                     -0.1705470
2  WALKING       1       MeanOfStd                             -0.1034924                     -0.1335866
3  WALKING       2      MeanOfMean                             -0.1690644                     -0.3046153
```

The code book for resulting tidy data is in [CodeBook.MD](CodeBook.MD).
