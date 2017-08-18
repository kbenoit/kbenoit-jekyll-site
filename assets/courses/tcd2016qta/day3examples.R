## Quantitative Text Analysis of Quantitative Data
##
## TCD Spring 2016
##
## Code for examples from Day 3, Dictionaries
## Ken Benoit <kbenoit@tcd>

require(quanteda)

## using dfm to keep only certain terms
## keep only certain words
testText <- "The quick brown fox named Seamus jumps over the lazy dog also named Seamus, with
             the newspaper from a a boy named Seamus, in his mouth."
testCorpus <- corpus(testText)
dfm(testCorpus, keptFeatures = "*s")  # keep only words ending in "s"
testTweets <- c("My homie @justinbieber #justinbieber getting his shopping on in #LA yesterday #beliebers",
                "To all the haters including my brother #justinbieber #justinbiebermeetcrystaltalley #emabiggestfansjustinbieber",
                "Justin Bieber #justinbieber #belieber #kidrauhl #fetusjustin #EMABiggestFansJustinBieber")
dfm(testTweets, keptFeatures = "#*")  # keep only hashtags


## similar keep for dfms
ieDfm <- dfm(ie2010Corpus)
ieDfmSmall <- selectFeatures(ieDfm, "tax|budg|^auster", valuetype = "regex")
head(ieDfmSmall)
# equivalent
ieDfmSmall2 <- selectFeatures(ieDfm, c("tax", "budg", "^auster"), valuetype = "regex")
all.equal(features(ieDfmSmall), features(ieDfmSmall2))

## compound words function
mytexts <- c("The new law included a capital gains tax, and an inheritance tax.",
             "New York City has raised a taxes: an income tax and a sales tax.")
mydict <- dictionary(list(tax=c("tax", "income tax", "capital gains tax", "inheritance tax")))
(cw <- phrasetotoken(mytexts, mydict))
dfm(cw, verbose = FALSE)

## basic regular expression function demos
grep("^vot", c("voting", "votes", "devoted", "vote"))
grepl("^vot", c("voting", "votes", "devoted", "vote"))
## replace patterns
gsub("(\\w)-(\\d{2,2})", "\\1-19\\2", c("Roosevelt-33", "Roosevelt-37", "Obama-2003"))
# observe the difference the $ makes
gsub("(\\w)-(\\d{2,2})$", "\\1-19\\2", c("Roosevelt-33", "Roosevelt-37", "Obama-2003"))


## LIWC on inaugural speeches
LIWCdict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/LIWC/LIWC2015_English_Flat.dic", 
                       format = "LIWC", enc="WINDOWS-1252")
LIWCdict[["swear"]]  # look at entries
inaugLIWCdfm <- dfm(subset(inaugCorpus, Year > 1965), dictionary = LIWCdict)
head(inaugLIWCdfm)
inaugLIWCdfmNorm <- tf(inaugLIWCdfm, "prop")
features(inaugLIWCdfmNorm)
topfeatures(inaugLIWCdfmNorm, 20)

# a "Laver-Garry"-type scale of orientation towards past v. present
orientation <- (inaugLIWCdfmNorm[,"focusfuture"] - 
                inaugLIWCdfmNorm[,"focuspast"]) / 
               (inaugLIWCdfmNorm[,"focusfuture"] +
                inaugLIWCdfmNorm[,"focuspresent"] + 
                inaugLIWCdfmNorm[,"focuspast"])
# plot the measure over time
plot(docvars(subset(inaugCorpus, Year>1965), "Year"), 
     orientation,
     xlab="Year", ylab="Past v. Future Orientation", type="b", pch=19, ylim=c(-.20, .10))
abline(h=0, lty="dashed", col="gray60")
text(docvars(subset(inaugCorpus, Year>1965), "Year"), 
     orientation, docvars(subset(inaugCorpus, Year>1965), "President"), pos=(c(3, rep(1,10), 3)))

# a log-odds ratio by Party
inaugPost1980Corpus <- subset(inaugCorpus, Year>1980)
docvars(inaugPost1980Corpus)
docvars(inaugPost1980Corpus, "Party") <- c(rep("Rep",3), rep("Dem",2), rep("Rep",2), rep("Dem",2))
myDfm <- dfm(inaugPost1980Corpus, dictionary=LIWCdict, groups="Party")
head(myDfm)
orientationLO <- log(myDfm[,"focuspresent"] /
                     myDfm[,"focuspast"])
orientationLO
orientationLOpres <- log(inaugLIWCdfmNorm[,"focuspresent"] /
                         inaugLIWCdfmNorm[,"focuspast"])
orientationLOpres <- orientationLOpres[, 1, drop = TRUE]
dotchart(rev(orientationLOpres), 
         color=ifelse(rev(docvars(inaugPost1980Corpus, "Party"))=="Dem", "blue", "red"), 
         xlab="Log-odds past v. future orientation", xlim = c(0,2), pch = 19)
abline(v=0, lty="dashed", col="gray60")



## with the RID
RIDdict <- dictionary(file = "~/Dropbox/QUANTESS/dictionaries/RID/RID.CAT", format = "wordstat")
inaugRIDdfm <- dfm(subset(inaugCorpus, Year>1965), dictionary = RIDdict)
head(inaugRIDdfm)
features(inaugRIDdfm)
inaugRIDdfmNorm <- tf(inaugRIDdfm, "prop")
topfeatures(inaugRIDdfmNorm, 20)
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
mydict <- dictionary(list(tax=c("tax", "income tax", "capital gains tax", "inheritance tax")))
dfm(phrasetotoken(mytexts, mydict), thesaurus = lapply(mydict, function(x) gsub("\\s", "_", x)))
# pick up "taxes" with "tax" as a regex
dfm(phrasetotoken(mytexts, mydict), thesaurus = list(anytax = "tax"), valuetype = "regex")
