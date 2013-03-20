modular_tools_data_struct_tree
==============================

@author ek.vandalen

how to commit
=============

What should I include in my commit message?
The three basic things to include are a summary or title, 
a detailed description, and a tracking or ticket number, 
if it's applicable. Here is a sample git commit with all 
that information:

Fixed bug where user can't signup.

Users were unable to register if they hadn't visited the plans
and pricing page because we expected that tracking
information to exist for the logs we create after a user
signs up.  I fixed this by adding a check to the logger
to ensure that if that information was not available
we weren't trying to write it.

[Fixes #2873942]

about this package
==================

Big thanks to https://github.com/vadimg/js_bintrees & friends.

This translation and extension of https://github.com/vadimg/js_bintrees (javascript) is also released under MIT license.

This Actionscript 3 implementation also has: overridable recalculations on rotations. It can thus support subtree size (re)calculation but by overriding also other information about children.

Thus the RbTree was extended with AugIntTree (augmented interval tree) according to the MIT open course ware "introduction to algorithms" lesson 10.

AugIntTree was extended with SymIntTree (symmetrical interval tree) for faster multiple-interval and multiple-overlap retrieval.

roadmap:
========

A repository test_modular_tools_data_struct_tree will be added in the near future.

Suggested improvements:
=======================

If you want to retrieve multiple overlapping intervals, and if you have a multitude of relatively long intervals so that a lot of dead-end retrieval iterations are made, then consider expanding with a nested containment list approach. In this aspect, you could make nested trees. This will keep the larger intervals appear to the algorithm first, so the dead ends can be identified as early as possible. It will also give you a possibly very unbalanced tree, adding extra iterations to every operation.... then you have to follow the original nested containment list implementation which I believe is best.
