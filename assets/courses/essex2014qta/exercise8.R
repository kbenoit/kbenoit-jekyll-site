# Solution for Exercise 8
#

### (1) Get the 2010 Irish budget speeches corpus and create the dfm
library(quanteda)
data(iebudgets)
iebudgets2010 <- subset(iebudgets, year=="2010")
ieDfm <- dfm(iebudgets2010, stem=TRUE)
# rename the documents to a shorter version of the speaker names
rownames(ieDfm) <- with(getData(iebudgets2010), 
                        paste(speaker, " (", party, ")", sep=""))


### (2) Correspondence Analysis


library(ca)
ieCA <- ca(ieDfm)
str(ieCA) # examine the structure of the CA object

# plots just speaker positions in 2 dimensions
plot(ieCA, what=c("all", "none"))  
# plot the speakers in one dimension, ordered
pa

### (3) Wordfish

if (!require(austin)) {
    install.packages("austin", repos="http://R-Forge.R-project.org", type=source, dependencies=TRUE)
}
library(austin)
ieWF <- wordfish(ieDfm, dir=c(3,1))
summary(ieWF)
plot(ieWF)

# plot the equivalent of Slapin and Proksch (2008) Figure 2
plot(ieWF$beta, ieWF$psi, type="n", xlab="Word weights", ylab="Word Fixed Effect")
text(ieWF$beta, ieWF$psi, ieWF$words, col="grey50", cex=.6)
# highlight some selected words in red 
word.index <- grep("christ|fianna|bailout", ieWF$words)
text(ieWF$beta[word.index], ieWF$psi[word.index], ieWF$words[word.index], 
     col="red", cex=1.2)
