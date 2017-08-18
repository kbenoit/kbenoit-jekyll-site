# how to compute precision and recall
performance <- function(restab) {
  precision <- diag(restab) / rowSums(restab)
  recall    <- diag(restab) / colSums(restab)
  f1        <- 2 * (precision * recall) / (precision + recall)
  accuracy  <- sum(diag(restab)) / sum(restab)
  return(data.frame(precision=precision, recall=recall, f1=f1, accuracy=accuracy,
                    row.names=colnames(restab)))
}




library(quanteda)
# this function computes accuracy and f-score from a 2x2 confusion matrix
getScores <- function(restab){
  acc <- (restab[1,1]+restab[2,2])/sum(restab)
  precA <- restab[1,1]  / (restab[1,1]+restab[2,1])
  precB <- restab[2,2]  / (restab[2,2]+restab[1,2])
  avPrec <- (precA+precB)/2
  
  recA <- restab[1,1] / (restab[1,1]+restab[1,2])
  recB <- restab[2,2]  / (restab[2,2]+restab[2,1])
  avRec <- (recA+recB)/2
  f <-2*(avPrec*avRec)/(avPrec+avRec)
  scores <- c(acc, f)
  names(scores) <- c("acc", "f")
  return(scores)
}

library(quanteda)
data(amicusTexts)
# set training class
trainclass <- factor(c("P", "R", rep(NA, length(amicusTexts)-2)))
# set test class
testclass  <- rep(NA, length(amicusTexts))
testclass[grep("AP", names(amicusTexts))] <- "AP"
testclass[grep("AR", names(amicusTexts))] <- "AR"
amicusCorpus <- 
  corpusCreate(amicusTexts, attribs=list(trainclass=trainclass, testclass=testclass))

library(quanteda)

data(amicusTexts)  # call up the vector of amicus texts
# set training class - we know that the first two texts are the Petitioner (P)
# and Respondent (R) briefs, respectively, and the rest should be missing (NA)
# to denote that these are not in the training set
trainclass <- factor(c("P", "R", rep(NA, length(amicusTexts)-2)))
testclass  <- rep(NA, length(amicusTexts))        # initialize test class as NA
testclass[grep("AP", names(amicusTexts))] <- "AP" # set AP (amicus P) for filenames with AP
testclass[grep("AR", names(amicusTexts))] <- "AR" # set AR for filenames with AR
# create the corpus with the trainclass and testclass as attributes
amicusCorpus <- corpusCreate(amicusTexts,
                             attribs=list(trainclass=trainclass, testclass=testclass))

# extract a word by document matrix
amicusDfm <- dfm(amicusCorpus)
amicus.nb <- naiveBayesText(amicusDfm, amicusCorpus$attribs$trainclass, smooth=1, prior="uniform")
amicus.nbp <- predict(amicus.nb)
nbrestab <- table(amicus.nbp$docs$nb.predicted, amicusCorpus$attribs$testclass )

performance(nbrestab)

wsrestab <- table(amicus.nbp$docs$ws.predicted, amicusCorpus$attribs$testclass )


##
# Part two: Calculating wordscores
#

# trainTexts <- c(amicusTexts[[1]], amicusTexts[[2]])
trainDfm <- dfm(amicusTexts[1:2])
Fwr <- tf(trainDfm)   # term frequencies
Pwr <- tf(t(Fwr))     # class posteriors with uniform priors
Ar <- c(-1.0, 1.0)    # weights for average of class posteriors
Sw <- Pwr %*% Ar      # dot product of weights and each row of Pwrs
Sw <- Sw[,1]          # make a simple vector
Sw <- sort(Sw)        # sort the wordscores



amicusDfm <- dfmTrim(dfm(amicusCorpus), min=3)
amicus.nb <- naiveBayesText(amicusDfm, 
                            getData(amicusCorpus)$trainclass, 
                            smooth=1, prior="uniform")
amicus.nbp <- predict(amicus.nb)

amicusDfmSmoothed <- amicusDfm + 1
Fwr <- tf(amicusDfm)        # term frequencies
sum(Fwr[1:2,] != amicus.nb$PwGc) # same as from NB computation (if sum of diffs==0)
cor(Fwr[1,], amicus.nb$PwGc[1,]) 
cor(Fwr[2,], amicus.nb$PwGc[2,]) 

Pwr <- tf(t(Fwr[1:2, ]))    # class posteriors with uniform priors
sum(t(Pwr) != amicus.nb$PcGw) # same as from NB computation (if sum of diffs==0)

Ar <- c(-1.0, 1.0)          # weights for average of class posteriors
Sw <- drop(Pwr %*% Ar)      # dot product of weights and each row of Pwrs
cor(Sw, amicus.nbp$words$wordscore.word)

# note: we drop the matrix format since only one column - Sw are the wordscores
# replace the missings in Sw with zeros for the purposes of wordscore calculations
(textscores <- Fwr %*% Sw)
round(cbind(textscores, amicus.nbp$docs$wordscore.doc), 4)
cor(cbind(textscores, amicus.nbp$docs$wordscore.doc))


## Example with LBG toy texts
data(lbg)
Fwr <- tf(lbg)        # term frequencies
Pwr <- tf(t(Fwr[1:5,]))    # class posteriors with uniform priors
Ar <- c(-1.5, -0.75, 0, .75, 1.5)          # weights for average of class posteriors
Sw <- drop(Pwr %*% Ar)      # dot product of weights and each row of Pwrs
# note: we drop the matrix format since only one column - Sw are the wordscores
# replace the missings in Sw with zeros for the purposes of wordscore calculations
(textscores <- Fwr %*% Sw)



