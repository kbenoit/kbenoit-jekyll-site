## Quantitative Analysis of Quantitative Data
##
## NYU Dept. of Politics short course Fall 2014
## 30 September 2014
##
## Code for examples from Day 2, Descriptive Stats - focus on quanteda copus creation
## Ken Benoit <kbenoit@lse.ac.uk>

library(quanteda)

####
#### 1. Getting texts into quanteda: some examples
####

## a) Russian texts

# read the texts into a corpus
stukalCorp1 <- corpus(directory("~/Dropbox/QUANTESS/corpora/pozhdata"), 
                      docvars="filenames")
size1 <- object.size(texts(stukalCorp1))
texts(stukalCorp1)[1]  # clearly not what we were expecting
# convert from Windows Cyrillic (aka Windows-1251)
texts(stukalCorp1) <- iconv(texts(stukalCorp1), from="WINDOWS-1251", to="UTF-8")
encoding(stukalCorp1) <- "UTF-8"
texts(stukalCorp1)[1]  # looks much better!

# now read and specify encoding at load time
stukalCorp2 <- corpus(directory("~/Dropbox/QUANTESS/corpora/pozhdata"), 
                      docvars="filenames",
                      enc="WINDOWS-1251")
size2 <- object.size(texts(stukalCorp2))

identical(object.size(stukalCorp1), object.size(stukalCorp2))
cat(as.numeric(size2 / size1), "times larger in UTF-8.\n")


## b) Spanish texts (Twitter data)

dir <- directory("~/Desktop/MUNGER/")
VNZ <- corpus(dir) # FAILS
VNZ <- corpus(dir, pattern="*")  # WORKS BUT ENCODING WRONG
texts(VNZ)[1]

# correct way
VNZ <- corpus(dir, enc="WINDOWS-1252", pattern="*")
texts(VNZ)[1]

# segment sentences
VNZsent <- changeunits(VNZ, "sentences", delimiter="\n")
texts(VNZsent)[1:3]

# remove leading and trailing \" characters
texts(VNZsent) <- gsub("^\"|\"$", "", texts(VNZsent))
texts(VNZsent)[1:3]

summary(VNZsent, 10, showmeta=TRUE)



## c) From A Spreadsheet (News items about companies)

# first the Excel sheet is saved as Comma-Separated Values format
tempdata <- read.csv("misc/ProQuest Corpus Demo 30.csv", header=TRUE,
                     stringsAsFactors=FALSE)
names(tempdata)
BonillaCorpus <- corpus(tempdata$Full.text, docnames=tempdata$StoreId)
summary(BonillaCorpus)

# now read in again to get factors for non-text data
tempdata <- read.csv("misc/ProQuest Corpus Demo 30.csv", header=TRUE)
docvars(BonillaCorpus) <- tempdata[, c(1:2, 5:7)]
metadoc(BonillaCorpus) <- tempdata[, c(1:2, 8:27)]

summary(BonillaCorpus, 2)
summary(BonillaCorpus, showmeta=TRUE, 2)


## d) Replication of lexical diversity measures from Labbé et al 2004

# construct the deGaulle corpus from Labbé, Cyril, Dominique Labbé, and Pierre
# Hubert. 2004. “Automatic Segmentation of Texts and Corpora.” Journal of
# Quantitative Linguistics 11(3): 193–213.
#
# I want to run some tests to replicate their Figure 8.
#
# These texts can be obtained from the University of Oxford Text Archive 
# at <http://www.ota.ox.ac.uk/desc/2466>.
#
# To get the docvars I copied "Annexe 1" from the file "Documentation/Corpus deGaulle.doc",
# worked with it a bit in a spreadsheet editor, and saved it as deGaulleData.csv in 
# comma-separated-value format.

# the "pattern" needs to be set to "*" to pick up all files, since it defaults to *.txt
deGaulle <- corpus(directory("~/Dropbox/QUANTESS/corpora/2466/2466/LEXICOMETRIEO/DeGaulle/DeGaulleTXT"),
                   pattern="*",
                   notes="Downloaded from University of Oxford Text Archive <http://www.ota.ox.ac.uk/desc/2466>",
                   source="Labbé, Cyril, Dominique Labbé, and Pierre Hubert. 2004. Automatic Segmentation \nof Texts and Corpora. Journal of Quantitative Linguistics 11(3): 193–213.")

# from the command-line (unix) "file" utility, I have pretty good info that these files
# are encoded as Latin-1, a.k.a. ISO-8859-1.  This will convert them to UTF-8.
texts(deGaulle) <- iconv(texts(deGaulle), from="LATIN1", to="UTF-8")
encoding(deGaulle) <- "UTF-8" # and tell the metadata about this

# read the document variables into a data.frame
myd <- read.csv("~/Dropbox/QUANTESS/quantedaData_kenlocal_gh/construction/deGaulleData.csv",
                header=TRUE, stringsAsFactors=FALSE)

myd$Date <- as.Date(myd$Date) # convert "Date" string into a Date class
docvars(deGaulle) <- myd      # assign the docvars - this will automatically 
                              # use the data.frame variable names for "field"
summary(deGaulle, showmeta=TRUE)

# save in the data directory
# save(deGaulle, file="~/Dropbox/QUANTESS/quantedaData_kenlocal_gh/data/deGaulle.Rdata")

## Try to recreate their Figure 8.
## (Clearly we do not have the same series.  I hope.)
plot(docvars(deGaulle, "Date"), 
     scale(statLexdiv(dfm(deGaulle, verbose=FALSE)))[,1], 
     type="l", xlab="", ylab="Standardized TTR",
     ylim=c(-7,5))
abline(h=0)
abline(h=c(2.56, -2.56), lty="dotted")


####
#### 2. Detecting collocations
####

library(quantedaData)
data(ie2010Corpus)
iecollocs <- collocations(ie2010Corpus, 300)


####
#### 3. Exploring texts
####

library(quantedaData)
data(ie2010Corpus)
kwic(ie2010Corpus, "Christmas")
kwic(ie2010Corpus, "outrage")
kwic(ie2010Corpus, "outrage", regex=FALSE)

####
#### 4. Lexical diversity
####

library(quantedaData)
data(iebudgets)
ieFinMin <- subset(iebudgets, no=="01")
summary(ieFinMin)
dfmFM <- dfm(ieFinMin, stopwords=TRUE)
plot(2012:2008, statLexdiv(dfmFM, "C"),
     xlab="Year", ylab="Herndan's C", type="b")

mydfm <- dfm(iebudgets, stopwords=TRUE)
plot(statLexdiv(mydfm, "Maas")[1,], statLexdiv(mydfm, "TTR"),
     xlab="Maas", ylab="TTR")


