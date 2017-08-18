## Quantitative Analysis of Quantitative Data
##
## NYU Dept. of Politics short course Fall 2014
## 4 November 2014
##
## Code for examples from Day 5, unsupervised text scaling
## Ken Benoit <kbenoit@lse.ac.uk>

## Irish 2010 budget debate from Lowe and Benoit (2013)

## standard models
library(quantedaData)
data(ie2010Corpus)
# make prettier document names
docnames(ie2010Corpus) <- paste(docvars(ie2010Corpus, "name"), docvars(ie2010Corpus, "party"))
ieDfm <- dfm(ie2010Corpus)
wf <- textmodel_wordfish(ieDfm, dir=c(2,1))
wca <- textmodel_ca(ieDfm)
plot(wf$theta, -1*wca$rowcoord[,1], xlab="Wordfish theta-hat", ylab="CA dim 1 coordinate",
     main="Wordfish v CA dim 1", pch=19)  # dot plot
text(wf$theta, -1*wca$rowcoord[,1], docnames(ieDfm), cex=.8, pos=1)
abline(v=0, lty="dashed", col="red")
abline(lm(-1*wca$rowcoord[,1] ~ wf$theta), col="grey50", lty="dotted")

## plotting CA results
# CA plot in 2 dimensions
quartz(width=5, height=5)
srt <- order(wca$rowcoord[,1], decreasing=TRUE)
# one dimension
dotchart(wca$rowcoord[srt,1], labels=docnames(ieDfm)[srt])
# two dimensions
plot(wca, what=c("all", "none"))

## demonstrate the effects of irrelevant text
changedCorpus <- ie2010Corpus
newText <- texts(changedCorpus)
# some really irrelevant text, from Justin Bieber's Wikipedia page
junkText <- "   
Justin Drew Bieber (born March 1, 1994)[4][5] is a Canadian singer and songwriter. Bieber's current manager, Scooter Braun first discovered him through his YouTube videos in 2007.[6] Braun was impressed with the videos, and contacted Bieber's mother Pattie about wanting to work with him. After convincing Bieber's mother, Braun arranged for Bieber to meet with Usher in Atlanta, Georgia. Bieber was signed to RBMG,[7] and then to an Island Records recording contract offered by record executive, L.A. Reid.[3][8]\n\n
Bieber released his debut EP, My World, in November 2009. It was certified platinum in the United States. He became the first artist to have seven songs from a debut record to chart on the Billboard Hot 100.[9] Bieber released his first full-length studio album, My World 2.0, in March 2010. It debuted at or near number one in several countries and was certified platinum in the United States. It was preceded by the single \"Baby\", which is also, as of July 2014, the YouTube video with the most dislikes, and the most views on a Vevo platform. He followed up the release of his debut album with his first headlining tour, the My World Tour, the remix albums My Worlds Acoustic and Never Say Never – The Remixes, and the 3D biopic-concert film Justin Bieber: Never Say Never. Bieber released his second studio album Under the Mistletoe in November 2011, when it debuted at number one on the Billboard 200. Bieber released his third studio album Believe in June 2012. It became his fourth chart topper in the United States, debuting at number-one on the Billboard 200.\n\n
Bieber has received numerous industry awards, including both Artist of the Year Awards, at the 2010 American Music Awards, and the 2012 American Music Awards, and was nominated for Best New Artist and Best Pop Vocal Album at the 53rd Grammy Awards. With a global fan base, termed as \"Beliebers\", and over 40 million followers on Twitter, he was named by Forbes magazine in 2012 as the third-most powerful celebrity in the world.[10] However Bieber fell to number 9 on the list in 2013.
"
newText[12] <- paste(newText[12], junkText)
texts(changedCorpus) <- newText
ieDfm2 <- dfm(changedCorpus)
wf2 <- textmodel_wordfish(ieDfm2, dir=c(2,1))
# plot it and compare Ryan
quartz()
par(mfrow=c(2,1))
plot(wf, main="Without irrelevant text", color=c(rep("black", 9), "red", rep("black", 4)))
plot(wf2, main="With irrelevant text", color=c(rep("black", 13), "red"))


## demonstrate the effects of removing a text - NOT SO BAD
removeIndex <- c(8:10)  # remove 3/4 of Labour party
ieDfm3 <- as.dfm(ieDfm[-removeIndex, ])
ieDfm3 <- trimdfm(ieDfm3, minCount=1, minDoc=1)
wf3 <- textmodel_wordfish(ieDfm3, dir=c(2,1))
quartz()
plot(wf$theta[-removeIndex], wf3$theta, xlab="theta-hat all", ylab="theta-hat w/o Burton",
     main="Effects of changing the sample", pch=19)  # dot plot
text(wf$theta[-removeIndex], wf3$theta, docnames(ieDfm)[-removeIndex], cex=.8, pos=1)
abline(v=0, lty="dashed", col="red")

# compare to CA
ca3 <- textmodel_ca(ieDfm3)
plot(wca$rowcoord[-removeIndex,1], ca3$rowcoord[,1], xlab="CA all", ylab="CA reduced",
      main="Effects of changing the sample", pch=19)  # dot plot


