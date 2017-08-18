## Quantitative Analysis of Quantitative Data
##
## NYU Dept. of Politics short course Fall 2014
## 27 October 2014
##
## Code for examples from Day 5, Classifiers and supervised learning
## Ken Benoit <kbenoit@lse.ac.uk>

## LBG (2003) Table 1 example
library(quantedaData)
data(LBGexample)
wsFitted <- textmodel(LBGexample, c(seq(-1.5, 1.5, .75), NA), model="wordscores")
wsFitted
predict(wsFitted)
predict(wsFitted, rescaling="mv") # with Martin-Vanberg (2007) rescaling

## replicate LBG (2003) UK Manifestos scaling
data(ukManifestos)
ukCorpus <- subset(ukManifestos, Year %in% c(1992, 1997) & Party %in% c("Con", "Lab", "LD"))
docnames(ukCorpus) <- paste(docvars(ukCorpus, "Party"), docvars(ukCorpus, "Year"), sep="_")
ukDfm <- dfm(ukCorpus)
summary(ukCorpus)
wsFitted <- textmodel(ukDfm, c(17.21, 5.35, 8.21, rep(NA, 3)), model="wordscores")
wsFitted$pi[c("drugs", "minorities", "unemployment")]
# almost but not exactly!
predict(wsFitted)
pred <- predict(wsFitted, newdata=ukDfm[4:6,], rescaling="lbg")

# with smoothing
wsFittedSm <- textmodel(ukDfm, c(17.21, 5.35, 8.21, rep(NA, 3)), model="wordscores", smooth=1)
predict(wsFittedSm)
predsm <- predict(wsFittedSm, newdata=ukDfm[4:6,], rescaling="lbg")
cor(pred$textscore_lbg, predsm$textscore_lbg)

## compare to austin results
require(austin)
ref <- as.wfm(ukDfm[1:3,], word.margin=2)
ws <- classic.wordscores(ref, scores = c(17.21, 5.35, 8.21))
summary(ws)
vir <- as.wfm(ukDfm[4:6,], word.margin=2)
austinWS <- predict(ws, newdata=vir)
cor(pred$textscore_raw, austinWS$Score)
cor(pred$textscore_raw_se, austinWS[,2])


####
#### Multinomial Naive Bayes results using IIR Example 13.1
####
## Example from 13.1 of _An Introduction to Information Retrieval_
trainingset <- matrix(0,ncol=6,nrow=5)
trainingset[1,] <- c(1, 2, 0, 0, 0, 0)
trainingset[2,] <- c(0, 2, 0, 0, 1, 0)
trainingset[3,] <- c(0, 1, 0, 1, 0, 0)
trainingset[4,] <- c(0, 1, 1, 0, 0, 1)
trainingset[5,] <- c(0, 3, 1, 0, 0, 1)
colnames(trainingset) <- c("Beijing", "Chinese",  "Japan", "Macao", "Shanghai", "Tokyo")
rownames(trainingset) <- paste("d", 1:5, sep="")
trainingset <- as.dfm(trainingset)
trainingclass <- factor(c("Y", "Y", "Y", "N", NA), ordered=TRUE)

### replicate IIR p261 prediction for test set (document 5)
nb.p261 <- textmodel(trainingset, trainingclass, "NB", smooth=1, prior="docfreq")
pr.p261 <- predict(nb.p261)
pr.p261


### Test aggregation of NB to document v word level
(nb.p261 <- naiveBayesText(trainingset, trainingclass, smooth=1, prior="uniform"))
(p <- predict(nb.p261, scores=c(-1,1))) # full predicted probabilities
1-2*nb.p261$PcGw[1,]  # word-level wordscores: word scores as 1-2*P(w|c=1)
1-2*p$docs$wordscore.doc       # document-level "wordscores": 2-reference text score for virgin text (d5)


###
### Amicus texts from Evans et al
###
require(quantedaData)
data(amicusCorpus)
summary(amicusCorpus)
amDfm <- dfm(amicusCorpus)
#amNBmodel <- textmodel(docvars(amicusCorpus, "trainclass") ~ amDfm,
#                       model="NB", smooth=1) 
amNBmodel <- textmodel(amDfm, docvars(amicusCorpus, "trainclass"), model="NB", smooth=1) 
print(amNBmodel, 10)
(amNBpredict <- predict(amNBmodel))
# "confusion matrix"
table(amNBpredict$docs$nb.predicted, docvars(amicusCorpus, "testclass"))

reference <- c(1, 1, -1, -1, rep(NA, 98))
amWSmodel <- textmodel(amDfm, reference, model="wordscores", smooth=1)
plot(amWSmodel$pi, c(1, -1) %*% amNBmodel$PcGw, xlab="Wordscore", ylab="Linear Posterior Class Pr. Diff")
(amWSpredict <- predict(amWSmodel))

## plot differences between scaling and NB class prediction
quartz(width=6, height=12)
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
dev.copy2pdf(file="figures/amicusWSvBS.pdf")



###
### STUFF STILL EXPERIMENTAL
###

inaugPost1980Corpus <- subset(inaugCorpus, Year>1980)
inaugPost1960Corpus <- subset(inaugCorpus, Year>1960)

docvars(inaugPost1980Corpus, "Party") <- c(rep("Rep",3), rep("Dem",2), rep("Rep",2), rep("Dem",2))
docvars(inaugPost1960Corpus, "Party") <- c(rep("Dem", 2), rep("Rep",2), "Dem", rep("Rep",3), rep("Dem",2), rep("Rep",2), rep("Dem",2))

inaugPost1980dfm <- dfm(inaugPost1980Corpus)
party <- docvars(inaugPost1980Corpus, "Party")
party[length(party)] <- NA
inaugNBT <- naiveBayesText(inaugPost1980dfm, factor(party))
inaugNBTpr <- predict(inaugNBT)
table(inaugNBTpr$docs$nb.predicted, docvars(inaugPost1980Corpus, "Party"))
inaugNBTpr$docs[c("Dem", "Rep")]

inaugPost1960dfm <- dfm(inaugPost1960Corpus)
party <- docvars(inaugPost1960Corpus, "Party")
party[5] <- NA
inaugNBT <- naiveBayesText(inaugPost1960dfm, factor(party), smooth=1)
inaugNBTpr <- predict(inaugNBT)
table(inaugNBTpr$docs$nb.predicted, docvars(inaugPost1960Corpus, "Party"))
inaugNBTpr$docs[c("Dem", "Rep")]

library(e1071)
inaugNB <- naiveBayes(inaugPost1960dfm, factor(party), laplace=1)
inaugNBpr <- predict(inaugNB, inaugPost1960dfm)
inaugNBpr
predict(inaugNB, inaugPost1960dfm, "raw")
table(inaugNBpr, docvars(inaugPost1960Corpus, "Party"))

# Very difference results for Carter!

data(HouseVotes84, package = "mlbench")
model <- naiveBayes(HouseVotes84[, -1], HouseVotes84$Class)
str(predict(model, HouseVotes84[1:10,]))
table(predict(model, HouseVotes84[1:10,]), HouseVotes84$Class[1:10])
predict(model, HouseVotes84[1:10,], type = "raw")

modelNBT <- naiveBayesText(HouseVotes84[, -1], HouseVotes84$Class)
str(predict(model, HouseVotes84[1:10,]))
table(predict(model, HouseVotes84[1:10,]), HouseVotes84$Class[1:10])
predict(model, HouseVotes84[1:10,], type = "raw")






