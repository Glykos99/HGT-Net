library(ggplot2)
library(ggtree)
pdf("trimmed.tree.pdf",h=10,w=10)
tree=read.tree("trimmed.tree.midpoint.tree") 
tax <- read.table("tax.lst", row.names=1,sep="\t")
colnames(tax) = c("phy")
groupInfo <- split(row.names(tax), tax$phy) 
tree <- groupOTU(tree, groupInfo) ## 
ggtree(tree, layout="rectangular", size=0.8,aes(color=group))+
#ggtree(tree, layout="daylight", size=0.8,aes(color=group))+
  geom_tiplab(size=2)
dev.off()
