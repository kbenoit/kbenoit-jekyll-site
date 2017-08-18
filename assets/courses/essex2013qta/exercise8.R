###
### Exercise 8: Wordscores
### Quantitative Text Analysis, Essex 2013
### Kenneth Benoit
###

# load the austin library
library(austin)

###
### proof-of-concept data from LBG (2003)
###
# load the data (built in to austin)
data(lbg)
# extract the reference documents as documents 1 through 5
ref <- getdocs(lbg, 1:5)
# set the wordscores as -1.5 through 1.5
ws <- classic.wordscores(ref, scores=c(-1.5, -0.75, 0, 0.75, 1.5))
summary(ws)
# use V1 as the virgin document
vir <- getdocs(lbg, 'V1') 
# score the virgin document
predict(ws, newdata=vir)


###
### score the budget speeches from the budget 2010 debate
###
# load the .csv frequency file, transpose it so that docs=columns
budget2010 <- t(read.csv("/assets/courses/essex2012cta/budget_2010.csv",
                         row.names=1))
# coerce the object into an austin "wfm" object
budget2010 <- as.wfm(budget2010)
# look at the document name list
colnames(budget2010)
# extract 5 and 6 (Cowen and Kenny) as "reference" documents
ref <- getdocs(budget2010, c(5,6))
# set the reference scores at 1 for Cowen and -1 for Kenny
ws <- classic.wordscores(ref, scores=c(1,-1))
# summarize the word scores as assigned
summary(ws)
# now score all documents as "virgin" documents
vir <- getdocs(budget2010, 1:14)
textscores <- predict(ws, newdata=vir)
# sorts the scored documents 
textscores[order(textscores$Score),]
# inspect the word scores
View(ws$pi[order(ws$pi),])

# a plot of the wordscores
plot(ws$pi[order(ws$pi),])
     
# a plot of the document scores
plot(textscores$Score[order(textscores$Score)])
