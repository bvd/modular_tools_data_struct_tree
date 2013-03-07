modular_tools_data_struct_tree
==============================

@author ek.vandalen

based on https://github.com/vadimg/js_bintrees

added subtree size and overridable recalculations on rotations.

then extended red black tree with augmented interval tree according to the MIT open course ware "introduction to algorithms" lesson 10 (about interval trees)

then extended the AugIntTree with a SymIntTree (symmetrical interval tree) for faster multiple-interval and multiple-overlap retrieval.

advise for the future, if you want to retrieve multiple overlapping intervals, and if you have a multitude of relatively long intervals so that a lot of dead-end retrieval iterations are made, then consider expanding with a nested containment list approach. In this aspect, you could make nested trees. This will keep the larger intervals appear to the algorithm first, so the dead ends can be identified as early as possible. It will also give you a possibly very unbalanced tree, adding extra iterations to every operation.... then you have to follow the original nested containment list implementation which I believe is best.
