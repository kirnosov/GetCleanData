# Getting and Cleaning Data - Course Project

This repo is created to be submitted as a course project for Coursera Getting and Cleaning Data class.

## Code prerequisites
In order to operate, the code needs 330 MB of disk space and 306 MB of RAM.
The code is capable of downloading and unzipping [source data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), but a user can also provide it by manually unzipping and placing the directory called "UCI HAR Dataset" in the same folder where the script resides. In that case the disk space requirement is waived.

## Data Set Description

Information on the [source data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) set is available from [one of the UCI Machine Learning repositories](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Goal

The run_analysis.R script will analyze both training and test data sets described above to output a tidy data set containing averaged over all measurements values of the [features of interest](https://github.com/kirnosov/GetCleanData/blob/master/variables_of_interest.txt) for each subject (defined by &rsquo;SID&rsquo; descriptor) performing each of the six activities (defined by &rsquo;activity&rsquo; descriptor).

## Files in the Repository

* **CodeBook.md** - a file with the detailed description of the project

* **better\_feature\_names.txt** - contains a set of substitutions which would allow to make the resulting data set easier to read and understand

* **run_analysis.R** - script file with lots of comments

* **tidy\_dataset.txt** - the output data (described in CodeBook.md)

* **variables\_of\_interest.txt** - features included in tidy_dataset.txt (both names before and after better\_feature\_names.txt rules application are provided)

## How does the code work?

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