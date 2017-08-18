

/*** illustrate bootstrap sampling ***/
/* using sample to generate permutations of the sequence 1:10 */
clear
set obs 10
gen x = _n
list, clean
bsample
list, clean
bsample
list, clean

/* boostrap SE of median */
use http://www.kenbenoit.net/classes/ME104/dail2002.dta, clear
/* analytic std error of mean */
quietly summ spend_total, detail
di "mean = " r(mean) "    median = " r(p50)
di "analytic SE of mean = " r(sd) / sqrt(r(N))
bootstrap r(mean) r(p50), reps(1000) saving(day10bs1.dta, replace): summ spend_total, detail 
use day10bs1, clear
list in 1/10, clean
rename _bs_1 BSmean
rename _bs_2 BSmedian
kdensity BSmean, name(meandens, replace)
kdensity BSmedian, name(meddens, replace)


/* bootstrap logit coefficients */
use http://www.kenbenoit.net/classes/ME104/dail2002.dta, clear
logit wonseat c.spend_total##incumb
bootstrap, reps(200): logit wonseat c.spend_total##incumb
/* with small sample */
sample 50, count
logit wonseat c.spend_total##incumb
bootstrap, reps(100): logit wonseat c.spend_total##incumb


/* demonstrate estimation uncertainty through stochastic simulation of parameters */
use http://www.kenbenoit.net/classes/ME104/dail2002, clear
gen spend_totalXinc = spend_total * incumb
estsimp logit wonseat spend_total spend_totalXinc incumb m, robust cluster(district)

setx mean
setx m 4

/***** fitted values for challengers */
setx incumb 0 spend_totalXinc 0 
foreach s of numlist 0 5000 10000 15000 20000 25000 40000 {
	display `s' 
	setx spend_total `s'
        simqi 
}
simqi fd(prval(1)) changex(spend_total 0 15000)
simqi fd(prval(1)) changex(spend_total 15000 20000)

