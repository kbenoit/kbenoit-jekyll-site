---
id: 1383
title: How to install the R package topicmodels on OS X
date: 2014-12-02T20:10:21+00:00
author: Ken
layout: single
guid: http://www.kenbenoit.net/?p=1383
permalink: /posts/how-to-install-the-r-package-topicmodels-on-os-x/
categories:
  - Uncategorized
---
Many people have reported problems when attempting to install the R package \`topicmodels\` on R when using OS X Mavericks or Yosemite. The problem is that the binaries are not yet built for these versions of OS X, and you need additional software installed in order to build the source. Once you have built the package from source, however, it seems to work fine.

Here is the solution that worked for me:

1. Install the free [XCode](https://macappsto.re/gb/Bk9QD.m) from the App Store. After installation, you need to open the application XCode from the Applications folder, so that it can install the needed components.
2. You need the gsl ([Gnu Scientific Library](http://www.gnu.org/software/gsl/)) installed. One way is to get the latest version from  [ftp://ftp.gnu.org/gnu/gsl/](ftp://ftp.gnu.org/gnu/gsl/" rel="nofollow). A **better solution** (in my opinion) is to install using [homebrew](http://brew.sh/). From Terminal, type:

        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
Then install gsl using:

        brew install gsl

3. Now, from R, try

        install.packages("modeltools")   # a dependency of topicmodels
        install.packages("topicmodels", type="source")  # should compile from source

  If for some reason the second command fails, then try

        install.packages("http://cran.r-project.org/src/contrib/topicmodels_0.2-1.tar.gz", repos=NULL, type="source")
