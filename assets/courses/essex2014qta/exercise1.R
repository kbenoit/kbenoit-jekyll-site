#
# Essex Summer School: Quantitative Text Analysis
# Code for Exercise 1
# Kenneth Benoit and Paul Nulty
# 

#
# Part One: Installing quanteda
#


# devtools required to install quanteda from Github
if (!require(devtools)) install.packages("devtools")

library(devtools)
# install the latest version of quantedafrom Github
install_github("quanteda", username="kbenoit", ref='dev', quick=TRUE)
library(quanteda)


#
# Part Two: Making a corpus from a vector of texts
#

data(amicusTexts)
amiCorp <- corpusCreate(amicusTexts)
summary(amiCorp)
amiCorp$metadata

#
# Part Three: Other ways of making a corpus
# Analyze Bollinger texts from Evans et al JELS 2007
# load in Amicus texts from a zipped web archive

#
# 3a: corpus from a directory

# download and unzip texts
amicusFile <- "/assets/courses/tcd2014qta/exercises/amicus_curiae.zip"
download.file(amicusFile, basename(amicusFile))
unzip(basename(amicusFile))

# load in the texts to a vector of texts using quanteda's getTextDir()
amicusTexts <- c(getTextDir("./amicus/training"), getTextDir("./amicus/testing"))

# change the encoding (because texts contain special symbols such as §)
amicusTexts <- iconv(amicusTexts, from="latin1", to="UTF-8")

# set training class
trainclass <- factor(c("P", "R", rep(NA, length(amicusTexts)-2)))

# set test class using grep on filenames
testclass  <- rep(NA, length(amicusTexts))
testclass[grep("AP", names(amicusTexts))] <- "AP"
testclass[grep("AR", names(amicusTexts))] <- "AR"

# make the corpus from the texts and the attributes
amicusCorpus <- 
  corpusCreate(amicusTexts, attribs=list(trainclass=trainclass, testclass=testclass))
summary(amicusCorpus)

#
# 3d: demonstration of grep command
#
matches <- grep("equality", amicusCorpus$attribs$texts)  # any occurrence of "equality"
matchTexts <- amicusCorpus$attribs$texts[matches]
matches <- grep("\\bequality\\b", amicusCorpus$attribs$texts) # whole word only
matchTexts <- amicusCorpus$attribs$texts[matches]
             

#
# 3e,f: Corpus with attributes from filenames
#

# Windows might need escaped backslashes in file path eg "C:\\Downloads\\texts"
iebudCorp <- corpusFromFilenames("S:\\2E_QTA\\budget_2010\\", attNames = c("year","type","number", "fname","lname","party"))
