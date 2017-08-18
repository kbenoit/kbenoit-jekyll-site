#########################################
## Exercise 2 Answers in R
## remember to read the comments
##
## Ken Benoit
#########################################

###### (5) 

# Load in word frequency data
wfm <- read.csv("wordfreqm.csv", header=TRUE)
# move the first column to rownames
rownames(wfm) <- wfm[,1]
# drop first column of wfm so that wfm is only frequencies
wfm <- wfm[,-1]

###### (7a) total number of "types" (unique words) per document
(n.types <- colSums(wfm>0))

###### (7b) total number of words ("tokens") per document
(n.tokens <- colSums(wfm))

###### (7c) vocab diversity per document
n.types/n.tokens

###### (7d) median word freq per document
wfm.na <- wfm               # make a copy
wfm.na[wfm.na==0] <- NA     # replace 0's with NA
apply(wfm.na, 2, median, na.rm=TRUE)

###### (7e) most frequently used word among all documents
total <- rowSums(wfm)
total <- sort(total, decreasing=TRUE)


###### demonstrate Zipf's law
plot(log10(1:100), log10(total[1:100]),                                   
     xlab="log(rank)", ylab="log(frequency)", main="Top 100 Words")
# regression to check if slope is approx -1.0
regression <- lm(log10(total[1:100]) ~ log10(1:100))
summary(regression)
confint(regression)
