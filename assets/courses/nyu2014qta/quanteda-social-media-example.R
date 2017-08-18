## Quantitative Analysis of Quantitative Data
##
## NYU Dept. of Politics short course Fall 2014
##
## Code for examples from Day 8, Social Media
## Pablo Barbera <pablo.barbera@nyu.edu>

library(quanteda)
options(stringsAsFactors=F)

## ~~~~~~~~~~
## Facebook
## ~~~~~~~~~~

# Access token: https://developers.facebook.com/tools/explorer/
token <- 'YOUR_ACCESS_TOKEN'

## Scraping most recent 200 posts from Obama and McCain FB pages
obama <- getFBpage('barackobama', token=token, n=200)
mccain <- getFBpage('johnmccain', token=token, n=200)

# creating corpus object
fbcorpus <- corpus(rbind(obama, mccain))
fbcorpus

# viewing the DFM using word clouds
par(mfrow=c(1,2))
plot(dfm(subset(fbcorpus, fbcorpus$documents$from_name=="Barack Obama"), 
	ignoredFeatures = stopwordsGet()), color="blue", scale=c(3, .2), max.words=100)
plot(dfm(subset(fbcorpus, fbcorpus$documents$from_name=="John McCain"), 
	ignoredFeatures = stopwordsGet()), color="red", scale=c(3, .2), max.words=100)

## ~~~~~~~~~~
## Twitter
## ~~~~~~~~~~

## data for authentication
## get your keys at apps.twitter.com
key = 'KEY___'
cons_secret = 'CONSUMER_SECRET'
token = 'TOKEN'
access_secret = 'ACCESS_SECRET'

## downloading 1,000 most recent tweets for an account
tw <- getTimeline("p_barbera", numResults=1000, filename='p_barbera.json',
	key, cons_secret, token, access_secret)

## creating corpus and dfm objects, and word cloud
twcorpus <- corpus(tw)
twDfm <- dfm(twcorpus, ignoredFeatures = c("rt", stopwordsGet()))
plot(twDfm, max.words=50)

## a more interesting example...
## finding list of 50 most followed members of congress
congress <- read.csv("http://www.pablobarbera.com/static/congress.csv")
top50 <- tail(congress$screen_name[order(congress$followers_count)], n=50)
tail(top50)

## downloading 1,000 most recent tweets for each MC
for (name in top50){
	cat("\n", name, "\n")
	tw <- getTimeline(name, numResults=1000, 
		filename=paste0("tweets/", name, ".json"),
		key, cons_secret, token, access_secret, df=FALSE)
}

## I already did that for you
download.file("http://www.pablobarbera.com/static/tweets.zip",
	destfile="tweets.zip")
unzip("tweets.zip")

## reading tweets and creating corpus object
tweets <- json("tweets")
twcorpus <- corpus(tweets)

## converting to DFM object, aggregating text by author
twDfm <- dfm(twcorpus, groups="screen_name", ignoredFeatures=c("rt", stopwordsGet()))

## information about party affiliation
parties <- congress[congress$screen_name %in% docnames(twDfm),]
parties <- parties$party[order(parties$screen_name)]

## keeping most common tokens to speed up example
twDfm <- trim(twDfm, minCount=9)

## word cloud
par(mfrow=c(1,2))
plot(subset(twDfm, parties=="R"), max.words=50, color="red")
plot(subset(twDfm, parties=="D"), max.words=50, color="blue")

## measuring lexical diversity
sort(statLexdiv(twDfm, "TTR"))

## hierarchical clustering
# get distances on normalized dfm
twDistMat <- dist(tf(twDfm))
# hiarchical clustering the distance object
twCluster <- hclust(twDistMat)
# label with document names
twCluster$labels <- paste0(parties, '-', docnames(twDfm))
# plot as a dendrogram
plot(twCluster)




