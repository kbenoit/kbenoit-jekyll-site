## Quantitative Analysis of Quantitative Data
##
## NYU Dept. of Politics short course Fall 2014
## 31 October 2014
##
## Code for examples from Day 3, Dictionaries
## Ken Benoit <kbenoit@lse.ac.uk>

## using dfm to keep only certain terms
## keep only certain words
testText <- "The quick brown fox named Seamus jumps over the lazy dog also named Seamus, with
             the newspaper from a a boy named Seamus, in his mouth."
testCorpus <- corpus(testText)
print(dfm(testCorpus, keep="s$"), TRUE)  # keep only words ending in "s"
testTweets <- c("My homie @justinbieber #justinbieber getting his shopping on in #LA yesterday #beliebers",
                "To all the haters including my brother #justinbieber #justinbiebermeetcrystaltalley #emabiggestfansjustinbieber",
                "Justin Bieber #justinbieber #belieber #kidrauhl #fetusjustin #EMABiggestFansJustinBieber")
print(dfm(testTweets, keep="^#"), TRUE)  # keep only hashtags


## similar keep for dfms
library(quantedaData)
data(ie2010Corpus)
ieDfm <- dfm(ie2010Corpus)
ieDfmSmall <- trimdfm(ieDfm, keep=c("tax|budg|^auster"))
View(ieDfmSmall)

## compound words function
mytexts <- c("The new law included a capital gains tax, and an inheritance tax.",
             "New York City has raised a taxes: an income tax and a sales tax.")
mydict <- list(tax=c("tax", "income tax", "capital gains tax", "inheritance tax"))
(cw <- compoundWords(mytexts, mydict))
print(dfm(cw), show.values=TRUE)


## basic regular expression function demos
grep("^vot", c("voting", "votes", "devoted", "vote"))
grepl("^vot", c("voting", "votes", "devoted", "vote"))
## replace patterns
gsub("(\\w)-(\\d{2,2})", "\\1-19\\2", c("Roosevelt-33", "Roosevelt-37", "Obama-2003"))
# observe the difference the $ makes
gsub("(\\w)-(\\d{2,2})$", "\\1-19\\2", c("Roosevelt-33", "Roosevelt-37", "Obama-2003"))


## LIWC on inaugural speeches
LIWCdict <- readWStatDict("~/Dropbox/Classes/QTA\ NYU/Readings/LIWC2007.cat", enc="WINDOWS-1252")
LIWCdict  # look at entries
inaugLIWCdfm <- dfm(subset(inaugCorpus, Year>1965), dictionary=LIWCdict)
View(inaugLIWCdfm)
inaugLIWCdfmNorm <- tf(inaugLIWCdfm)
features(inaugLIWCdfmNorm)
topfeatures(inaugLIWCdfmNorm, 20)

# a "Laver-Garry"-type scale of orientation towards past v. present
orientation <- (inaugLIWCdfmNorm[,"LINGUISTIC PROCESSES.FUTURE TENSE"] - 
                inaugLIWCdfmNorm[,"LINGUISTIC PROCESSES.PAST TENSE"]) / 
               (inaugLIWCdfmNorm[,"LINGUISTIC PROCESSES.FUTURE TENSE"] +
                inaugLIWCdfmNorm[,"LINGUISTIC PROCESSES.PRESENT TENSE"] + 
                inaugLIWCdfmNorm[,"LINGUISTIC PROCESSES.PAST TENSE"])
# plot the measure over time
plot(docvars(subset(inaugCorpus, Year>1965), "Year"), 
     orientation,
     xlab="Year", ylab="Past v. Future Orientation", type="b", pch=19, ylim=c(-.15, .15))
abline(h=0, lty="dashed", col="gray60")
text(docvars(subset(inaugCorpus, Year>1965), "Year"), 
     orientation, docvars(subset(inaugCorpus, Year>1965), "President"), pos=(c(3, rep(1,10), 3)))

# a log-odds ratio by Party
inaugPost1980Corpus <- subset(inaugCorpus, Year>1980)
docvars(inaugPost1980Corpus)
docvars(inaugPost1980Corpus, "Party") <- c(rep("Rep",3), rep("Dem",2), rep("Rep",2), rep("Dem",2))
myDfm <- dfm(inaugPost1980Corpus, dictionary=LIWCdict, groups="Party")
View(myDfm)
orientationLO <- log(myDfm[,"LINGUISTIC PROCESSES.FUTURE TENSE"] /
                     myDfm[,"LINGUISTIC PROCESSES.PAST TENSE"])
orientationLO
orientationLOpres <- log(inaugLIWCdfmNorm[,"LINGUISTIC PROCESSES.FUTURE TENSE"] /
                         inaugLIWCdfmNorm[,"LINGUISTIC PROCESSES.PAST TENSE"])
dotchart(rev(orientationLOpres), 
         color=ifelse(rev(docvars(inaugPost1980Corpus, "Party"))=="Dem", "blue", "red"), 
         xlab="Log-odds past v. future orientation")
abline(v=0, lty="dashed", col="gray60")



## with the RID
RIDdict <- readWStatDict("~/Dropbox/Classes/QTA\ NYU/Readings/RID.CAT")
inaugRIDdfm <- dfm(subset(inaugCorpus, Year>1965), dictionary=RIDdict)
View(inaugRIDdfm)
inaugRIDdfmNorm <- tf(inaugRIDdfm)
features(inaugRIDdfm)
topfeatures(inaugRIDdfm, 20)
# plot a measure over time
plot(docvars(subset(inaugCorpus, Year>1965), "Year"), 
     inaugRIDdfmNorm[, "PRIMARY.NEED.ORALITY"],
     xlab="Year", ylab="Orality", type="b", pch=19)
abline(h=0, lty="dotted", col="gray60")
text(docvars(subset(inaugCorpus, Year>1965), "Year"), inaugRIDdfmNorm[, "PRIMARY.NEED.ORALITY"],
     docvars(subset(inaugCorpus, Year>1965), "President"), pos=c(3,1,1,3,3, rep(3,4), 1,1,1))


## dfm with the thesaurus feature
mytexts <- c("The new law included a capital gains tax, and an inheritance tax.",
             "New York City has raised a taxes: an income tax and a sales tax.")
mydict <- list(tax=c("tax", "income tax", "capital gains tax", "inheritance tax"))
print(dfm(compoundWords(mytexts, mydict),
          thesaurus=lapply(mydict, function(x) gsub("\\s", "_", x))),
      show.values=TRUE)
# pick up "taxes" with "tax" as a regex
print(dfm(compoundWords(mytexts, mydict), thesaurus=list(anytax="tax"), dictionary_regex=TRUE), TRUE)


