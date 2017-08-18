
// demonstrate Zipfs law from UK texts
// need to export the term-document matrix from Wordstat first
insheet using ukfreqs.csv
gsort -frequency
generate logf = log(frequency)
gen rank = _n
gen logr = log(rank)
graph twoway (scatter logf logr) (lfit logf logr)
graph twoway (scatter logf logr) (lfit logf logr) in 1/1000
