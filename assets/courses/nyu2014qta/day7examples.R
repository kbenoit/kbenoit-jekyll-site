## Quantitative Analysis of Quantitative Data
##
## NYU Dept. of Politics short course Fall 2014
## 18 November 2014
##
## Code for examples from Day 7, Unsupervised classification and topic models
## Ken Benoit <kbenoit@lse.ac.uk>


## kNN classification
require(class)
require(quantedaData)
data(amicusCorpus)
amicusDfm <- dfm(amicusCorpus, stopwords=TRUE, stem=TRUE)
amicusDfm <- trimdfm(amicusDfm, minCount=10, minDoc=20)
amicusDfm <- tfidf(amicusDfm)
train <- amicusDfm[!is.na(docvars(amicusCorpus, "trainclass")), ]
test  <- amicusDfm[!is.na(docvars(amicusCorpus, "testclass")), ]
trainclass <- docvars(amicusCorpus, "trainclass")[1:4]
classified <- knn(train, test, trainclass, k=1)
table(classified, docvars(amicusCorpus, "testclass")[-c(1:4)])
classified <- knn(train, test, trainclass, k=2)
table(classified, docvars(amicusCorpus, "testclass")[-c(1:4)])


## k-means clustering
require(quantedaData)
data(SOTUCorpus)
presDfm <- dfm(subset(SOTUCorpus, year>1960), stopwords=TRUE, stem=TRUE)

presDfm <- trimdfm(presDfm, minCount=5, minDoc=3)
# try default guidelines
k <- round(sqrt(ndoc(presDfm)/2))
clusterk3 <- kmeans(tf(presDfm), k)
split(docnames(presDfm), clusterk3$cluster)

clusterk2 <- kmeans(tf(presDfm), 2)
split(docnames(presDfm), clusterk2$cluster)

## hierarchical clustering
# get distances on normalized dfm
presDistMat <- dist(tf(presDfm))
# hiarchical clustering the distance object
presCluster <- hclust(presDistMat)
# label with document names
presCluster$labels <- docnames(presDfm)
# plot as a dendrogram
plot(presCluster)

## hierarchical clustering on words
# weight by relative term frequency
wordDfm <- sort(tf(presDfm))  # sort in decreasing order of total word freq
wordDfm <- t(wordDfm)[1:100,]  # because transposed
wordDistMat <- dist(wordDfm)
wordCluster <- hclust(wordDistMat)
plot(wordCluster, labels = docnames(wordDfm),
     xlab="", main="Relative Term Frequency weighting"))

# repeat without word "will"
wordDfm <- wordDfm[-which(docnames(wordDfm)=="will"),]  # because transposed
wordDistMat <- dist(wordDfm)
wordCluster <- hclust(wordDistMat)
plot(wordCluster, labels = docnames(wordDfm), 
     xlab="", main="Relative Term Frequency without \"will\"")

# with tf-idf weighting
wordDfm <- sort(tfidf(presDfm))  # sort in decreasing order of total word freq
wordDfm <- t(wordDfm)[1:100,]  # because transposed
wordDistMat <- dist(wordDfm)
wordCluster <- hclust(wordDistMat)
plot(wordCluster, labels = docnames(wordDfm),
     xlab="", main="tf-idf Frequency weighting")

# a different representation
wordCluster2 <- as.dendrogram(wordCluster)
plot(wordCluster2)
# Color the branches using color_branches() from 'dendextend' package
myColorBranch <- color_branches(wordCluster2, k=5)
plot(myColorBranch)
# To color also labels, plug the result of coloring branches to color_labels()
myAllColor <- color_labels(myColorBranch, k=5)
plot(myAllColor)


## topic models
data(SOTUCorpus)
presDfm <- dfm(subset(SOTUCorpus, year>1960), stopwords=TRUE, stem=TRUE)
presDfm <- trimdfm(presDfm, minCount=5, minDoc=3)
presLDA <- textmodel_lda(presDfm, k=10)
# which terms contribute most to each topic
require(topicmodels)
terms(presLDA, k=10)
# which is the dominant topic for each document
topics(presLDA, 3)
# the contribution to each topic of each document
postTopics <- data.frame(posterior(presLDA)$topics)

## Topic models on NYT articles
require(jsonlite)
nyt <- fromJSON("~/Dropbox/Classes/QTA\ NYU/Notes/Day\ 7\ -\ Clustering\ and\ Topic\ Models/nyt_ac.json")
nyt <- fromJSON("/assets/courses/nyu2014qta/nyt_ac.json")
nytCorpus <- corpus(nyt$body$body_text, docvars = cbind(title=nyt$body$title, nyt$meta))
nytDfm <- dfm(nytCorpus, stem=TRUE, stopwords=TRUE)                                       
# fit topic model with 4 topics
nytLDA4 <- textmodel_lda(nytDfm, k=4)
terms(nytLDA4, k=20)
prop.table(table(topics(nytLDA4)))
# fit lda model with 4 topics
nytLDA4 <- textmodel_lda(nytDfm, k=4)
terms(nytLDA4, k=20)
prop.table(table(topics(nytLDA4)))
# fit lda model with 8 topics
nytLDA8 <- textmodel_lda(nytDfm, k=8)
terms(nytLDA8, k=20)
prop.table(table(topics(nytLDA8)))
nytCTM8 <- textmodel_lda(nytDfm, moel="ctm", k=8)
terms(nytCTM8, k=20)



