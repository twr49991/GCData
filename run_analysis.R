`run_analysis <- function (){
         
# Step 1: Merge the training and the test sets to create one data set.
        features <- read.table("features.txt", stringsAsFactors=FALSE)

# put note in readme about the fact that the assignment leaves room for choice
# on which fields to us (can also cite David Hood or other TA on this) and 
# that I chose to use columns that matched the patterns shown below
        f2 <- as.data.frame(sapply(features, gsub, pattern="[-][m][e][a][n][(][)][-]", replacement="Mean"))
        f2 <- as.data.frame(sapply(f2, gsub, pattern="[-][m][e][a][n][(][)]", replacement="Mean"))
        f2 <- as.data.frame(sapply(f2, gsub, pattern="[-][s][t][d][(][)][-]", replacement="Std"))
        f2 <- as.data.frame(sapply(f2, gsub, pattern="[-][s][t][d][(][)]", replacment="Std"))

        xtrn <- read.table(file="X_train.txt", header=FALSE, col.names = f2[, 2], colClasses="numeric")
        xtst <- read.table(file="X_test.txt", header=FALSE, col.names = f2[, 2], colClasses="numeric")
        xs <- rbind(xtrn, xtst)
        
#  Step 2: Extract the measurements on the mean and standard deviation for each measurement.         
## NOTE: the grep pattern is now different due to the changes resulting in f2 above
        xskeep <- xs[, grep("[m][e][a][n]|[s][t][d]", colnames(xs))] #previous code
# not tested: xskeep <- xs[, grep("[m][e][a][n][.]$|[S][t][d][.]$", colnames(xs))]


#  Step 3: Use descriptive activity names to name the activities in the data set        
        subjtrn <- read.table(file="subject_train.txt", colClasses="character")
        subjtst <- read.table(file="subject_test.txt", colClasses="character")
        subj <- rbind(subjtrn, subjtst)
        colnames(subj) <- "Subject"
        
        acttrn <- read.table(file="y_train.txt", colClasses="character")
        acttst <- read.table(file="y_test.txt", colClasses="character")
        act <- rbind(acttrn, acttst)
        
        actlbls <- read.table(file="activity_labels.txt", stringsAsFactors=FALSE)
        act[act$V1 == "1", ] <- actlbls[1, 2]
        act[act$V1 == "2", ] <- actlbls[2, 2]
        act[act$V1 == "3", ] <- actlbls[3, 2]
        act[act$V1 == "4", ] <- actlbls[4, 2]
        act[act$V1 == "5", ] <- actlbls[5, 2]
        act[act$V1 == "6", ] <- actlbls[6, 2]
        colnames(act) <- "Activity"
        
        ds <- cbind(subj, act, xskeep)

#  Step 5: Create a second, independent tidy data set with the average of each variable 
#               for each activity and each subject.
        tidySummary <- ddply(ds, .(Subject, Activity), numcolwise(mean))
        
        write.table(tidySummary, "tidySummary.txt", row.names=FALSE)
  
}