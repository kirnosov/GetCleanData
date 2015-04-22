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