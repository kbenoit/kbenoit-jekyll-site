
library(quanteda)

# Part one:
# Word Level probabilities for Naive Bayes
data(movies)
movieDfm <- dfm(movies, group="lab", stopwords=TRUE)
movieDfm <- dfmTrim(movieDfm,  minDoc=1, minCount = 20)
PwordGivenPos <-movieDfm['pos',]/sum(movieDfm['pos',])
Ppos <-  table(movies$attribs$lab)['pos']/length(getTexts(movies))
PwordGivenNeg <-movieDfm['neg',]/sum(movieDfm['neg',])
Pneg <-  table(movies$attribs$lab)['neg']/length(getTexts(movies))
pPosgivenWord <- (PwordGivenPos*Ppos)/((PwordGivenPos*Ppos)+(PwordGivenNeg*Pneg))

sortedProbs <- pPosgivenWord[order(pPosgivenWord)]  # sort words by "affect"
head(sortedProbs, n=50)
tail(sortedProbs, n=50)

# Part two
# Training and testing naive bayes
library(quanteda)
data(movies)
movies <- corpusSample(movies, 2000, replace=FALSE)
movieDfm <- dfm(movies, stopwords=TRUE)
movieDfm <- dfmTrim(movieDfm,minDoc=10,minCount=20)
movieDfm <- tfidf(movieDfm)
trainclass <- factor(c(movies$attribs$lab[1:1500], rep(NA, 500)))
movieNb <- naiveBayesText(as.matrix(movieDfm), trainclass)
movPreds <- predict(movieNb)
table(movPreds$docs$nb.predicted, movies$attribs$lab )

# out of sample? Poor accuracy?
(results <- table(movPreds$docs$nb.predicted[1500:2000],movies$attribs$lab[1500:2000]))

# how to compute precision and recall
performance <- function(restab) {
    precision <- diag(restab) / rowSums(restab)
    recall    <- diag(restab) / colSums(restab)
    f1        <- 2 * (precision * recall) / (precision + recall)
    accuracy  <- sum(diag(restab)) / sum(restab)
    return(data.frame(precision=precision, recall=recall, f1=f1, accuracy=accuracy,
           row.names=colnames(restab)))
}

performance(results)
