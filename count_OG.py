# -*- coding: utf-8 -*-

import argparse
import os

parser = argparse.ArgumentParser(description='统计文件1中每个ID在文件2的每个列表中出现的次数')
parser.add_argument('file1', metavar='file1', help='文件1路径')
parser.add_argument('file2', metavar='file2', help='文件2路径')
parser.add_argument('output', metavar='output', help='输出结果文件路径')
args = parser.parse_args()

# 统计每个ID在每个列表中出现的次数
results = {}
with open(args.file2, 'r') as f:
    for line in f:
        lst_file = line.strip()
        with open(lst_file, 'r') as f:
            lst = [l.strip().split('-')[0] for l in f.readlines()]
#            print(lst) 
        list_name = lst_file.strip().split('/')[-2] # 取文件名中倒数第一个 '-' 之后的字符串作为列表名称
#        print(list_name)
        for id in lst:
            if list_name not in results:
                results[list_name] = {}
            if id not in results[list_name]:
                results[list_name][id] = 0
            results[list_name][id] += 1
#            print(results)

# 输出矩阵
with open(args.file1, 'r') as f:
#    header = f.readline().strip().split()
#    ids = header[1:]
    data = {}
    id_list = []
    for line in f:
        fields = line.strip().split()
        id = fields
#        id_list.append(id)
        id_list.append('\t'.join(id))
#        data[id] = [int(x) for x in fields[1:]]
#print (id_list)
with open(args.output, 'w') as f:
    # 输出文件1的ID
    f.write('\t' + '\t'.join(id_list) + '\n')
#    print (id_list)
    # 输出结果矩阵
    for list_name in results:
        row = [list_name] + [results[list_name][id] if id in results[list_name] else 0 for id in id_list]
        f.write('\t'.join(str(x) for x in row) + '\n')

