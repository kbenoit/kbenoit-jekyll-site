## Exercise 4 Solution
## Ken Benoit and Paul Nulty
##

library(quanteda)

## (1) Collocations (a) on bush speeches
data(inaugCorpus)
bushspeeches <- getTexts(subset(inaugCorpus, president=="Bush" & year>1998))
collocations(bushspeeches, top=50)
collocations(bushspeeches, top=50, method="chi2")

# (b) bush speeches
obamaspeeches <- getTexts(subset(inaugCorpus, president=="Obama")
collocations(obamaspeeches, top=50)
collocations(obamaspeeches, top=50, method="chi2")

## (2) Document similarity
# (a) cosine distance between GW Bush and Obama
inaugCorpusBushObama <- subset(inaugCorpus, year>2000)
summary(inaugCorpusBushObama)
inaugDfm_nostem <- dfm(inaugCorpusBushObama)
library(proxy)
simil(inaugDfm_nostem, "cosine")
# (b) Euclidean distance (and normalized)
dist(inaugDfm_nostem, "Euclidean")
dist(tf(inaugDfm_nostem), "Euclidean")
# (c) compare head to head
distcomparison <- data.frame(cosine = as.vector(1 - simil(inaugDfm_nostem, "cosine")),
                             euclidean = as.vector(dist(tf(inaugDfm_nostem), "Euclidean")),
                             prespair = c("Bush2001-Bush2005",
                                          "Bush2001-Obama2009",
                                          "Bush2001-Obama2013",
                                          "Bush2005-Obama2009",
                                          "Bush2005-Obama2013",
                                          "Obama2009-Obama2013"))
distcomparison
cor(distcomparison$cosine, distcomparison$euclidean)
with(distcomparison, plot(cosine, euclidean))
with(distcomparison, text(cosine, euclidean, prespair, pos=3, cex=.5))

# (d) as binary measures
simil(inaugDfm_nostem>0, "cosine")
cor(simil(inaugDfm_nostem>0, "cosine"), 1-distcomparison$cosine)
dist(inaugDfm_nostem>0, "Euclidean")

## (3) resampling the 2009 Obama address (Yes we can!)

# (a) 
obama2009corpus <- subset(inaugCorpus, president=="Obama" & year==2009)
# (b)
obama2009corpusSentence <- corpusReshape(obama2009corpus)
# (c)
obamaSentenceVector <- getTexts(obama2009corpusSentence)
# (d)
paste(sample(obamaSentenceVector, size=10, replace=TRUE), collapse=" ")
# (3)
for (i in 1:3) {
    cat(paste("\nPossible Obama speech excerpt number", i, "\n"))
    print(paste(sample(obamaSentenceVector, size=10, replace=TRUE), collapse=" "))
}


####################################
#### PAUL TO DEMO NEW COMMANDS? ####
####################################

