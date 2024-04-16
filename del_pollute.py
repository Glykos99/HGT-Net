#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys,getopt
fa =sys.argv[1]
#output =sys.argv[2]
hgt =sys.argv[2]
f1=open(sys.argv[3],'w')
with open(sys.argv[2])as b :
     for line in b:
         line1 = line.strip().split('\t')
         name = line1[0]
#          = line1[0]
         with open(sys.argv[1])as a :
              for i in a:
                  line2 = i.strip().split('\t')
                  sc_id = line2[1]
                  if name == sc_id :
                     f1.writelines(str(line2[0])+'\t'+str(line2[1])+str(line2[2])+'\t'+str(line2[3])+'\t'+str(line2[4])+'\t'+'\t'+str(line1[1])+'\t'+str(line1[2])+'\t'+str(line1[3])+'\t'+str(line1[4])+'\t'+str(line1[5])+'\n')















