#
# Get the data
#

library(quanteda)
data(UKManifestos)
corpus <- subset(UKManifestos, (year %in% c(1992, 2001, 2005) & (party %in% c("Lab", "LD", "Con", "BNP", "UKIP"))))

#
# Part One
#
# use the populism dictionary from orignal paper.
dictionaryPopulismEN <-
  list(populism=c("elit*", "consensus*", "undemocratic*", "referend*",
                  "corrupt*", "propagand", "politici*", "*deceit*",
                  "*deceiv*", "*betray*", "shame*", "scandal*", "truth*",
                  "dishonest*", "establishm*", "ruling*"))

populismDfm <- dfm(corpus, dictionary=dictionaryPopulismEN)
perc <- data.frame(populismDfm, percentage=(populismDfm[,'populism'] / (rowSums(populismDfm) * 100) ))


data(UKManifestos)
corpus <- subset(UKManifestos, (year %in% c(1992, 1997, 2001, 2005) & (party %in% c("Lab", "LD", "Con", "BNP", "UKIP"))))

## Import Laver-Garry dictionary
LGdict <- readWStatDict("~/Dropbox/QUANTESS/wordstatTest/dictionaries/LaverGarry.cat")

corpus92 <- subset(corpus, year=="1992")
byParty92 <- dfm(corpus92, group="party", dictionary=LGdict)
lab92 <- byParty92["Lab", "ECONOMY.+STATE+"]-byParty92["Lab", "ECONOMY.-STATE-"]
con92 <- byParty92["Con", "ECONOMY.+STATE+"]-byParty92["Con", "ECONOMY.-STATE-"]
libDem92 <- byParty92["LD", "ECONOMY.+STATE+"]-byParty92["LD", "ECONOMY.-STATE-"]

ys92 <- c(lab92,con92,libDem92)

corpus97 <- subset(corpus, year=="1997")
byParty97 <- dfm(corpus97, group="party", dictionary=LGdict)
lab97 <- byParty97["Lab", "ECONOMY.+STATE+"]-byParty97["Lab", "ECONOMY.-STATE-"]
con97 <- byParty97["Con", "ECONOMY.+STATE+"]-byParty97["Con", "ECONOMY.-STATE-"]
libDem97 <- byParty97["LD", "ECONOMY.+STATE+"]-byParty97["LD", "ECONOMY.-STATE-"]

ys97 <- c(lab97,con97,libDem97)

plot( c(1992,1992,1992,1997,1997,1997), c(ys92, ys97), xlab="year", ylab="pro-state index")
labels <- c("lab","con","LD","lab","con","LD")
text(c(1992,1992,1992,1997,1997,1997), c(ys92, ys97) , labels=labels, pos=4)

#
#


