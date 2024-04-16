#Step1

#A total of 292 collected algal genomes were set up as algal genome database.
diamond makedb --in 292.algae.pep --db algae

#For 299 genomes, Busco was used for completeness assessment, structural and functional annotation, and better assembled and annotated versions were retained.
source miniconda3/bin/activate miniconda3/envs/busco5
busco --offline -l eukaryota_odb10 -m protein -c 20 -i $file -o $file.busco

#Step2

#Use NR database and algae database to separately perform BLAST alignment and merge the alignment results.
diamond blastp --evalue  1e-5  -q $i -o $i.m8 -k 1000 --threads 5 -d nr.dmnd
diamond blastp --evalue  1e-5  -q $i -o $i.m8 -k 1000 --threads 5 -d algae.dmnd
less -S algae_out.m8 |perl -e 'my%t;while(<>){chomp;my@a=split /\t/,$_;$t{$a[1]}=$_;};open IN,"algae_db/alage.description.new";while(<IN>){chomp;my@a=split /\t/,$_,2;if(exists $t{$a[0]}){print "$t{$a[0]}\t$a[1]\n"}}' |awk -F'\t' '{print $1 "\t" $2 "\t" $12 "\t" $11 "\t" $3 "\t" $13}'|sed 's#_# #g' > match.nr
perl scripts/taxname_species.pl match.nr 2 > algae.anno.out 2> end.err
less -S first.1128.example.m8.filter.tax |sed 's#|#;#g' | awk -F'\t' '{print $1 "\t"$2 "\t" $3 "\t" $11 "\t" $12 "\t" $13 }' |awk -F'\t' '$6!="NA"' |awk -F'\t' '{print $1 "\t" $2 "\t" $2 "\t" $6 "\t" $4 "\t" $5 "\t" $3 }' > anno.nr

#Set the phylums of the classified algal species as INGROUP lineage, and outside it as OUTGROUP lineage.
cat anno.nr anno.algae |sort -t$'\t' -k1,1 -k6,6rn > sort.lst
less -S sort.lst |grep -v 'NA' | grep -v 'Bolidophyceae' |grep -v 'Haptophyta'|grep -v 'Euglenozoa' |grep -v 'Chlorophyta' |grep -v 'Cryptophyceae'  |grep -v 'Chrysophyceae' |grep -v 'Dinophyceae' |grep -v 'Streptophyta' |grep -v 'Bacillariophyta' |grep -v 'Pinguiophyceae' |grep -v 'Xanthophyceae' |grep -v 'Eustigmatophyceae' |grep -v 'Phaeophyceae' |grep -v 'Rhodophyta' |grep -v 'Pelagophyceae'|grep -v 'Bacillariophyta' |grep -v 'Synurophyceae' |grep -v 'Apicomplexa' |grep -v 'Oomycota' |grep -v 'Perkinsozoa' |grep -v 'Cercozoa' |grep -v 'Foraminifera' |grep -v 'Ciliophora' |grep -v 'Endomyxa' > 2.22.sort

#Alien Index analysis.
less -S 2.22.sort |sort -t$'\t' -uk1,1 |sed 's#;;#;#g' |sed 's#;;#;#g' |sed 's#;;#;#g' |sed 's#;#\t#g' |awk -F'\t' '{print $1 "^"$6 }' > 2.22.candidate
less -S 2.22.sort |awk 'BEGIN { id = ""; count = 0 } $1 != id { id = $1; count = 0 } { count++; if (count <= 50) print }' |sed 's#;;#;#g' |sed 's#;;#;#g' |sed 's#;;#;#g' |sed 's#;#\t#g' |awk -F'\t' '{print $1 "^"$6 }' |sort |uniq -c |awk '$1>40' > 2.22.count

#Step3

#Genomic contigs comprising ≥50% Non-eukaryotic genes were discarded as contamination.
/share/app/ncbi-blast-2.2.31+/bin/blastn -task megablast -query \$f -db /dellfsqd2/ST_OCEAN/USER/liliangwei/database/nt/20200204/nt -out \${f}.megablastout -outfmt 6 -num_threads 8
grep \"cellular organisms|Archaea\" ${2}.megablastout.filter.tax >Archaea.m8
grep \"cellular organisms|Bacteria\" ${2}.megablastout.filter.tax >Bacteria.m8
cat pollution.stat.xls |awk '{a=a+\$2;b=b+\$3;c=c+\$5}END{print \"$2\t\"a\"\t\"b\"\t\"b/a\"\t\"c\"\t\"c/a}' >>pollution_pct.xls
cat pollution.stat.xls  |grep -v \"^#\"|awk '\$4>50 || \$6>50{print \"$2\t\"\$0 }' >>$cwd/results/pollution_scaf.xls

python del_pollute.py $sps.filter $sps.pollute.lst $sps.del.pt

#Limite our analyses to those genes that resided in genomic contigs or scaffolds that were more than 100 kb.
python check_length.py $sps.fasta $sps.length

#Step4

#Select the top 1000 sequences aligned with NR database, and filter them so that there are no more than 12 species in the same phylum and no more than 5 species in the same genus.
python select_phylum.py

#Alignment, trimming,and ML tree.
mafft-7.407/bin/mafft --thread 6 --auto " $1" > "2""$1".aln.pep
trimal-1.4.1/source/trimal -in " $1 " -out "  "2" $1".trim.aln " "-automated1
iqtree -nt 6 -st AA -s "$1 " -m TEST -mrate G4 -keep-ident -bb 1000 -pre  $1

#ML tree was rooted by midpoint using R. 
Rscript midpoint.R
Rscript plot_tree.R

#Use Java package NestedIn to strictly filter the HGTs located between the OUTGROUP and INGROUP phyla of a phylogenetic tree.

java -jar Nested/NestedIn.jar --directory 08.mid --donor Eukaryota,Bacteria,Archaea --cutoff 85 -optional Chlorophyta,Rhodophyta,Streptophyta,Bacillariophyta,Haptophyta,Alveolata,Ochrophyta,Chrysophyceae,Cryptophyceae,Dinophyceae,Eustigmatophyceae,Pelagophyceae,Pinguiophyceae,Xanthophyceae,Phaeophyceae --ssnode 2 --thread 800 --output 1.output

#Step5

#Write a Python script to determine whether the best alignment OUTGROUP gene and the candidate HGT gene have the most recent common ancestor (MRC).

sh script/search_for_ancestor.sh

#Divide the direction of HGTs transfer.

#Step6

#6,418 genes were used as seeds, compared in all 169 algae genomes, and then clustered using MCL software

diamond blastp --evalue  1e-5  --threads 20 --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore salltitles -d all.pep.dmnd -q all.pep -o all.pep.m8 --max-target-seqs 0 --more-sensitive -b 2 --masking none

cat $cwd/*m8 |perl -e 'open Len,"all.pep.length";
while(<Len>){chomp;@a=split /\s+/,$_;$b{$a[1]}=$a[0];}
while(<>){chomp;
        @c=split /\s+/,$_;
        $len=($b{$c[0]}>$b{$c[1]})?$b{$c[1]}:$b{$c[0]};
        if($c[3]>0.5*$len){
                print "$_\n";
        }
}' >all_all.m8.filter
cat all_all.m8.filter |awk -F'\t' '$3>="50"' |cut -f1,2,11 >all_all.abc

source miniconda3/bin/activate

miniconda3/bin/mcxload -abc all_all.abc --stream-mirror --stream-neg-log10 -stream-tf 'ceil(200)' -o all_all.mci -write-tab all_all.tab
miniconda3/bin/mcl all_all.mci -I 1.5
miniconda3/bin/mcxdump -icl out.all_all.mci.I15 -tabr all_all.tab -o dump.all_all.mci.I15

#Gene families with 3 and more than 3 seed numbers are retained.

python count_OG.py sps.ls OG.list OG_species.matrix

#Perform statistics and screening on the clustering results, if more than half of the classes of a phylum have species genes appearing in this OG, it is defined as a common HGT event of this phylum

less -S OG_species.matrix |awk 'NR>1{sum=0; for(i=2;i<=NF;i++) if($i!=0) sum++; print $1 "\t"sum}' > count.og

less -S count.og |awk '$2!=0'|awk '{print $1 "\t" 1 }' > $class.lst
mafft-7.407/bin/mafft --auto new.add.pep > new.add.pep.msa
trimal-1.4.1/source/trimal -in new.add.pep.msa -out new.add.trimmed.msa -gt 0.2
miniconda3/bin/fasttree new.add.trimmed.msa > new.add.trimmed.msa.tree

