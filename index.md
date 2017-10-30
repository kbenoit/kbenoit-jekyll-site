---
title: "Current Research"
path: ""
---



[Google Scholar Page](http://scholar.google.co.uk/citations?user=hp1p9TEAAAAJ "Kenneth Benoit's Google Scholar page")

Benoit, Kenneth, Kevin Munger, and Arthur Spirling. October 30, 2017.  "[Measuring and Explaining Political Sophistication Through Textual Complexity](http://www.nyu.edu/projects/spirling/documents/BMS_complex.pdf)."  London School of Economics and New York University manuscript.

{: .notice}
 The sophistication of political communication has been measured using
 "readability" scores developed from other contexts, but their application
 out of domain is problematic.  We systematically review the shortcomings of
 previous measures, before developing a new approach, with software, better suited to the  task.
 We use the crowd to perform thousands of pairwise comparisons of text
 snippets and incorporate these results into a statistical model of
 comprehension. We include previously excluded features such as parts of speech,
 and a measure of word rarity derived from term frequencies in the Google books dataset.
 Our technique not only shows which features are appropriate to the political
 domain and how, but also  provides a measure easily applied and rescaled to
 political texts in a way that facilitates comparison with reference to a
 meaningful baseline. We reassess patterns in US and UK political corpora to
 demonstrate how substantive conclusions differ when using our improved
 approach.

Patrick Perry and Kenneth Benoit.  October 26, 2017.  "[Scaling Text with the Class Affinity Model](http://arxiv.org/abs/1710.08963)."  London School of Economics and New York University manuscript.  

{: .notice}
  Probabilistic methods for classifying text form a rich tradition in machine
  learning and natural language processing.  For many important problems,
  however, class prediction is uninteresting because the class is known, and
  instead the focus shifts to estimating latent quantities related to the
  text, such as affect or ideology.  We focus on one such problem of interest,
  estimating the ideological positions of 55 Irish legislators in the 1991
  Dail confidence vote. To solve the Dail scaling problem and others
  like it, we develop a text modeling framework that allows actors to take
  latent positions on a "gray" spectrum between "black" and "white" polar
  opposites.  We are able to validate results from this model by measuring
  the influences exhibited by individual words, and we are able to quantify
  the uncertainty in the scaling estimates by using a sentence-level block
  bootstrap. Applying our method to the Dail debate, we are able to
  scale the legislators between extreme pro-government and pro-opposition in a
  way that reveals nuances in their speeches not captured by their votes or
  party affiliations.
  

Thomas Däubler and Kenneth Benoit. February 13, 2017\. “[Estimating Better Left-Right Positions Through Statistical Scaling of Manual Content Analysis]({{ site.baseurl}}pdfs/text_in_context_2017.pdf).”

{: .notice}
Borrowing from automated “text as data” approaches, we show how statistical scaling models can be applied to hand-coded content analysis to improve estimates of political parties’ left-right policy positions. We apply a Bayesian item-response theory (IRT) model to category counts from coded party manifestos, treating the categories as “items” and policy positions as a latent variable. This approach also produces direct estimates of how each policy category relates to left-right ideology, without having to decide these relationships in advance based on out of sample fitting, political theory, assertion, or guesswork. This approach not only prevents the misspecification endemic to a fixed-index approach, but also works well even with items that are not specifically designed to measure ideological positioning.

{% comment %}
this is a comment to make a blank commit and push for site regeneration
{% endcomment %}
<!-- CHECK WHICH VERSION OF REPO IS USED FOR SITE REGENERATION 12:10PM-->
