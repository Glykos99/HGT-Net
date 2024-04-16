#ete3="/home/hankai/bin/ete3"
# -*- coding: utf-8 -*-
import sys
#from ete3 import Tree
#import ete3
#ete3.path.append("/home/hankai/bin/ete3")
from ete3 import Tree

#tree = (sys.argv[1], 'r')
args = sys.argv
t = Tree(args[1])
outgroup = (args[2])
target = (args[3])
#(sys.argv[1], 'r')
#print(t)
#print(t.get_tree_root())
#print(t.up)

node = t.search_nodes(name=target)[0]
#print(node.is_leaf())
#print(node.up)
#print(node.get_tree_root())
#ancestor = t.get_common_ancestor("Eukaryota-Dinophyceae-7529447265", "s1_g1975.t1-Symbiodinium_sp_clade_C_Y103")
#print(ancestor.up.is_leaf())
common = t.get_common_ancestor(outgroup,target)
common2 = common.up
f1=open(args[4],'w')
for leaf in common2:
#    if leaf.name != "Eukaryota-Dinophyceae-7529447265" or "s1_g1975.t1-Symbiodinium_sp_clade_C_Y103" :
    if leaf.name not in common :
#       print(leaf.name)
       f1.writelines(target +'\t'+ outgroup +'\t' + leaf.name + '\n')

#print(common2)
#h = get_leaf_names(common)
#node2 = ancestor.up
#print(node2.name)
#print(h)

