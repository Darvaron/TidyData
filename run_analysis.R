# Creating data folder
if(!file.exists("./data")){
   dir.create("./data")
}

# Downloading files
if(!file.exists("./data/dataset.zip")){
   data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   dest_url <- "./data/dataset.zip"
   download.file(data_url, dest_url)
}

print(paste("Downloaded at: ", Sys.Date()))

# Extracting zip file
if(!file.exists("./data/UCI HAR Dataset")){
   unzip("./data/dataset.zip", exdir = "./data")
}

files_path <- "./data/UCI HAR Dataset"

# Selecting the desired files
train_url <- paste(files_path, "/train/X_train.txt", sep = "")
test_url <- paste(files_path, "/test/X_test.txt", sep = "")


# Loading train and test sets
library(data.table)

train <- fread(train_url, sep = " ", header = FALSE)
test <- fread(test_url, sep = " ", header = FALSE)

# Setting names
colNames <- readLines(paste(files_path, "/features.txt", sep = ""))

library(stringr)

colNames <- gsub("^[0-9]+ ", "", colNames)

names(train) <- colNames
names(test) <- colNames

# Merging train and test by rows
dataset <- rbind(train, test)

#Checking correct dims
dim(dataset)[1] == dim(train)[1] + dim(test)[1]
dim(dataset)[2] == dim(train)[2] && dim(dataset)[2] == dim(test)[2]

# Selecting only mean and standard deviation variables
library(dplyr)

desired_cols <- grep(".*mean\\(\\).*|.*std\\(\\).*", names(dataset))

dataset <- select(dataset, desired_cols)

####

# only_means <- select(dataset, grep(".*mean\\(\\).*", names(dataset)))
# only_std <- select(dataset, grep(".*std\\(\\).*", names(dataset)))
# 
# library(tidyr)
# 
# # Separating mean and std
# only_means <- as.data.table(gather(only_means, measure, mean,1:33))
# only_std <- as.data.table(gather(only_std, measure, standard_deviation,1:33))
# 
# # Replacing t and f and separating it into 2 cols
# only_means <- only_means %>% mutate(measure =  gsub("^t", "Time ", measure)) %>%
#    mutate(measure = gsub("^f", "Frequency ", measure)) %>% 
#    separate(measure, c("variable", "section"), sep = " ")
#    
# 
# only_std <- only_std %>% mutate(measure =  gsub("^t", "Time ", measure)) %>%
#    mutate(measure = gsub("^f", "Frequency ", measure)) %>% 
#    separate(measure, c("variable", "section"), sep = " ")
# 
# # Separating between axis and the type of measure and defining new names
# only_means <- only_means %>% mutate(section = gsub("-mean\\(\\)-", "_", section)) %>%
#    mutate(section = gsub("-mean\\(\\)", "_General", section)) %>% 
#    separate(section, c("section", "axis")) %>%
#    mutate(section = gsub("^BodyBody", "Body2", section))
# 
# only_std <- only_std %>% mutate(section = gsub("-std\\(\\)-", "_", section)) %>%
#    mutate(section = gsub("-std\\(\\)", "_General", section)) %>% 
#    separate(section, c("section", "axis")) %>%
#    mutate(section = gsub("^BodyBody", "Body2", section))
# 
# unique(only_means$section)
# unique(only_std$section)
# 
# copy_means <- copy(only_means)
# copy_std <- copy(only_std)
# 
# merged <- cbind(only_means, select(only_std, -c(section, axis, variable)))
# 
# merged %>% mutate(section = gsub('([[:upper:]])', ' \\1', section)) %>%
#    mutate(section = gsub("^ ", "", section)) %>%
#    separate(section, c("section", "instrument", "signal"), sep = " ", extra = "merge") %>%
#    mutate(section = replace_na(signal, "No signal"))

####  ------------------------------

# Checking correct dims
dim(dataset)[2] == length(desired_cols)
dim(dataset)[1] == dim(train)[1] + dim(test)[1]

# Descriptive names
new_names <- names(dataset)
new_names <- gsub("-", " ", new_names)
new_names <- gsub("mean\\(\\)", "average", new_names)
new_names <- gsub("std\\(\\)", "standard deviation", new_names)
new_names <- gsub("X", "axis X", new_names)
new_names <- gsub("Y", "axis Y", new_names)
new_names <- gsub("Z", "axis Z", new_names)
new_names <- gsub("^t", "Time ", new_names)
new_names <- gsub("^f", "Frequency ", new_names)
new_names <- gsub("BodyBody", "bodybody ", new_names)
new_names <- gsub("Body", "body ", new_names)
new_names <- gsub("Acc", "accelerometer ", new_names)
new_names <- gsub("Gyro", "gyroscope ", new_names)
new_names <- gsub("Gravity", "gravity ", new_names)

names(dataset) <- new_names

View(dataset)

# Saving first dataset
if(!file.exists("./tidy")){
   dir.create("./tidy")
}
fwrite(dataset, file = "./tidy/dataset_general.csv", sep = ",")

# Generating average dataset

tidy_ind <- summarize_all(dataset, mean)
fwrite(tidy_ind, file = "./tidy/independent_tidy.csv", sep = ",")

View(tidy_ind)

# Checking data
obtained_ds <- read.csv("./tidy/dataset_general.csv")
obtained_ti <- read.csv("./tidy/independent_tidy.csv")
