## inauguraldemo.R
##
## demonstration of capabilities of quanteda using US presidential 
## inaugural addresses

# makes this work on Windows
if (.Platform$OS.type=="windows") {
    quartz <- function() windows()
}

## load text files into an inaugural corpus
## from https://archive.org/details/Inaugural-Address-Corpus-1789-2009
# set the working directory to location of the files
setwd("~/Dropbox/Classes/Essex QTA/Notes/Day 1 - Introduction/inaugural")
# read in texts
inaugCorpus <- corpusFromFilenames("./inaugural/", 
                                   c("year", "president"),
                                   sep="-",
                                   enc="UTF-8")

summary(inaugCorpus) # summary stats on corpus

quartz() # this opens a graphics window, will be different on Windows
# wordcloud of Obama's speech
wordcloudDfm(dfm(subset(inaugCorpus, year==2009)))
# same but excluding common stopwords
quartz()
wordcloudDfm(dfm(subset(inaugCorpus, year==2009), stopwords=TRUE))

# get summary stats, save to a data frame
tokeninfo <- summary(inaugCorpus, verbose=FALSE)

# plot length over time
quartz(width=10, height=4)
with(tokeninfo, 
     plot(year, Tokens, 
          xlab = "Year", ylab="TTR",
          xaxp  = c(1789, 2009, 55),
          type="b", pch=19,       # lines and solid points
          cex=.5,                 # change plot symbol size
          cex.axis=.8, las=2,     # axis label options
          main="Total Speech Length"))

# plot TTR over time
tokeninfo$ttr <- tokeninfo$Types / tokeninfo$Tokens
tokeninfo$year <- as.numeric(year) # convert the string year to numeric
quartz(width=10, height=4)
with(tokeninfo, 
     plot(year, ttr, 
          xlab = "Year", ylab="TTR",
          xaxp  = c(1789, 2009, 55),
          type="b", pch=19,       # lines and solid points
          cex=.5,                 # change plot symbol size
          cex.axis=.5, las=2,     # axis label options
          main="Type-Token Ratios Over Time"))

# key words in context
kwic(inaugCorpus, "terror")
kwic(inaugCorpus, "terror", regex=TRUE)
kwic(inaugCorpus, "communist", regex=TRUE)

# subsetting the corpus - just from 1960-1980
inaugCorpus6080 <- subset(inaugCorpus, year>=1960 & year<=1980)
summary(inaugCorpus6080)

# creating a document-feature matrix
wfm <- dfm(inaugCorpus)
topFeatures(wfm, 20)
wfm <- dfm(inaugCorpus, stopwords=TRUE)  # now eliminate stopwords
topFeatures(wfm, 20)

