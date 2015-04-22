# Getting and Cleaning Data - Course Project

## Code prerequisites
In order to operate, the code needs 330 MB of disk space and 306 MB of RAM.
The code is capable of downloading and unzipping [source data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), but a user can also provide it by manually unzipping and placing the directory called "UCI HAR Dataset" in the same folder where the script resides. In that case the disk space requirement is waived.

## [Data Set Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'README.txt' and 'features_info.txt' in the 'UCI HAR Dataset' directory for more details.

Credit: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

## Goal
The run_analysis.R script will analyze both training and test data sets described above to output a tidy data set containing averaged over all measurements values of the [features of interest](https://github.com/kirnosov/GetCleanData/blob/master/variables_of_interest.txt) for each subject (defined by &rsquo;SID&rsquo; descriptor) performing each of the six activities (defined by &rsquo;activity&rsquo; descriptor).

## Project stages

In the very beginning it is recommended to clear the environment to make sure that code requirements are satisfied. The [source data files](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) are downloaded if "UCI HAR Dataset" directory is not available in the working directory. After unpacking the zip file will be deleted.

### 1. Merge the training and the test sets to create one data set.

At this stage tables dtActivity, dtSubject, and dtFeatures are created by reading the test and train data files containing information about activities performed, subjects identification numbers, and features&rsquo; measurements correspondingly. 

dtActivity is read in as activity codes, so they are replaced by corresponding meaningful descriptions listed in &rsquo;activity_labels.txt&rsquo; file. This column is given &rsquo;activity&rsquo; name. dtSubject only columned is assigned &rsquo;SID&rsquo; (Subject IDentification number). dtFeatures column names are read in from &rsquo;features.txt&rsquo; into FNames variable and used as column headers. 

dtActivity, dtSubject, and dtFeatures are merged into the object called &rsquo;dt&rsquo;.

### 2. Extract only the measurements on the mean and standard deviation for each measurement.

Now grep() function is used to decide which feature names have 'mean()' and 'std()' in them. Note that 'meanFreq()' is not of interest to us. The dt is reassigned to only include [columns of interest](https://github.com/kirnosov/GetCleanData/blob/master/variables_of_interest.txt).

### 3. Use descriptive activity names to name the activities in the data set.

This part was taken care of when we replaced activity indexes (1-6) with activity names (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) in step 1.

### 4. Appropriately labels the data set with descriptive variable names.

The names of the features are quite descriptive but not super human-friendly. A file [&rsquo;better\_feature\_names.txt&rsquo;](https://github.com/kirnosov/GetCleanData/blob/master/better_feature_names.txt) is created to contain the decoding rules to modify provided names' parts into something more readable. In case that the file is missing, the script will print "provide better\_feature\_names.txt" and no changes will be made. 
Such an arrangement allows the end user to easily modify decoding rules. The current [better\_feature\_names.txt](https://github.com/kirnosov/GetCleanData/blob/master/better_feature_names.txt) file performs feature name modifications as shown in [variables\_of\_interest.txt](https://github.com/kirnosov/GetCleanData/blob/master/variables_of_interest.txt).

### 5. From tie data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

As [described by David Hood](https://class.coursera.org/getdata-013/forum/thread?thread_id=31) :
> There are a whole bunch of measurements, each of which is measuring a subject
> doing an activity. Each combination of (subject, activity, measurement) has a
> number of observations. For step five get the mean of every one of those combinations.

That is best accomplished with aggregate() function from 'plyr' library (which has to be installed if missing). The averaging of all feature values corresponding to a specific pair of SID and activity values is performed and stored in a tidydt table. It is then written into the [tidy_dataset.txt](https://github.com/kirnosov/GetCleanData/blob/master/tidy_dataset.txt) file.