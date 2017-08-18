
use /assets/courses/ME104/hiedata_short.dta

regress ghi sex age tinc weightkg diastol i.cig
test (2.cig=0) (3.cig=0)
reg ghi sex age tinc weightkg i.cig
test (2.cig=0) (3.cig=0)
reg ghi age tinc weightkg i.cig
test (2.cig=0) (3.cig=0)
reg ghi age tinc weightkg i.cig diastol
test (2.cig=0) (3.cig=0)



