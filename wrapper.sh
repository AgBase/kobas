#!/bin/bash
##SET UP OPTIONS

while getopts ab:c:C:d:e:f:ghi:jk:l:m:n:o:p:q:r:s:S:t:T:v:x:y:z option
do
        case "${option}"
        in

                a) anno=true ;;
                b) bgfile=${OPTARG};;
                c) cutoff=${OPTARG};;
		C) coverage=${OPTARG};;
                d) databases=${OPTARG};;
                f) fgfile=${OPTARG};;
                e) eval=${OPTARG};;
                g) ident=true;;
		h) help=true;;
		i) infile=${OPTARG};;
		j) annoident=true;;
		k) kobashome=${OPTARG};;
		l) list=${OPTARG};;
                m) method=${OPTARG};;
		n) fdr=${OPTARG};;
                o) out=${OPTARG};;
		p) blastp=${OPTARG};;
		q) kobasdb=${OPTARG};;
		r) rank=${OPTARG};;
                s) species=${OPTARG};;
		S) inspecies=${OPTARG};;
                t) intype=${OPTARG};;
		T) threads=${OPTARG};;
                v) blasthome=${OPTARG};;
                x) blastx=${OPTARG};;
                y) blastdb=${OPTARG};;
                z) ortholog=${OPTARG};;
        esac
done
#####################################################################################################
if [[ "$help" = "true" ]] ; then
  echo "Options:
    [-h prints this help statement]

    [-a runs KOBAS annotate]
    KOBAS annotate options:
	-i INFILE can be FASTA or one-per-lineidentifiers. See -t intype for details.
	-s SPECIES 3 or 4 letter species abbreviation (can be found here: ftp://ftp.cbi.pku.edu.cn/pub/KOBAS_3.0_DOWNLOAD/species_abbr.txt or here: https://www.kegg.jp/kegg/catalog/org_list.html)
	-o OUTPUT file (Default is stdout.)
    	[-l LIST available species, or list available databases for a specific species]
	[-t INTYPE (fasta:pro, fasta:nuc, blastout:xml, blastout:tab, id:ncbigi, id:uniprot, id:ensembl, id:ncbigene), default fasta:pro]
	[-e EVALUE expect threshold for BLAST, default 1e-5]
	[-r RANK rank cutoff for valid hits from BLAST result, default is 5]
	[-C COVERAGE subject coverage cutoff for BLAST, default 0]
	[-z ORTHOLOG whether only use orthologs for cross-species annotation or not, default NO (if only using orthologs, please provide the species abbreviation of your input)]
	[-k KOBAS HOME The path to kobas_home, which is the parent directory of sqlite3/ and seq_pep/. This is the absolute path in the container.]
	[-v BLAST HOME The path to blast_home, which is the parent directory of blastx and blastp. This is the absolute path in the container.]
	[-y BLASTDB The path to seq_pep/. This is the absolute path in the container.]
	[-q KOBASDB The path to sqlite3/, This is the absolute path in the container.]
	[-p BLASTP The path to blastp. This is the absolute path in the container.]
	[-x BLASTX The path to blastx. This is the absolute path in the container.]
	[-T number of THREADS to use in BLAST search. Default = 8]

    [-g runs KOBAS identify]
	KOBAS identify options:
	-f FGFILE foreground file, the output of annotate
	-b BGFILE background file, species abbreviation, see this list for species codes: https://www.kegg.jp/kegg/catalog/org_list.html
        -o OUTPUT file (Default is stdout.)
	[-d DB databases for selection, 1-letter abbreviation separated by "/": K for KEGG PATHWAY, n for PID, b for BioCarta, R for Reactome, B for BioCyc, p for PANTHER,
               o for OMIM, k for KEGG DISEASE, f for FunDO, g for GAD, N for NHGRI GWAS Catalog and G for Gene Ontology, default K/n/b/R/B/p/o/k/f/g/N/]
	[-m METHOD choose statistical test method: b for binomial test, c for chi-square test, h for hypergeometric test / Fisher's exact test, and x for frequency list, 
	       default hypergeometric test / Fisher's exact test
	[-n FDR choose false discovery rate (FDR) correction method: BH for Benjamini and Hochberg, BY for Benjamini and Yekutieli, QVALUE, and None, default BH
        [-c CUTOFF terms with less than cutoff number of genes are not used for statistical tests, default 5]
        [-k KOBAS HOME The path to kobas_home, which is the parent directory of sqlite3/ and seq_pep/. This is the absolute path in the container.]
        [-v BLAST HOME The path to blast_home, which is the parent directory of blastx and blastp. This is the absolute path in the container.]
        [-y BLASTDB The path to seq_pep/. This is the absolute path in the container.]
        [-q KOBASDB The path to sqlite3/. This is the absolute path in the container.]
        [-p BLASTP The path to blastp. This is the absolute path in the container.]
        [-x BLASTX The path to blastx. This is the absolute path in the container.]
 
    [-j runs both KOBAS annotate and identify]"
fi


ARGS=''
BLARGS=''

#SO THAT THIS CONTAINER CAN BE USED BOTH IN CLI AND DE I SET KOBASHOME, KOBASDB AND BLASTDB TO THE WORKING-DIR AND THEN PEOPLE CAN OPTIONALLY OVERRIDE IN CLI
if [[ "$anno" = "true" ]]
then 
    test -f sqlite3.tar && tar -xf sqlite3.tar  sqlite3/$species'.db.gz' && tar -xf sqlite3.tar sqlite3/organism.db.gz
    test -f sqlite3/$species'.db.gz' && gunzip sqlite3/$species'.db.gz'
    test -f sqlite3/organism.db.gz && gunzip sqlite3/organism.db.gz
    if [ -n "${coverage}" ]; then ARGS="$ARGS -C $coverage"; fi
    if [ -n "${kobashome}" ]; then ARGS="$ARGS -k $kobashome"; fi 
    if [ -n "${fdr}" ]; then ARGS="$ARGS -n $fdr"; fi
    if [ -n "${out}" ]; then ARGS="$ARGS -o $out"; fi
    if [ -n "${blastp}" ]; then ARGS="$ARGS -p $blastp"; fi 
    if [ -n "${kobasdb}" ]; then ARGS="$ARGS -q $kobasdb"; fi 
    if [ -n "${rank}" ]; then ARGS="$ARGS -r $rank"; fi
    if [ -n "${blasthome}" ]; then ARGS="$ARGS -v $blasthome"; fi 
    if [ -n "${blastx}" ]; then ARGS="$ARGS -x $blastx"; fi 
    if [ -n "${blastdb}" ]; then ARGS="$ARGS -y $blastdb"; fi
    if [ -n "${ortholog}" ]; then ARGS="$ARGS -z $ortholog"; fi
    if [ -n "${eval}" ]; then BLARGS="$BLARGS -evalue $eval"; else BLARGS="$BLARGS -evalue 1e-05"; fi
    if [ -n "${threads}" ]; then BLARGS="$BLARGS -num_threads $threads"; else BLARGS="$BLARGS -num_threads 8"; fi
    if [[ "$intype" = "fasta:pro" ]] 
    then 
	test -f seq_pep.tar && tar -xf seq_pep.tar seq_pep/$species'.pep.fasta.gz'
	test -f seq_pep/$species'.pep.fasta.gz' && gunzip seq_pep/$species'.pep.fasta.gz'
        makeblastdb -in seq_pep/$species'.pep.fasta'  -parse_seqids -dbtype prot -out seq_pep/$species'.pep.fasta'
        blastp -query $infile -db seq_pep/$species'.pep.fasta' -out $species.tsv -outfmt 6 $BLARGS
	kobas-annotate  -i $species.tsv -t blastout:tab -s $species -o $out $ARGS
    elif [[ "$intype" = "fasta:nuc" ]]
    then
        test -f seq_pep.tar && tar -xf seq_pep.tar seq_pep/$species'.pep.fasta.gz'
	test -f seq_pep/$species'.pep.fasta.gz' && gunzip seq_pep/$species'.pep.fasta.gz'
        makeblastdb -in seq_pep/$species'.pep.fasta'  -parse_seqids -dbtype prot -out seq_pep/$species'.pep.fasta'
        blastx -query $infile -db seq_pep/$species'.pep.fasta' -out $species.tsv -outfmt 6 $BLARGS
	kobas-annotate -i $species.tsv -t blastout:tab -s $species -o $out $ARGS
    else
        kobas-annotate -i $infile -t $intype  -s $species -o $out  $ARGS
    fi
    sed -ni '/\#\#/,$p' $out
fi

if [[ "$ident" = "true" ]]
then
    test -f sqlite3.tar && tar -xf sqlite3.tar  sqlite3/$bgfile'.db.gz' && tar -xf sqlite3.tar sqlite3/organism.db.gz
    test -f sqlite3/$bgfile'.db.gz' && gunzip sqlite3/$bgfile'.db.gz'
    test -f sqlite3/organism.db.gz && gunzip sqlite3/organism.db.gz

    if [ -n "${cutoff}" ]; then ARGS="$ARGS -c $cutoff"; fi
    if [ -n "${databases}" ]; then ARGS="$ARGS -d $databases"; fi
    if [ -n "${kobashome}" ]; then ARGS="$ARGS -k $kobashome"; fi
    if [ -n "${method}" ]; then ARGS="$ARGS -m $method"; fi
    if [ -n "${fdr}" ]; then ARGS="$ARGS -n $fdr"; fi
    if [ -n "${blastp}" ]; then ARGS="$ARGS -p $blastp"; fi
    if [ -n "${kobasdb}" ]; then ARGS="$ARGS -q $kobasdb"; fi
    if [ -n "${blasthome}" ]; then ARGS="$ARGS -v $blasthome"; fi
    if [ -n "${blastx}" ]; then ARGS="$ARGS -x $blastx"; fi 
    if [ -n "${blastdb}" ]; then ARGS="$ARGS -y $blastdb"; fi

     kobas-identify -f $fgfile -b $bgfile -o $out $ARGS
fi


if [[ "$annoident" = "true" ]]
then
    test -f sqlite3.tar && tar -xf sqlite3.tar  sqlite3/$species'.db.gz' && tar -xf sqlite3.tar sqlite3/organism.db.gz
    test -f sqlite3/$species'.db.gz' && gunzip sqlite3/$species'.db.gz'
    test -f sqlite3/organism.db.gz && gunzip sqlite3/organism.db.gz
    if [ -n "${coverage}" ]; then ARGS="$ARGS -C $coverage"; fi
    if [ -n "${kobashome}" ]; then ARGS="$ARGS -k $kobashome"; fi
    if [ -n "${fdr}" ]; then ARGS="$ARGS -n $fdr"; fi
    if [ -n "${out}" ]; then ARGS="$ARGS -o $out"; fi
    if [ -n "${blastp}" ]; then ARGS="$ARGS -p $blastp"; fi
    if [ -n "${kobasdb}" ]; then ARGS="$ARGS -q $kobasdb"; fi
    if [ -n "${rank}" ]; then ARGS="$ARGS -r $rank"; fi
    if [ -n "${blasthome}" ]; then ARGS="$ARGS -v $blasthome"; fi
    if [ -n "${blastx}" ]; then ARGS="$ARGS -x $blastx"; fi
    if [ -n "${blastdb}" ]; then ARGS="$ARGS -y $blastdb"; fi
    if [ -n "${ortholog}" ]; then ARGS="$ARGS -z $ortholog"; fi
    if [ -n "${eval}" ]; then BLARGS="$BLARGS -evalue $eval"; else BLARGS="$BLARGS -evalue 1e-05"; fi
    if [ -n "${threads}" ]; then BLARGS="$BLARGS -num_threads $threads"; else BLARGS="$BLARGS -num_threads 8"; fi
    if [[ "$intype" = "fasta:pro" ]]
    then
        test -f seq_pep.tar && tar -xf seq_pep.tar seq_pep/$species'.pep.fasta.gz'
        test -f seq_pep/$species'.pep.fasta.gz' && gunzip seq_pep/$species'.pep.fasta.gz'
        makeblastdb -in seq_pep/$species'.pep.fasta'  -parse_seqids -dbtype prot -out seq_pep/$species'.pep.fasta'
        blastp -query $infile -db seq_pep/$species'.pep.fasta' -out $species.tsv -outfmt 6 $BLARGS
        kobas-annotate  -i $species.tsv -t blastout:tab -s $species -o $out'_annotate.txt' $ARGS
    elif [[ "$intype" = "fasta:nuc" ]]
    then
        test -f seq_pep.tar && tar -xf seq_pep.tar seq_pep/$species'.pep.fasta.gz'
        test -f seq_pep/$species'.pep.fasta.gz' && gunzip seq_pep/$species'.pep.fasta.gz'
        makeblastdb -in seq_pep/$species'.pep.fasta'  -parse_seqids -dbtype prot -out seq_pep/$species'.pep.fasta'
        blastx -query $infile -db seq_pep/$species'.pep.fasta' -out $species.tsv -outfmt 6 $BLARGS
        kobas-annotate -i $species.tsv -t blastout:tab -s $species -o $out'_annotate.txt' $ARGS
    else
        kobas-annotate -i $infile -t $intype  -s $species -o $out'_annotate.txt'  $ARGS
    fi

    ARGS=''
    fgfile=$out

    if [ -n "${cutoff}" ]; then ARGS="$ARGS -c $cutoff"; fi
    if [ -n "${databases}" ]; then ARGS="$ARGS -d $databases"; fi
    if [ -n "${bgfile}" ]; then ARGS="$ARGS -b $bgfile"; fi
    if [ -n "${method}" ]; then ARGS="$ARGS -m $method"; fi
    if [ -n "${kobashome}" ]; then ARGS="$ARGS -k $kobashome"; fi
    if [ -n "${blastp}" ]; then ARGS="$ARGS -p $blastp"; fi
    if [ -n "${kobasdb}" ]; then ARGS="$ARGS -q $kobasdb"; fi
    if [ -n "${blasthome}" ]; then ARGS="$ARGS -v $blasthome"; fi
    if [ -n "${blastx}" ]; then ARGS="$ARGS -x $blastx"; fi
    if [ -n "${blastdb}" ]; then ARGS="$ARGS -y $blastdb"; fi

    kobas-identify -f $fgfile -o $out'_identify.txt' $ARGS

fi
