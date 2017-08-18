## 
## R code for TCD Quantitative Text Analysis Exercise 1
##

zipLoader <- function(path) {
# function to download a zipped file of texts and return them as a character vector
  isUrl <- ifelse(substr(path,1,4) == 'http', TRUE, FALSE)
  if (isUrl) {
    file <- basename(path)
    download.file(path, file)
    basetemp <- file.path(".", "temp")
    unzip(file, exdir=basetemp)
    dirs <- list.files(basetemp, recursive=FALSE)
    thisPath <- file.path(basetemp)
    texts <- c()
    for (d in dirs) {
      if (file.info(paste(basetemp, "/", d, sep=""))$isdir) 
        texts <- c(texts, getTextDir(file.path(thisPath,d)))
    }    
  } else {
    basetemp <- file.path(".", "temp")
    unzip(file, exdir= basetemp)
    dirs <- list.files(basetemp)
    thisPath <- file.path(basetemp)
    texts <- getTextDir(thisPath)
    for(d in dirs) {
      texts <- c(texts, getTextDir(file.path(thisPath,d)))
    }    
  }
  unlink(basetemp, recursive = TRUE)
  return(texts)
}

library(quanteda) # you must first install this from http://github.com/kbenoit/quanteda


##
## Irish budget 2010 speech corpus
##
# get the texts
texts <- zipLoader("/assets/courses/tcd2014qta/exercises/budget_2010.zip")
# extract the party, speaker, etc info from the filenames and put these in a data frame
parts <- strsplit(getRootFileNames(names(texts)), "_")
newattribs <- data.frame(matrix(unlist(parts), nrow=length(parts), byrow=TRUE))
names(newattribs) <- c("year", "debate", "no", "speakerFname", "speakerLname", "party")
newattribs$party <- gsub(".txt", "", newattribs$party)
newattribs
# call quanteda function to create the corpus
budget2010 <- corpus.create(texts, attribs=newattribs)
# summarize the new corpus
summary(budget2010)

# extract a document-term matrix (by speaker)
budget2010.dtm.speaker <- create.fvm.corpus(budget2010)
# extract a document-term matrix aggregated by party
budget2010.dtm.party <- create.fvm.corpus(budget2010, group="party")


##
## UK Manifestos
##
texts <- zipLoader("/assets/courses/tcd2014qta/exercises/UK_Manifestos.zip")
fnames <- getRootFileNames(names(texts))
# need same number of parts for each file
fnames <- gsub("_a.txt", "a.txt", fnames)
fnames <- gsub("_b.txt", "b.txt", fnames)
parts <- strsplit(getRootFileNames(fnames), "_")
newattribs <- data.frame(matrix(unlist(parts), nrow=length(parts),  byrow=TRUE))
names(newattribs) <- c("country", "level", "year", "language", "party")
UKMan <- corpus.create(texts, attribs=newattribs[, c("year", "party")])
UKMan.dtm.party <- create.fvm.corpus(UKMan, group="party")
UKMan.dtm.year <- create.fvm.corpus(UKMan, group="year")


##
## Amicus briefs:  Bollinger texts from Evans et al JELS 2007
##
# load in Amicus texts from a zipped web archive
amicusFile <- "/assets/courses/tcd2014qta/exercises/amicus_curiae.zip"
download.file(amicusFile, basename(amicusFile))
unzip(basename(amicusFile))
# load in the texts to a vector of texts using quanteda's getTextDir()
amicus.texts <- c(getTextDir("./amicus/training"), getTextDir("./amicus/testing"))
# change the encoding (because texts contain special symbols such as §)
amicus.texts <- iconv(amicus.texts, from="latin1", to="UTF-8")
# set training class
trainclass <- factor(c("P", "R", rep(NA, length(amicus.texts)-2)))
# set test class
testclass  <- rep(NA, length(amicus.texts))
testclass[grep("AP", names(amicus.texts))] <- "AP"
testclass[grep("AR", names(amicus.texts))] <- "AR"
amicus.corpus <- 
  corpus.create(amicus.texts, attribs=list(trainclass=trainclass, testclass=testclass))
summary(amicus.corpus)

