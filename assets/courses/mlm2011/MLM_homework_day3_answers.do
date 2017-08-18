/*****  MLM May 2011 Course - Ken Benoit
 *****  Homework 3
 *****  Answers
 *****/

/***** 3.2.1 ******/
use http://www.stata-press.com/data/mlmus2/neighborhood.dta, clear
xtmixed attain || neighid:, mle nolog
di (.44893^2)/( .44893^2 + .8968671^2) * ICC

/***** 3.2.2 ******/
xtmixed attain deprive || neighid:, mle nolog

/***** 3.2.3 ******/
xtmixed attain deprive p7vrq-male || neighid:, mle nolog
reg attain deprive p7vrq-male

/***** 3.2.4 ******/
di (.44893^2 + .8968671^2 - (.0789157^2 + .6757447^2)) / (.44893^2 + .8968671^2)
quietly reg attain deprive p7vrq-male
di e(r2)

/***** 3.2.5 extra ******/
xtmixed attain deprive dad* || neighid:, mle nolog
xtreg attain deprive dad*, i(neighid)
xi: reg attain deprive dad* i.neighid
