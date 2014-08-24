run_analysis <- function (){
         
## Merge the training and the test sets to create one data set.
        features <- read.table("features.txt", stringsAsFactors=FALSE)

## Do some cleanup on the variable names
        f2 <- as.data.frame(sapply(features, gsub, pattern="[-][Mm][e][a][n][(][)][-]", replacement="Mean"))
        f2 <- as.data.frame(sapply(f2, gsub, pattern="[-][Ss][t][d][(][)][-]", replacement="Std"))

## Merge the X training and test data
        xtrn <- read.table(file="X_train.txt", header=FALSE, col.names = f2[, 2], colClasses="numeric")
        xtst <- read.table(file="X_test.txt", header=FALSE, col.names = f2[, 2], colClasses="numeric")
        xs <- rbind(xtrn, xtst)

## Extract the obervations of mean and standard deviation       
## NOTE: the grep pattern is now different due to the changes resulting in data frame f2 above
        xskeep <- xs[, grep("[M][e][a][n][XYZ]|[S][t][d][XYZ]", colnames(xs))] 
         
## Create a column containing the subject identifiers from training and test       
        subjtrn <- read.table(file="subject_train.txt", colClasses="character")
        subjtst <- read.table(file="subject_test.txt", colClasses="character")
        subj <- rbind(subjtrn, subjtst)
        ## name the column 
        colnames(subj) <- "Subject"

## Use descriptive activity names to name the activities in the data set  
        actlbls <- read.table(file="activity_labels.txt", stringsAsFactors=FALSE)
        act[act$V1 == "1", ] <- actlbls[1, 2]
        act[act$V1 == "2", ] <- actlbls[2, 2]
        act[act$V1 == "3", ] <- actlbls[3, 2]
        act[act$V1 == "4", ] <- actlbls[4, 2]
        act[act$V1 == "5", ] <- actlbls[5, 2]
        act[act$V1 == "6", ] <- actlbls[6, 2]
        colnames(act) <- "Activity"

## Merge the Y training and test datasets to get labels for test and training 
        acttrn <- read.table(file="y_train.txt", colClasses="character")
        acttst <- read.table(file="y_test.txt", colClasses="character")
        act <- rbind(acttrn, acttst)
        
## Apply the subject IDs and activity names to the subset that has mean and std observations
        ds <- cbind(subj, act, xskeep)

## Create the tidy data set with the average of each variable for each activity and each subject.
        tidySummary <- ddply(ds, .(Subject, Activity), numcolwise(mean))

## Write the dataset to disk
        write.table(tidySummary, "tidySummary.txt", row.names=FALSE)
  
}