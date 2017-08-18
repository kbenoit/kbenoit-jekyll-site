install_github('quanteda', username='kbenoit', ref='dev',quick=TRUE)
library(quanteda)
#
# Part 1
#

data(iebudgets)
iebudgets2010 <- subset(iebudgets, year==2010)
# use the kwic

#
# 2a
#

#dfm

#
# 2b
#

# 
# Hint: Use rowSums(docMat>0) for types
# "docMat > 0" returns a matrix of booleans (TRUE or FALSE) indicating whether
# the value in each cell is > 0 , and rowSums will count the TRUEs. 


#
# 2c
#
# most frequent word

#check out ?sort and ?dfmSort


#
# 2d
#

# number of sentences in all texts
# $ symbol accesses attribute of data frame

# summary

#
# 2e
#

# syllable counts of all texts



#
# 2f
#
# Fleisch-Kincaid

# sum() will get a sum of a vector 


#
# 3
#
# Type-token ratio by year


#4
#
###### demonstrate Zipf's law