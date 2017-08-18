/*ME104 Problem set 5*/
/*Multiple linear regression*/

clear all

/*open stata file parking.dta*/

/*1*/
/*Revision*/

twoway (scatter ... , mlabel(...)), ytitle(...) xtitle(...)

gen logviol=ln(1+...)
twoway (scatter ... ..., mlabel(...)), ytitle(...) xtitle(log(...))

/*2*/
regress logviol ... ... ...

/*3*/
rvfplot, name(rvfplot) mlabel(countrycode)

/*4*/
estat hettest 
/*An insignificant result indicates lack of heteroskedasticity*/

/*5*/
/*Calculating residuals and fitted values, for the most recently fitted model*/

predict yhat, xb // unstandardised fitted value
egen zyhat = std(yhat)   // standardised fitted value 
predict sresid, rstudent // studentised residual

scatter sresid zyhat, mlabel(countrycode)

/*6*/
/*Check leverage's to identify observations that will have potential great influence 
on regression coefficient estimates*/
predict lev, leverage
stem lev
/*Generally, a point with leverage greater than (2k+2)/n should be carefully examined. 
k is the number of predictors and n is the number of observations. In our example:*/ 
display (2*3+2)/146
list countrycode lev if lev>=.05479452 & lev!=.

/*7*/
lvr2plot, mlabel(countrycode)
avplots, mlabel(countrycode)
/*OR*/
avplot dipl  , mlabel(countrycode)
avplot loggdp, mlabel(countrycode)
avplot corruption, mlabel(countrycode)

/*8*/
predict distance, cooksd 
/*The convention cut-off point is 4/n.*/
list countrycode distance if distance>4/146 &  !missing(distance)

/*9*/
ovtest

/*The ovtest command performs another test of regression model specification. 
It performs a regression specification error test (RESET) for omitted variables. 
It creates new variables based on the predictors and refits the model using those new variables to see if any of them 
would be significant.*/

