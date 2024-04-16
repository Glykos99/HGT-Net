#!/bin/bash
conda activate 

cat all.target | while read line; do
arr=($line)
outgroup=${arr[1]}
target=${arr[0]}

python test.py 1.output.trees/$target.tree $outgroup $target ancestor/$target.ancestor


done

