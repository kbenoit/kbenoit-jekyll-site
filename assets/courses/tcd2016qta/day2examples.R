## Code for examples from Day 2, Describing and Comparing Descriptive Stats
## Ken Benoit <kbenoit@lse.ac.uk>


## experimenting with summary()
summary(ie2010Corpus)
summary(ie2010Corpus, toLower = TRUE, removePunct = TRUE)
summResults <- summary(ie2010Corpus, verbose = FALSE)
head(summResults)

summary(exampleString)

## distances
presDfm <- dfm(subset(inaugCorpus, Year>1980), ignoredFeatures = stopwords("english"), stem=TRUE)
similarity(presDfm)
as.matrix(similarity(presDfm))
as.matrix(similarity(tf(presDfm, "prop")))

as.matrix(similarity(presDfm, method = "cosine"))
as.matrix(similarity(tf(presDfm, "prop"), method = "cosine"))

summary(proxy::pr_DB)   # see all available

# plot the differences with other presidents
obamaDistance <- similarity(presDfm, method = "cosine")
dotchart(obamaDistance[["2009-Obama"]], xlab="Cosine similarity")
obamaDistanceCorr <- similarity(presDfm, method = "correlation")
dotchart(obamaDistanceCorr[["2009-Obama"]], xlab="Correlation")


# create a dfm from inaugural addresses from Reagan onwards
presDfm <- dfm(subset(inaugCorpus, Year>1980), stem = TRUE)
# can remove features separately
presDfm <- removeFeatures(presDfm, stopwords("english"))

# compute some document similarities
similarity(presDfm, "1985-Reagan", n=5, margin="documents")
similarity(presDfm, c("2009-Obama" , "2013-Obama"), n=5, margin="documents")
similarity(presDfm, c("2009-Obama" , "2013-Obama"), n=NULL, margin="documents")
similarity(presDfm, c("2009-Obama" , "2013-Obama"), n=NULL, margin="documents", method="cosine")
similarity(presDfm, "2005-Bush", n=NULL, margin="documents", method="eJaccard", sort=FALSE)

# compute some term similarities
similarity(presDfm, c("fair", "health", "terror"), margin = "features", method="cosine", n = 10)

# compare to tm
require(tm)
data("crude")
crude <- tm_map(crude, content_transformer(tolower))
crude <- tm_map(crude, removePunctuation)
crude <- tm_map(crude, removeNumbers)
crude <- tm_map(crude, stemDocument)
tdm <- TermDocumentMatrix(crude)
fa <- findAssocs(tdm, c("oil", "opec", "xyz"), c(0.75, 0.82, 0.1))
lapply(fa, "[", 1:8)

# same in quanteda
crudeDfm <- dfm(corpus(crude))
similarity(crudeDfm, c("oil", "opec", "xyz"), margin = "features", n = 8)
# note that tm does not compute similarities between words in the list!
# e.g. "opec" as a word close to "oil"



