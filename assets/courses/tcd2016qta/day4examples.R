## Day 4 Examples: Supervised and Unsupervised scaling
##
## Ken Benoit <kbenoit@tcd.ie>

# require(quanteda)

## LBG (2003) Table 1 example
wsFitted <- textmodel(LBGexample, c(seq(-1.5, 1.5, .75), NA), model = "wordscores")
wsFitted
predict(wsFitted)
predict(wsFitted, rescaling = "mv") # with Martin-Vanberg (2007) rescaling


## replicate LBG (2003) UK Manifestos scaling
data(ukManifestos, package = "quantedaData")
ukCorpus <- subset(ukManifestos, Year %in% c(1992, 1997) & Party %in% c("Con", "Lab", "LD"))
docnames(ukCorpus) <- paste(docvars(ukCorpus, "Party"), docvars(ukCorpus, "Year"), sep="_")
summary(ukCorpus)
ukDfm <- dfm(ukCorpus)
wsFitted <- textmodel(ukDfm, c(17.21, 5.35, 8.21, rep(NA, 3)), model = "wordscores")
wsFitted@Sw[c("drugs", "minorities", "unemployment")]
# almost but not exactly!
predict(wsFitted)
(pred <- predict(wsFitted, newdata = ukDfm[4:6, ], rescaling = "lbg"))

# with smoothing
wsFittedSm <- textmodel(ukDfm, c(17.21, 5.35, 8.21, rep(NA, 3)), model = "wordscores", smooth = 1)
predict(wsFittedSm)
predsm <- predict(wsFittedSm, newdata = ukDfm[4:6,], rescaling = "lbg")
cor(pred@textscores$textscore_lbg, predsm@textscores$textscore_lbg)


###
### Amicus texts from Evans et al
###
data(amicusCorpus, package = "quantedaData")
summary(amicusCorpus, 10)
amDfm <- dfm(amicusCorpus, verbose = FALSE)
amNBmodel <- textmodel(amDfm, docvars(amicusCorpus, "trainclass"), 
                       model = "NB", smooth = 1) 
print(amNBmodel, 10)
(amNBpredict <- predict(amNBmodel))
# "confusion matrix"
table(amNBpredict$docs$predicted, docvars(amicusCorpus, "testclass"))

reference <- c(1, 1, -1, -1, rep(NA, 98))
amWSmodel <- textmodel(amDfm, reference, model = "wordscores", smooth = 1)
plot(amWSmodel@Sw, c(1, -1) %*% amNBmodel$PcGw, xlab = "Wordscore", ylab = "Linear Posterior Class Pr. Diff")
(amWSpredict <- predict(amWSmodel))

## plot differences between scaling and NB class prediction
pdf("amicusWSvBS.pdf", width=6, height=12)
par(mfrow=c(2,1))
plot(jitter(amNBpredict$word$wordscore.word,20), 
     jitter(amNBpredict$word$bayesscore.word,20),
     pch=19, cex=.6, main="(a) Word level", col="grey70",
     xlab="Wordscores - linear difference", ylab="Wordscores - log difference")
plot(jitter(amNBpredict$docs$wordscore.doc[-c(1,2)],20), 
     jitter(amNBpredict$docs$bayesscore.doc[-c(1,2)],20),
     pch=19, cex=.6, main="(b) Document level",
     col=ifelse(docvars(amicusCorpus, "testclass")=="AP", "blue", "red"),
     xlab="Text scores - linear difference", ylab="Text scores - log difference")
abline(v=0, lty="dashed", col="grey80")
dev.off()


## Irish 2010 budget debate from Lowe and Benoit (2013)

## standard models
# make prettier document names
docnames(ie2010Corpus) <- paste(docvars(ie2010Corpus, "name"), docvars(ie2010Corpus, "party"))
ieDfm <- dfm(ie2010Corpus)
wf <- textmodel(ieDfm, model = "wordfish", dir = c(2,1))
wca <- textmodel(ieDfm, model = "ca", dir = c(2,1))

summary(wf)
summary(wca, columns = FALSE)

plot(wf@theta, -1*wca$rowcoord[,1], xlab="Wordfish theta-hat", ylab="CA dim 1 coordinate",
     main="Wordfish v CA dim 1", pch=19, xlim = c(-1.5, 1.5), ylim = c(-1.5, 1.5))
text(wf@theta, -1*wca$rowcoord[,1], docnames(ieDfm), cex=.8, pos=1)
abline(v=0, lty="dashed", col="red")
abline(lm(-1*wca$rowcoord[,1] ~ wf@theta), col="grey50", lty="dotted")

## plotting CA results
# CA plot in 2 dimensions
# quartz(width=5, height=5)
srt <- order(wca$rowcoord[,1], decreasing=TRUE)
# one dimension
dotchart(-1*wca$rowcoord[srt,1], labels=docnames(ieDfm)[srt])
# two dimensions
plot(wca, what=c("all", "none"))

changedCorpus <- ie2010Corpus
## demonstrate the effects of irrelevant text
newText <- texts(changedCorpus)
# some really irrelevant text, from Justin Bieber's Wikipedia page
junkText <- "   
Justin Drew Bieber (born March 1, 1994)[4][5] is a Canadian singer and songwriter. Bieber's current manager, Scooter Braun first discovered him through his YouTube videos in 2007.[6] Braun was impressed with the videos, and contacted Bieber's mother Pattie about wanting to work with him. After convincing Bieber's mother, Braun arranged for Bieber to meet with Usher in Atlanta, Georgia. Bieber was signed to RBMG,[7] and then to an Island Records recording contract offered by record executive, L.A. Reid.[3][8]\n\n
Bieber released his debut EP, My World, in November 2009. It was certified platinum in the United States. He became the first artist to have seven songs from a debut record to chart on the Billboard Hot 100.[9] Bieber released his first full-length studio album, My World 2.0, in March 2010. It debuted at or near number one in several countries and was certified platinum in the United States. It was preceded by the single \"Baby\", which is also, as of July 2014, the YouTube video with the most dislikes, and the most views on a Vevo platform. He followed up the release of his debut album with his first headlining tour, the My World Tour, the remix albums My Worlds Acoustic and Never Say Never – The Remixes, and the 3D biopic-concert film Justin Bieber: Never Say Never. Bieber released his second studio album Under the Mistletoe in November 2011, when it debuted at number one on the Billboard 200. Bieber released his third studio album Believe in June 2012. It became his fourth chart topper in the United States, debuting at number-one on the Billboard 200.\n\n
Bieber has received numerous industry awards, including both Artist of the Year Awards, at the 2010 American Music Awards, and the 2012 American Music Awards, and was nominated for Best New Artist and Best Pop Vocal Album at the 53rd Grammy Awards. With a global fan base, termed as \"Beliebers\", and over 40 million followers on Twitter, he was named by Forbes magazine in 2012 as the third-most powerful celebrity in the world.[10] However Bieber fell to number 9 on the list in 2013.
"
newText[11] <- paste(newText[11], junkText)
ieDfm2 <- dfm(newText)
wf2 <- textmodel(ieDfm2, model = "wordfish", dir=c(2,1))
# plot it and compare Ryan
theta1 <- wf@theta; theta2 <- wf2@theta
names(theta1) <- names(theta2) <- wf@docs
sortOrder <- order(theta1)
theta1 <- theta1[sortOrder]
theta2 <- theta2[sortOrder]
par(mfrow=c(2,1))
dotchart(theta1, main="Without irrelevant text", col = c(rep("black", 11), "red", rep("black", 2)))
dotchart(theta2, main="With irrelevant text",    col = c(rep("black", 11), "red", rep("black", 2)))


## demonstrate the effects of removing a text - NOT SO BAD
removeIndex <- c(8:10)  # remove 3/4 of Labour party
ieDfm3 <- ieDfm[-removeIndex, ]
ieDfm3 <- trim(ieDfm3, minCount=1, minDoc=1)
wf3 <- textmodel(ieDfm3, model = "wordfish", dir=c(2,1))
plot(wf@theta[-removeIndex], wf3@theta, xlab="theta-hat all", ylab="theta-hat w/o Burton",
     main="Effects of changing the sample", pch=19,
     xlim = c(-1.5, 1.5), ylim = c(-1.5, 1.5))
text(wf@theta[-removeIndex], wf3@theta, docnames(ieDfm)[-removeIndex], cex=.8, pos=1)
abline(v=0, lty="dashed", col="red")

# compare to CA effects of removing the sample
ca3 <- textmodel(ieDfm3, model = "ca", dir = c(2,1))
plot(wca$rowcoord[-removeIndex,1], ca3$rowcoord[,1], xlab="CA all", ylab="CA reduced",
     main="Effects of changing the sample", pch=19)  # dot plot
text(wca$rowcoord[-removeIndex,1], ca3$rowcoord[,1], docnames(ieDfm)[-removeIndex], cex=.8, pos=1)
abline(v=0, lty="dashed", col="red")







