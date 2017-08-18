## Quantitative Analysis of Quantitative Data
##
## NYU Dept. of Politics short course Fall 2014
## ** Corrected 26 Sept 2014 **
##
## Code for examples from Day 1, The Elements of Textual Data
## Ken Benoit <kbenoit@lse.ac.uk>

## be sure to install the latest version from GitHub, using dev branch:
devtools::install_github("quanteda", username="kbenoit", dependencies=TRUE, ref="dev")
## and quantedaData
devtools::install_github("quantedaData", username="kbenoit")

library(quanteda)

## stemming examples
sampletxt <- "The police with their policing strategy instituted a policy of general 
              iterations at the Data Science Institute."
wordstem(tokenize(sampletxt, simplify=TRUE))

# stopwords examples
library(quantedaData)
data(exampleString)
stopwordsRemove(exampleString)
topfeatures(dfm(exampleString, verbose=FALSE))
topfeatures(dfm(exampleString, stopwords=TRUE, verbose=FALSE))
topfeatures(dfm(exampleString, stopwords=TRUE, stem=TRUE, verbose=FALSE))

## some POS tagging
require("openNLP")
require("NLP")
# some text
s <- paste(c("Pierre Vinken, 61 years old, will join the board as a ",
             "nonexecutive director Nov. 29.\n",
             "Mr. Vinken is chairman of Elsevier N.V., ",
             "the Dutch publishing group."),
           collapse = "")
s <- as.String(s)
# Need sentence and word token annotations.
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()
a2 <- annotate(s, list(sent_token_annotator, word_token_annotator))
pos_tag_annotator <- Maxent_POS_Tag_Annotator()
a3 <- annotate(s, pos_tag_annotator, a2)
# Determine the distribution of POS tags for word tokens.
a3w <- subset(a3, type == "word")
tags <- sapply(a3w$features, `[[`, "POS")
# Extract the token/POS pairs
sprintf("%s/%s", s[a3w], tags)



## demonstrate Zipf's law
mydfm <- dfm(inaugCorpus)
plot(log10(1:100), log10(topfeatures(mydfm, 100)),
     xlab="log10(rank)", ylab="log10(frequency)", main="Top 100 Words")
# regression to check if slope is approx -1.0
regression <- lm(log10(topfeatures(mydfm, 100)) ~ log10(1:100))
abline(regression, col="red")
confint(regression)


## constructing bigrams
bigrams(sampletxt)
bigrams(sampletxt, window=3)

## detect collocations in UK party manifestos speeches
library(quantedaData)
data(ukManifestos)
colloc <- collocations(subset(ukManifestos, Year==2001), top=300)
stopwords <- sort(stopwordsGet("english"))

## remove any collocations containing a word in the stoplist
coltokenized <- tokenize(colloc$collocation)
isStopwordList <- lapply(coltokenized, `%in%`, stopwords)
stopwordindex <- which(sapply(isStopwordList, sum)>0)
colloc[stopwordindex, ]   # collocations containing stopwords
colloc$collocation[-stopwordindex]  # collocations not containing stopwords


