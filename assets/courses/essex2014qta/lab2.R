library(quanteda)
data(exampleString)

# 1a
#
# note ambiguity of 'Fine/fine'
cleanedString <- clean(exampleString)
# with different parameters
withUpper <- clean(exampleString,  lower = FALSE)