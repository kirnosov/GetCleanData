# START Course Project

# clean up the environment
rm(list=ls())

# to start with, let us download the project data,
# unzip it and delete the zip.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("UCI HAR Dataset")) {
        download.file(fileUrl,destfile="./DataZIP.zip",method="curl")
        unzip(zipfile="./DataZIP.zip")
        unlink("DataZIP.zip")
}

# in order to keep the directory clean, I will let the input files
# sit in the "UCI HAR Dataset" directory
# to avoid typing the file path, let's create a variable
path <- file.path("UCI HAR Dataset")

# we can list all files not leaving R shell with
# > list.files(path, recursive=TRUE)
# and start reading in 'test' and 'train' data.
# I will be row-binding them.

####   1.  Merges the training and the test sets to create one data set.
# First, I will read in activity information.
dtActivity  <- rbind(read.table(file.path(path, "test", "y_test.txt"),header = FALSE) ,
                     read.table(file.path(path, "train", "y_train.txt"),header = FALSE) )
# Activities are coded with numbers,
# but there is a file which matches these numbers to descriptive names.
# Let us read these matches
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
# and replace numbers with names.
dtActivity[, 1] <- activityLabels[dtActivity[, 1], 2]
# Doing so will take care of #3: Uses descriptive activity names to name the activities in the data set

# Read in subject IDs
dtSubject  <- rbind(read.table(file.path(path, "test", "subject_test.txt"),header = FALSE),
                    read.table(file.path(path, "train" , "subject_train.txt"),header = FALSE))
# and various features mearurements
dtFeatures <- rbind(read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE),
                    read.table(file.path(path, "train", "X_train.txt"),header = FALSE))

# Will call 'subject ID' = "SID",
names(dtSubject)<-c("SID")
# activity will be called "activity",
names(dtActivity)<- c("activity")
# and there is a file with feature names, so I will just read it in.
FNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(dtFeatures)<- FNames[,2]

# Now we are ready to column-bind these data into one 
dt <- cbind(dtSubject, dtActivity, dtFeatures)

###   2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# We will use grep() function to decide which feature names have 'mean()' and 'std()' in them.
# Note that 'meanFreq()' is not of interest to us. 
subFNames<-FNames[,2][grep("mean\\(\\)|std\\(\\)", FNames[,2])]
# Note: what is grepped must be exact - no extra spaces!

# Now we will reassign the data only including columns of interest to dt 
dt<-subset(dt,select=c("SID", "activity", as.character(subFNames)))

###   3. Uses descriptive activity names to name the activities in the data set
# is already taken care of

###   4. Appropriately labels the data set with descriptive variable names. 

# The names of the features are quite descriptive but not super human-friendly.
# I will create a file 'better_feature_names.txt' which will be decoding
# provided names' parts into something more readable.
# Currently the 'better_feature_names.txt' file looks like that:
#       BAD      GOOD
#       ^t       time
#       ^f       frequency
#       Acc      Acceleration
#       Gyro     Gyroscope
#       Mag      Magnitude
#       BodyBody Body
if (file.exists("better_feature_names.txt")){
FNamesChart <- read.table("better_feature_names.txt",head=TRUE)
for (i in 1:nrow(FNamesChart)){
        # Here I am replacing values from BAD column with the values from
        # GOOD column in all fetures of interest names
        names(dt)<-gsub(FNamesChart$BAD[i], FNamesChart$GOOD[i], names(dt))
}
} else {
print("provide better_feature_names.txt")
}

###   5. From the data set in step 4, creates a second, independent tidy data 
###      set with the average of each variable for each activity and each subject.
# Or as described by David Hood in https://class.coursera.org/getdata-013/forum/thread?thread_id=31 :
# There are a whole bunch of measurements, each of which is measuring a subject 
# doing an activity. Each combination of (subject, activity, measurement) has a 
# number of observations. For step five get the mean of every one of those combinations.

# That is best accomplished with aggregate() function from 'plyr' library 
library(plyr)
# Here we are averaging all feature values corresponding to a specific pair 
# of SID and activity values.
tidydt<-aggregate(. ~SID + activity, dt, mean)
# After the appropriate ordering,
tidydt<-tidydt[order(tidydt$SID,tidydt$activity),]
# the tidy data set is ready for printing
write.table(tidydt, file = "tidy_dataset.txt",row.name=FALSE)

# clean up the environment
rm(list=ls())
### END Project
