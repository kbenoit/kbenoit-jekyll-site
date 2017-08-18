
#
# Part 1
#
library(quanteda)
data(iebudgets)
iebudgets2010 <- subset(iebudgets, year==2010)
toxicKwic <- kwic(iebudgets2010, 'toxic')
badKwic <- kwic(iebudgets2010, 'bad')

#
# 2a
#
docMat <- dfm(iebudgets2010)

#
# 2b
#
######  total number of "types" (unique words) per document
ntypes <- rowSums(docMat>0)

###### total number of words ("tokens") per document
ntokens <- rowSums(docMat)

######  vocab diversity per document
# note how division is vectorized
ntypes/ntokens

#
# 2c
#
# most frequent word
total <- colSums(docMat)
total <- sort(total, decreasing=TRUE)
sorted <- dfmSort(docMat)

#
# 2d
#

# number of sentences in all texts
# $ symbol accesses attribute of data frame
numSents <- summary(iebudgets2010)$Sentences

#
# 2e
#

# syllable counts of all texts
textSyls <- countSyllables(iebudgets2010$attribs$texts)
totalSyls <- sum(textSyls)


#
# 2f
#
# Fleisch-Kincaid
asl <- (sum(ntokens)/sum(numSents))
asw <- (totalSyls/sum(ntokens))
f <- (206.835 - (1.015*asl)) - (84.0 * asw)

#
# 3
#
# Type-token ratio by year

data(iebudgets)
finMins <- subset(iebudgets, no=="01")
finDfm <- dfm(finMins)
types <- rowSums(finDfm > 0)
tokens <- rowSums(finDfm)
ttrs <- types/tokens
plot(2008:2012, ttrs,
     ylim=c(.18,.25),   # set the y axis range
     type="b",          # points connected by lines
     xlab="Budget Year")

# Alternative using Giraud measure
par(mfrow=c(3,1))
plot(2008:2012, ttrs,
     ylim=c(.18,.25),   # set the y axis range
     type="b",          # points connected by lines
     xlab="Budget Year", main="TTR")
text(2008:2012, ttrs, rev(finMins$attribs$speaker), pos=3)
plot(2008:2012, types/sqrt(tokens),
     type="b",          # points connected by lines
     xlab="Budget Year", main="Giraud")
text(2008:2012, types/sqrt(tokens), rev(finMins$attribs$speaker), pos=c(rep(3,4), 1))
names(tokens) <- rev(finMins$attribs$speaker)
barplot(tokens, main="Total speech length")


#
# 4
#
###### demonstrate Zipf's law

par(mfrow=c(1,1)) # reset layout of plot window

# note that variable 'total' is the types sorted by frequency from Part
plot(log10(1:100), log10(total[1:100]),                                   
     xlab="log(rank)", ylab="log(frequency)", main="Top 100 Words")
# regression to check if slope is approx -1.0
regression <- lm(log10(total[1:100]) ~ log10(1:100))
summary(regression)
confint(regression)