

use /assets/courses/ME104/weede.dta
poisson ssal6080 fh73 lpopln70 lmilwp70


use http://www.stata-press.com/data/r11/dollhill3, clear
list
poisson deaths smokes i.agecat
poisson deaths smokes i.agecat, exposure(pyears)
poisson, irr
estat gof

nbreg deaths smokes i.agecat, exposure(pyears)
nbreg, irr
