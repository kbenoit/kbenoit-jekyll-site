/*****  MLM May 2011 Course - Ken Benoit
 *****  Homework 2
 *****  Answers
 *****/

/***** 2.3.1 ******/
use http://www.stata-press.com/data/mlmus2/twin.dta, clear
gen pair = _n
reshape long twin, i(pair) j(twinno)

/***** 2.3.2 ******/
use http://www.stata-press.com/data/mlmus2/twin.dta, clear
expand num2
gen pair = _n
reshape long twin, i(pair) j(twinno)
bysort dzmz: xtreg twin, i(pair) mle
bysort dzmz: xtmixed twin || pair:, mle

/***** 2.3.4 ******/
xtreg twin if dzmz=="dz", i(pair) mle
di e(sigma_u)^2/(e(sigma_u)^2 + e(sigma_e)^2)
xtreg twin if dzmz=="mz", i(pair) mle
di e(sigma_u)^2/(e(sigma_u)^2 + e(sigma_e)^2)

