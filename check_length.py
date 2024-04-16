#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys,getopt
fa =sys.argv[1]
#output =sys.argv[2]
hgt =sys.argv[2]
#建立字典
scaff_dict={}
scaff_list={}
with open(sys.argv[1])as a :
    for i in a:
            a1 = i.strip()
#区分以>开头的序列。
            if i.startswith('>'):
                    name=a1.split(' ')[0][1:]
                    scaff_list[name]=[]
                    continue
            scaff_list[name].append(a1)

for i in scaff_list.keys():
        scaff_dict[i]=''.join(scaff_list[i])
#计算总长度和有效长度
#l = 0
#t_length = 0
#e_length = 0
total_N=0
total_A=0
total_T=0
total_C=0
total_G=0
total_length={}
e_length={}
#for i in scaff_dict.keys():
#    l = len(scaff_dict[i])
#    total_length[i] = l
#    total_A = scaff_dict[i].count('A')
#    total_T = scaff_dict[i].count('T')
#    total_C = scaff_dict[i].count('C')
#    total_G = scaff_dict[i].count('G')
#    total_N = scaff_dict[i].count('N')
#    e_length[i]  = l - total_N
f1=open('length_count.lst','w')
#f2=open('del_length_count.lst','w')
#     list1=['Name''\t''total_length''\t''e_length''\n']
#f2.write('Name''\t''total_hgt''\t''out_group_hgt''\t''percentage''\t''scaffold_name''\t''total_length''\t''e_length''\n')
f1.write('Name''\t''total_hgt''\t''out_group_hgt''\t''percentage''\t''scaffold_name''\t''total_length''\t''e_length''\n')
with open(sys.argv[2])as b :
     for line in b:
         line = line.strip().split('\t')
         name = line[4]
         t_length = total_length[name]
         ef_length = e_length[name]
         if ef_length > 100000 :
                    f1.writelines(str(line[0])+'\t'+str(line[1])+'\t'+str(line[2])+'\t'+str(line[3])+'\t'+str(name)+'\t'+str(t_length)+'\t'+str(ef_length)+'\n')
         else :
              f2.writelines(str(line[0])+'\t'+str(line[1])+'\t'+str(line[2])+'\t'+str(line[3])+'\t'+str(name)+'\t'+str(t_length)+'\t'+str(ef_length)+'\n')

#with open('length_count.lst','w')as fl:
#     list1=['Name''\t''total_length''\t''e_length''\n']
#     fl.writelines(list1)
#     for key in scaff_dict.keys():
#         fl.writelines(key+'\t'+str(total_length[key])+'\t'+str(e_length[key])+'\n')
