/*****  MLM May 2011 Course - Ken Benoit
 *****  Homework 1
 *****  Answers
 *****/

/***** 1a ******/
use /assets/courses/mlm/PPMD_summary_day1.dta, clear
desc
browse

/***** 1b ******/
table Dimension Scale, c(mean Mean)

/***** 1c ******/
reshape wide Mean, i(Country Party Scale) j(Dimension)

/***** 1d ******/
use /assets/courses/mlm/PPMD_summary_day1.dta, clear
reshape wide Mean, i(Country Party Dimension) j(Scale)
graph twoway (qfitci Mean1 Mean2) (scatter Mean1 Mean2, msize(tiny)), legend(off) xtitle(Position) ytitle(Importance)

/***** 2a ******/
use http://www.stata-press.com/data/mlmus2/pefr, clear
reshape long wp wm, i(id) j(occasion)

/***** 2b ******/
reshape long w, i(id occasion) j(measurement) string
