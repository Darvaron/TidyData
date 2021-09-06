# Tidy data

#### This repository contains.  
- The raw data obtained from [raw data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) that is stored in the */data/* folder.  
- TidyData: File where the raw data is tidy that is stored in the */tidy/* folder, the first tidy dataset is named "dataset_general.csv",  
- Code book: Information about the variables, summary of choices and information about the experimental study.

*note*: The description of the raw data is located at: [description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).  

## Code book

### Getting and cleaning data
1. The raw data is downloaded into the *data* folder from the given link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2. The zip file is extracted into *UCI HAR Dataset* folder located in *data*.  
3. The training and test sets are loaded using the fread function, their paths are: */data/UCI HAR Dataset/train/X_train.txt* and */data/UCI HAR Dataset/test/X_test.txt* respectively.
4. The columns names for train and test are loaded from the */data/UCI HAR Dataset/features.txt* file deleting the numbers at the beginning.  
5. The train and test sets are merged into one by rows.  
6. The columns that contains one of the following texts are selected: "mean()", "std()".  



7. The following patterns are replaced as follows:  
   1. "-" by spaces.  
   2. "mean()" and "std()" by "average" and "standard deviation" respectively.  
   3. "X", "Y", "Z" by "axis X", "axis Y" and "axis Z" respectively.  
   4. any "t" that is located at the beginning by "Time".  
   5. any "f" that is located at the beginning by "Frequency".  
   6. "BodyBody" by "bodybody".  
   7. "Body" by "body".  
   8. "Acc" by "accelerometer".  
   9. "Gyro" by "giroscope".
   10. "Gravity" by "gravity".  

This are some examples of the resulting names:  
- Time body gyroscope Jerk standard deviation axis X.  
- Time body gyroscope Mag average.

To create the second dataset the arithmetic function is applied.

### Explanation of the data   
- 66 feature vector with time and frequency domain variables estimated from the collected signals.  
- The variables are time or frequency obtained from an accelerometer or gyroscope from a given section.  
- The frequency variables correspond to a Fast Fourier Transform (FFT) applied to the given variable.  
- The average values are the mean value of that variable.  
- The standard deviation values are the standard deviation of that variable.  
- The tidy dataset contains a summarize of those values.
