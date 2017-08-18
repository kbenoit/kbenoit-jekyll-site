/*****  MLM May 2011 Course - Ken Benoit
 *****  Example 
 *****  Answers
 *****/

clear
set mem 600m

use http://www.kenbenoit.net/classes/mlm2011/ESSexample.dta
rename  q24R turnout
rename t101 countryid
preserve
collapse (mean) toutC turnout, by(countryid)
gen turnout100 = turnout*100
graph twoway (scatter toutC turnout100, mlab(t101)) (function y=x, range(0 100))
restore

desc turnout q84 q79 q78 postcom age v200

ren q84 satisfdem
recode satisfdem (7 8 = .)

ren q79 satisfEU
recode satisfEU (3=0) (2=-1) (7 8=.)

ren q78 interestpol
recode interestpol (7 8 = .)

ren v200 education
recode education (71 77 88 99 = .)

logit turnout satisf* interestpol education postcom, nolog
xtlogit turnout satisf* interestpol education postcom, i(countryid) nolog
