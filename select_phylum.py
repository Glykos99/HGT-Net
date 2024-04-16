#!/usr/bin/python
# -*- coding: utf-8 -*-
#每个基因取1000最佳比对
import sys

f1=open('new.selec.lst','w')
class_data={}
phyla=[]
gena=[]
spela=[]
alga=[]
with open ('new.sort','r') as f:
     for line in f:
         try :
             column = line.split('\t')
             algae_id=column[0]
             lineage=column[3]
#             alga.append(algae_id)
#         bitscore=column[4] 
             taxon = lineage.split(';')
#         print (taxon)
             phylum=taxon[2],column[0]
#         print (phylum)
             genus=taxon[6],column[0]
             species=taxon[7],column[0]
#             phyla.append(phylum)
#             gena.append(genus)
#             spela.append(species)
             if  algae_id not in alga :
                 alga.append(algae_id)
                 gena.clear() 
                 phyla.clear()  
                 spela.clear()
      
                 spela.append(species)             
                 phyla.append(phylum)
                 gena.append(genus)
#                     alga.append(algae_id)
                 f1.writelines(line)
#                 spela.append(species)
#             print(phyla.count(phylum))
#             print(str(phylum))
                 
#                 else :
#                     f1.writelines(line)
#                     phyla.append(phylum)
#                     gena.append(genus)                     
#                     alga.append(algae_id)
             else :
                  if  phyla.count(phylum) < 12 and gena.count(genus) < 3 and spela.count(species) < 1:   
#                      phyla.append(phylum)
#a                      gena.append(genus)
#                      f1.writelines(line)
#                  else :
                      phyla.append(phylum)
                      gena.append(genus)
                      spela.append(species)          
                      f1.writelines(line)
         except :
             continue                  
#i        if e_id not in class_data.keys():
#           class_data[algae_id] = column
#        else: 
  
#print (class_data.keys())
           





#with open(sys.argv[1])as f:
#    for i in f:
#        f1 = i.replace('\n','')
#        column = f1.split(';')
#        kingdom=column[1]
#        phylum=column[2]
#        genus=column[6]
#        species=column[7]

