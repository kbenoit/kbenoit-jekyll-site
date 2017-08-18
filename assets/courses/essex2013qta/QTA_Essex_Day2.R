##
## Demonstration for Day 2 of Essex QTA course


library(quanteda)
library(austin)

# load in Amicus texts
amicus.texts <- getTextDir("~/Dropbox/Classes/Essex QTA/Notes/Day 2 - Data Issues/JELS 2007 Text Files/")
amicus.corpus <- corpus.create(amicus.texts,
                               notes="Created as an example by KB for QTA Essex 2013, Day 2")

# summarize the corpus
summary(amicus.corpus)

# extract a word by document matrix
amicus.fvm <- create.fvm.corpus(amicus.corpus)
