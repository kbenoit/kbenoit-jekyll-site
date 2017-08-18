/**
 **  Illustration for Lecture 4 of Anscombe dataset regressions
 **
 **/

insheet using /assets/courses/ME104/anscombe.csv
list, clean
format x1-y4 %4.2g
summarize, format
regress y1 x1, cformat(%4.2g)
regress y2 x2, cformat(%4.2g)
regress y3 x3, cformat(%4.2g)
regress y4 x4, cformat(%4.2g)

