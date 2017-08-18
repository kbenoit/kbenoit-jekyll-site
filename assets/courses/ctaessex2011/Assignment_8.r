
library(austin)
library(ca)
data(iebudget2009)

# estimate the CA model
ca.model <- ca(iebudget2009)

# extract speaker column positions and names
results <- data.frame(pos=ca.model$colcoord[,1], names=ca.model$colnames)
results <- results[order(results$pos),]
# one-dimensional plot of speaker positions
dotchart(results$pos, labels=results$names)

# two dimensional plot of words and speakers
plot(ca.model, labels=c(1,2))

