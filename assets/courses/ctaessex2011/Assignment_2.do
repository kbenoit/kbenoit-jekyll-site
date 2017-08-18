/* #########################################
## Exercise 2 Answers in Stata
## remember to read the comments
##
## Ken Benoit
######################################### */

* ##### (5) 

*  Load in word frequency data
insheet using wordfreqm.csv
rename v1 word

* ##### (7a) total number of "types" (unique words) per document
recode socialisttxt - segolenetxt (0=.)
tabstat socialisttxt - segolenetxt, statistic(sum count median) save
matrix typetoken = r(StatTotal)

* ##### (7b) total number of words ("tokens") per document
matrix list typetoken

* ##### (7c) vocab diversity per document

* ##### (7d) median word freq per document

* ##### (7e) most frequently used word among all documents
egen total = rowtotal(socialisttxt-segolenetxt)
gsort -total
list word total in 1/20

* ##### demonstrate Zipf's law
gen rank = _n
gen logrank = log10(rank)
gen logtotal = log10(total)
graph twoway (scatter logtotal logrank) in 1/100
reg logtotal logrank
test logrank=-1.0

