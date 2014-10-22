Codebook for the output dataset (tidy.txt)
==================================================================

The dataset contains data obtained and processed during "Human Activity Recognition Using Smartphones" experiment and post-processed by **run_analysys.R** script from this repository.

This Codebook was inspired by ICPSR's [Guide to Codebooks](http://www.icpsr.umich.edu/files/deposit/Guide-to-Codebooks_v1.pdf).

###Principal Investigators
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.  
Smartlab - Non Linear Complex Systems Laboratory/  
DITEN - Universitа degli Studi di Genova.  
Via Opera Pia 11A, I-16145, Genoa, Italy.  
activityrecognition@smartlab.ws  
www.smartlab.ws  

###Input Dataset Overview

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

See 'README.txt' and 'features_info.txt' in the data [archive](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) for more details. 

###Output Dataset Overview

The features selected for this dataset come from the accelerometer and gyroscope 3-axial raw signals timeAcceleration-XYZ and timeGyro-XYZ. These time domain signals (prefix 'time' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (timeBodyAcceleration-XYZ and timeGravityAcceleration-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (timeBodyAccelerationJerk-XYZ and timeBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (timeBodyAccelerationMagnitude, timeGravityAccelerationMagnitude, timeBodyAccelerationJerkMagnitude, timeBodyGyroMagnitude, timeBodyGyroJerkMagnitude). 

Then a Fast Fourier Transform (FFT) was applied to some of these signals producing frequencyBodyAcceleration-XYZ, frequenceBodyAccelerationJerk-XYZ, frequencyBodyGyro-XYZ, frequenceBodyAccelerationJerkMagnitude, frequencyBodyGyroMagnitude, frequencyBodyGyroJerkMagnitude. (Note the 'frequency' to indicate frequency domain signals). 

Then for these signals mean and standard deviation were calculated. 

All these transformations were done by principal investigators and are represented in the input data.

Finally, the average of each variable for each activity and each subject was calculated.  
Only this final step is performed by '**run_analysys.R**' script which is described in [README.MD](README.MD).

All variables in the output dataset are named using [CamelCase notation](http://en.wikipedia.org/wiki/CamelCase) with lower case first which makes them more readable.  

###Output Dataset Variables

**activity**: Activity performed by a subject (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)  
**subject**: Subject ID (1 to 30)  
**functionApplied**: Statistical functions applied to variables (MeanOfMean, MeanOfStd)  
**frequencyBodyAccelerationJerkMagnitude**: result of FFT applied to the Euclidian magnitude of body jerk signal from accelerometer sensor  
**frequencyBodyAccelerationJerkX(Y,Z)**: result of FFT applied to the body jerk signal from accelerometer sensor on axis X (Y, Z)  
**frequencyBodyAccelerationMagnitude**:  result of FFT applied to the Euclidian magnitude of body motion signal from accelerometer sensor   
**frequencyBodyAccelerationX(Y,Z)**: result of FFT applied to the body motion signal from accelerometer sensor on axis X (Y, Z)    
**frequencyBodyGyroJerkMagnitude**: result of FFT applied to the Euclidian magnitude of body jerk signal from gyroscope sensor  
**frequencyBodyGyroMagnitude**: result of FFT applied to the Euclidian magnitude of body motion signal from gyroscope sensor  
**frequencyBodyGyroX(Y,Z)**: result of FFT applied to the body motion signal from gyroscope sensor on axis X (Y, Z)   
**timeBodyAccelerationJerkMagnitude**: Euclidian magnitude of body jerk signal from accelerometer sensor  
**timeBodyAccelerationJerkX(Y,Z)**: Body jerk signal from accelerometer sensor on axis X (Y, Z)  
**timeBodyAccelerationMagnitude**: Euclidian magnitude of body motion signal from accelerometer sensor  
**timeBodyAccelerationX(Y,Z)**: Body motion signal from accelerometer sensor on axis X (Y, Z)  
**timeBodyGyroJerkMagnitude**: Euclidian magnitude of body jerk signal from gyroscope sensor    
**timeBodyGyroJerkX(Y,Z)**: Body jerk signal from gyroscope sensor on axis X (Y, Z)      
**timeBodyGyroMagnitude**: Euclidian magnitude of body motion signal from gyroscope sensor  
**timeBodyGyroX(Y,Z)**: Body motion signal from gyroscope sensor on axis X (Y, Z)      
**timeGravityAccelerationMagnitude**: Euclidian magnitude of gravity acceleration signal from accelerometer sensor  
**timeGravityAccelerationX(Y,Z)**: Gravity acceleration signal from accelerometer sensor on on axis X (Y, Z)  
