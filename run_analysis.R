library(dplyr)

summarize_health_data <- function(path) {
    # 1. Merge the test and train data sets
    ## Read and collate test data
    x_test <- read.table(paste(path, "test/X_test.txt", sep = "/"))
    y_test <- read.table(paste(path, "test/y_test.txt", sep = "/"))
    subject_test <- read.table(paste(path, "test/subject_test.txt", sep = "/"))

    ## now combine the test data sets into a single data.frame
    x_test$subject_id <- subject_test$V1
    x_test$activity_id <- y_test$V1

    ## Read and combine train data
    x_train <- read.table(paste(path, "train/X_train.txt", sep = "/"))
    y_train <- read.table(paste(path, "train/y_train.txt", sep = "/"))
    subject_train <- read.table(paste(path, "train/subject_train.txt", sep = "/"))

    ## now combine the train data sets into a single data.frame
    x_train$subject_id <- subject_train$V1
    x_train$activity_id <- y_train$V1

    ## Combine test and train data-sets
    master_set <- rbind(x_test, x_train)

    # 2. Extract only mean() and std() measurements
    ## Replace the V1-V561 column names with readable labels
    feature_labels <- read.table(paste(path, "features.txt", sep = "/"),
                                 stringsAsFactors = FALSE,
                                 row.names = 1,
                                 col.names = c("feature_id", "feature_name"))

    colnames(master_set) <- c(unlist(feature_labels$feature_name), "activity_id", "subject_id")

    ## extract a new data.frame, just grabbing variables measuring the
    ## mean or std. deviation (based on naming)
    mean_std_colnames <- grep("([Mm]ean|[Ss]td)\\(\\)", feature_labels$feature_name, value = TRUE)
    reduced_master_set <- master_set[c("activity_id", "subject_id", unlist(mean_std_colnames))]

    # 3. Group and summarize by subject and activity
    summarized_set <-
        group_by(reduced_master_set, activity_id, subject_id) %>%
        summarize_each(funs(mean), -activity_id, -subject_id)

    activity_labels <- read.table(paste(path, "activity_labels.txt", sep = "/"),
                                  stringsAsFactors = FALSE,
                                  row.names = 1,
                                  col.names = c("activity_id", "activity_name"))

    summarized_set$activity_name <- sapply(summarized_set$activity_id, function(a) {
        activity_labels$activity_name[a]
    })

    ## re-order columns to put subject_id and activity_id on the far left
    columns <- colnames(summarized_set)
    reordered_columns <-
        c("activity_name", "subject_id",  unlist(columns[3:(length(columns) - 3)]))

    summarized_set <-summarized_set[reordered_columns]

    ## one last scrub of column names for readability
    scrubbed_colnames <- sub("\\(\\)", "", colnames(summarized_set))
    scrubbed_colnames <- sub("^t", "time.", scrubbed_colnames)
    scrubbed_colnames <- sub("^f", "frequency.", scrubbed_colnames)
    scrubbed_colnames <- gsub("-", ".", scrubbed_colnames)
    colnames(summarized_set) <- scrubbed_colnames


    return(summarized_set)
}
