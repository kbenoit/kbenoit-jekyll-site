library(devtools)
install_github('quanteda', username='kbenoit', ref='dev', quick=TRUE)
library(quanteda)
data(exampleString)

# 1a
#
# note ambiguity of 'Fine/fine'
cleanedString <- clean(exampleString)
# with different parameters
withUpper <- clean(exampleString,  lower = FALSE)

#
# 1b
# note hypenation and contractions
tokens <- tokenize(cleanedString)
tokens <- tokenize(exampleString, removePunct = FALSE)

# 2
#
# note that the stopwords function operates on a single string (character vector), 
# while the stemmer operates on a vector of tokens.
if (!require(SnowballC)) {
    install.packages("SnowballC", dependencies=TRUE)
}
# removing stopwords
noStops <- stopwordsRemove(exampleString)

# stemming a character vector
stemmed <- wordStem(tokens)

#
#  Part 3
# basic dfm
data(iebudgets)
iebudgets2010 <- subset(iebudgets, year==2010)
docMat <- dfm(iebudgets2010)
docMat[3,"the"]
docMat[1:5,100:110]

# with stemming and stopwords
docMatStems <- dfm(iebudgets, stem=TRUE, stopwords=TRUE)
docMatStems[1:5,100:110]


#dfmTrim
# note change in length of rows and columns
trimmedDocMat <- dfmTrim(docMat, minCount=5, minDoc=2)

#
#  Part 4
# Tf-idf

# 4a
idf <- log(nrow(docMat)) - log(colSums(docMat > 0) + 1)
tf <- docMat / rowSums(docMat)
m1 <- t(t(tf)*idf)

# 4b
m2 <- tfidf(docMat)

identical(m1, m2)  # test condition that these are the same

# 4c
# the log="x" parameter will plot the x-axis at log scale
plot(docMat[1,], tfidf(docMat)[1,], log="x", xlab="log(Term Frequency)", ylab="tf-idf")
plot(docMat[1,], tfidf(docMat)[1,], xlab="log(Term Frequency)", ylab="tf-idf")