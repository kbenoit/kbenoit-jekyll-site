R version 2.12.2 (2011-02-25)
Copyright (C) 2011 The R Foundation for Statistical Computing
ISBN 3-900051-07-0
Platform: i386-apple-darwin9.8.0/i386 (32-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

[R.app GUI 1.36 (5691) i386-apple-darwin9.8.0]

[Workspace restored from /Users/kbenoit/.RData]
[History restored from /Users/kbenoit/.Rhistory]

> library(austin)
Loading required package: numDeriv
> data(iebudget2009)
> fix(iebudget2009)
> wf <- wordfish(wfm(iebudget2009))
> summary(wf)
Call:
	wordfish(wfm = wfm(iebudget2009))

Document Positions:
                  Estimate Std. Error    Lower   Upper
t06_kenny_fg        0.7679    0.02555  0.71779  0.8179
t05_cowen_ff       -1.8532    0.02283 -1.89796 -1.8085
t14_ocaolain_sf     0.1846    0.03704  0.11204  0.2572
t01_lenihan_ff     -1.8330    0.01997 -1.87218 -1.7939
t11_gormley_green  -1.1863    0.07927 -1.34169 -1.0310
t04_morgan_sf       0.1003    0.02871  0.04408  0.1566
t12_ryan_green     -0.2298    0.06418 -0.35563 -0.1040
t10_quinn_lab       1.0112    0.03756  0.93758  1.0848
t07_odonnell_fg     0.4567    0.04330  0.37184  0.5416
t09_higgins_lab     1.1012    0.03521  1.03223  1.1702
t03_burton_lab      1.1326    0.01521  1.10282  1.1625
t13_cuffe_green    -0.8336    0.07228 -0.97524 -0.6919
t08_gilmore_lab     0.6259    0.02854  0.56995  0.6818
t02_bruton_fg       0.5237    0.02969  0.46549  0.5819
> plot(wf)
> wf <- wordfish(wfm(iebudget2009), d=c(1,2))
> plot(wf)
> abline(v=0,col="red",lty="dashed")

> data(demanif.econ)
> fix(demanif.econ)
> wfsp <- wordfish(wfm(demanif.econ))
> plot(wfsp)
> objects(wfsp)
 [1] "alpha"    "beta"     "call"     "data"     "dir"      "docs"     "ll"       "psi"     
 [9] "se.theta" "sigma"    "theta"    "words"   
> plot(wfsp$psi, wfsp$beta)

> plot(wfsp$psi, wfsp$beta)
> plot(wfsp$beta, wfsp$psi)
> plot(wfsp$beta, wfsp$psi, type="n")
> text(wfsp$beta, wfsp$psi, wfsp$words)
> wfsp$words[1:100]
  [1] "und"            "die"            "der"            "fuer"           "in"            
  [6] "werden"         "wir"            "den"            "von"            "zu"            
 [11] "eine"           "ist"            "auf"            "des"            "das"           
 [16] "mit"            "im"             "ein"            "durch"          "nicht"         
 [21] "auch"           "muss"           "sind"           "wollen"         "zur"           
 [26] "bei"            "wird"           "muessen"        "sich"           "einer"         
 [31] "dem"            "dass"           "an"             "es"             "mehr"          
 [36] "als"            "sie"            "um"             "unternehmen"    "aus"           
 [41] "deutschland"    "einen"          "koennen"        "haben"          "neue"          
 [46] "vor"            "menschen"       "wie"            "nur"            "arbeitsplaetze"
 [51] "neuen"          "zum"            "ueber"          "hat"            "nach"          
 [56] "kann"           "so"             "sowie"          "arbeit"         "deshalb"       
 [61] "oder"           "einem"          "alle"           "damit"          "uns"           
 [66] "sein"           "soll"           "soziale"        "wirtschaft"     "diese"         
 [71] "prozent"        "sollen"         "sozialen"       "dafuer"         "foerderung"    
 [76] "dazu"           "aber"           "insbesondere"   "bis"            "wettbewerb"    
 [81] "entwicklung"    "allem"          "setzen"         "ihre"           "schaffen"      
 [86] "zukunft"        "am"             "zwischen"       "wieder"         "ziel"          
 [91] "noch"           "ohne"           "politik"        "dabei"          "wenn"          
 [96] "landwirtschaft" "foerdern"       "weiter"         "ab"             "dies"          
> plot(wfsp$beta, wfsp$psi, type="n")
> text(wfsp$beta, wfsp$psi, wfsp$words, col="gray60")
> plot(wf$beta, wf$psi)
> plot(abs(wf$beta), wf$psi)
