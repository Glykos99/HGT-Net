library(ape)
library(phangorn)
tree=read.tree("trimmed.tree")
midponit_mytree <- ladderize (midpoint(tree))
write.tree (midponit_mytree, "trimmed.tree.midpoint.tree")

