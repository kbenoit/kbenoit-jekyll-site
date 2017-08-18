#
# Exercise 9 solution: Topic Models
#
#install.packages('topicmodels', dependencies=TRUE)


library(quanteda)
library(topicmodels)
data(newsCorpus)
data(custom_stopwords)


# take only the top two newspapers
(paperCount <- table(getData(newsCorpus)$paperName))
(topPapers <- names(sort(paperCount, decreasing = TRUE)[1:2]))
reducedCorpus <- subset(newsCorpus, paperName %in% topPapers)

# make a dfm and triplet matrix 
byDocDfm <- dfm(reducedCorpus)
byDocDfmTrim <- dfmTrim(byDocDfm, minCount=50, minDoc=20) 
finalDfmByDoc <- stopwordsRemove(byDocDfmTrim, custom_stopwords)
finalDfmByDoc <- finalDfmByDoc[which(rowSums(finalDfmByDoc) > 0),] 
finalTripletByDoc<- dfm2tmformat(finalDfmByDoc)

# can just do data(newsLdaModel) here
newsLdaModel <- LDA(finalTripletByDoc,method="VEM",k=20)

# which terms contribute most to each topic
get_terms(newsLdaModel, k=10)

# which is the dominant topic for each document
get_topics(newsLdaModel)

# the topic contribution of each topic to each document
postTopics <- data.frame(posterior(newsLdaModel)$topics)

# get the newspaper names from the rownames of the topic contribution matrix
x <- sapply(rownames(postTopics),strsplit,'_')
paperNames <- sapply(x, head, n=1)
postTopics["paper"]<- paperNames
# Mean contribution of topic $X to document for each newspaper
#install.packages('plyr')
library(plyr)
byPaperTopics <-ddply(postTopics, "paper", numcolwise(mean))
barplot(byPaperTopics$X14, names.arg=byPaperTopics$paper, beside=TRUE)



#
#
#  Some alternative code using the LDA package.
#

ldaDfm <- dfm2ldaformat(finalDfmByDoc)

# Run the model and find 20 topics
newsLdaModel <- LDA(finalTripletByDoc, method="VEM", k = 20)

result <- lda.collapsed.gibbs.sampler(ldaDfm$documents,
                                      20,  ## Num clusters
                                      ldaDfm$vocab,
                                      25,  ## Num iterations
                                      0.1,
                                      0.1,
                                      compute.log.likelihood=TRUE) 
## Get the top words in the cluster
top.words <- top.topic.words(result$topics, 10, by.score=TRUE)

## Number of documents to display
N <- 10

topic.proportions <- t(result$document_sums) / colSums(result$document_sums)
topic.proportions <- topic.proportions[sample(1:dim(topic.proportions)[1], N),]
topic.proportions[is.na(topic.proportions)] <-  1 / K

## from here it does not work
colnames(topic.proportions) <- apply(top.words, 2, paste, collapse=" ")
library(reshape2)
topic.proportions.df <- melt(cbind(data.frame(topic.proportions),
                                   document=factor(1:N)),
                             variable.name="topic",
                             id.vars = "document")
library(reshape2)
qplot(topic, value, fill=document, ylab="proportion",
      data=topic.proportions.df, geom="bar") +
  theme(axis.text.x = element_text(angle=90, hjust=1)) +  
  facet_wrap(~ document, ncol=5) +
  coord_flip()
