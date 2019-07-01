#!/bin/bash
##SET UP OPTIONS

while getopts ab:c:C:d:e:f:ghi:k:l:m:n:o:p:q:r:s:t:v:x:y:z option
do
        case "${option}"
        in

                a) ;;
                b) bgfile=${OPTARG};;
                c) cutoff=${OPTARG};;
		C) coverage=${OPTARG};;
                d) databases=${OPTARG};;
                f) fgfile=${OPTARG};;
                e) eval=${OPTARG};;
                g) ;;
		h) ;;
		i) infile=${OPTARG};;
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
                v) blasthome=${OPTARG};;
                x) blastx=${OPTARG};;
                y) blastdb=${OPTARG};;
                z) ortholog=${OPTARG};;
        esac
done
#####################################################################################################
if [ "$1" == "-h" ]; then
  echo "Options:
    [-h prints this help statement]
    [-a runs KOBAS annotate]
    KOBAS annotate options:
	-i infile (can be FASTA or one-per-lineidentifiers. See -t intype for details.
	-s species (3 or 4 letter species abbreviation. Can be found here: ftp://ftp.cbi.pku.edu.cn/pub/KOBAS_3.0_DOWNLOAD/species_abbr.txt)
    	[-l list available species, or list available databases for a specific species]
	[-t INTYPE (fasta:pro, fasta:nuc, blastout:xml, blastout:tab, id:ncbigi, id:uniprot, id:ensembl, id:ncbigene), default fasta:pro]
	[-o OUTPUT file (Default is stdout.)]
	[-e EVALUE expect threshold for BLAST, default 1e-5]
	[-r RANK rank cutoff for valid hits from BLAST result, default is 5]
	[-n NCPUS number of CPUs to be used by BLAST, default 1]
	[-C COVERAGE subject coverage cutoff for BLAST, default 0]
	[-z ORTHOLOG whether only use orthologs for cross-species annotation or not, default NO (if only using orthologs, please provide the species abbreviation of your input)]
	[-k KOBAS HOME The path to kobas_home, which is the parent directory of sqlite3/ and seq_pep/]
	[-v BLAST HOME The path to blast_home, which is the parent directory of blastx and blastp.]
	[-y BLASTDB The path to seq_pep/]
	[-q KOBASDB The path to sqlite3/]
	[-p BLASTP The path to blastp]
	[-x BLASTX The path to blastx]

    [-g runs KOBAS identify]
	KOBAS identify options:
	-f FGFILE foreground file, the output of annotate
	[-b BGFILE background file, the output of annotate (3 or 4-letter file name is not allowed), or species abbreviation, default same species as annotate]
	[-d DB databases for selection, 1-letter abbreviation separated by "/": K for KEGG PATHWAY, n for PID, b for BioCarta, R for Reactome, B for BioCyc, p for PANTHER,
               o for OMIM, k for KEGG DISEASE, f for FunDO, g for GAD, N for NHGRI GWAS Catalog and G for Gene Ontology, default K/n/b/R/B/p/o/k/f/g/N/]
	[-m METHOD choose statistical test method: b for binomial test, c for chi-square test, h for hypergeometric test / Fisher's exact test, and x for frequency list, 
		   default hypergeometric test / Fisher's exact test
	[-n FDR choose false discovery rate (FDR) correction method: BH for Benjamini and Hochberg, BY for Benjamini and Yekutieli, QVALUE, and None, default BH
        [-o OUTPUT file (Default is stdout.)]
        [-c CUTOFF terms with less than cutoff number of genes are not used for statistical tests, default 5]
        [-k KOBAS HOME The path to kobas_home, which is the parent directory of sqlite3/ and seq_pep/]
        [-v BLAST HOME The path to blast_home, which is the parent directory of blastx and blastp.]
        [-y BLASTDB The path to seq_pep/]
        [-q KOBASDB The path to sqlite3/]
        [-p BLASTP The path to blastp]
        [-x BLASTX The path to blastx]
 
    [-ag runs both KOBAS annotate and identify]
	KOBAS-run options:
	-f FGFILE foreground file, the output of annotate
	-i infile (can be FASTA or one-per-lineidentifiers. See -t intype for details.
        -s species (3 or 4 letter species abbreviation. Can be found here: ftp://ftp.cbi.pku.edu.cn/pub/KOBAS_3.0_DOWNLOAD/species_abbr.txt)
        [-l list available species, or list available databases for a specific species]
        [-t INTYPE (fasta:pro, fasta:nuc, blastout:xml, blastout:tab, id:ncbigi, id:uniprot, id:ensembl, id:ncbigene), default fasta:pro]
        [-o OUTPUT file (Default is stdout.)]
        [-e EVALUE expect threshold for BLAST, default 1e-5]
        [-r RANK rank cutoff for valid hits from BLAST result, default is 5]
        [-n NCPUS number of CPUs to be used by BLAST, default 1]
        [-C COVERAGE subject coverage cutoff for BLAST, default 0]
        [-z ORTHOLOG whether only use orthologs for cross-species annotation or not, default NO (if only using orthologs, please provide the species abbreviation of your input)]
        [-b BGFILE background file, the output of annotate (3 or 4-letter file name is not allowed), or species abbreviation, default same species as annotate]
        [-d DB databases for selection, 1-letter abbreviation separated by "/": K for KEGG PATHWAY, n for PID, b for BioCarta, R for Reactome, B for BioCyc, p for PANTHER,
               o for OMIM, k for KEGG DISEASE, f for FunDO, g for GAD, N for NHGRI GWAS Catalog and G for Gene Ontology, default K/n/b/R/B/p/o/k/f/g/N/]
        [-m METHOD choose statistical test method: b for binomial test, c for chi-square test, h for hypergeometric test / Fisher's exact test, and x for frequency list,
                   default hypergeometric test / Fisher's exact test
        [-n FDR choose false discovery rate (FDR) correction method: BH for Benjamini and Hochberg, BY for Benjamini and Yekutieli, QVALUE, and None, default BH]
	[-c CUTOFF terms with less than cutoff number of genes are not used for statistical tests, default 5]
	[-S INSPECIES map id to other species
	[-k KOBAS HOME The path to kobas_home, which is the parent directory of sqlite3/ and seq_pep/]
        [-v BLAST HOME The path to blast_home, which is the parent directory of blastx and blastp.]
        [-y BLASTDB The path to seq_pep/]
        [-q KOBASDB The path to sqlite3/]
        [-p BLASTP The path to blastp]
        [-x BLASTX The path to blastx]"
fi


ARGS=''
#THESE WILL ALWAYS BE THE SAME BECAUSE THEY INDICATE WHERE BLAST IS INSTALLED IN THE CONTAINER
blasthome="/usr/local/bin/"
blastp="/usr/local/bin/blastp"
blastx="/usr/local/bin/blastx"
kobashome="/work-dir"
kobasdb="/work-dir/sqlite3"
blastdb="/work-dir/seq_pep"

#IF STATEMENTS EXIST FOR EACH OPTIONAL PARAMETER WITH AN ARGUMENT
#OPTIONS REQUIRED FOR ONE ANALYSIS ARE CONSIDERED OPTIONAL HERE BECAUSE THEY WON'T BE PROVIDED IN ALL CIRCUMSTANCES
#if [ -n "${bgfile}" ]; then ARGS="$ARGS -b $bgfile"; fi
#if [ -n "${cutoff}" ]; then ARGS="$ARGS -c $cutoff"; fi
#if [ -n "${coverage}" ]; then ARGS="$ARGS -C $coverage"; fi
#if [ -n "${databases}" ]; then ARGS="$ARGS -d $databases"; fi
#if [ -n "${fgfile}"]; then ARGS="$ARGS -f $fgfile"; fi
#if [ -n "${eval}" ]; then ARGS="$ARGS -e $eval"; fi
#if [ -n "${infile}" ]; then ARGS="$ARGS -i $infile"; fi
#if [ -n "${kobashome}" ]; then ARGS="$ARGS -k $kobashome"; fi #MIGHT WANT TO INCLUDE IN HELP INFO THAT THIS IS THE ABSOLUTE PATH IN THE CONTAINER
#if [ -n "${method}" ]; then ARGS="$ARGS -m $method"; fi
#if [ -n "${fdr}" ]; then ARGS="$ARGS -n $fdr"; fi
#if [ -n "${out}" ]; then ARGS="$ARGS -o $out"; fi
#if [ -n "${blastp}" ]; then ARGS="$ARGS -p $blastp"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
#if [ -n "${kobasdb}" ]; then ARGS="$ARGS -q $kobasdb"; fi #MIGHT WANT TO INCLUDE IN HELP INFO THAT THIS IS THE ABSOLUTE PATH IN THE CONTAINER
#if [ -n "${rank}" ]; then ARGS="$ARGS -r $rank"; fi 
#if [ -n "${species}" ]; then ARGS="$ARGS -s $species"; fi
#if [ -n "${inspecies}" ]; then ARGS="$ARGS -S $inspecies"; fi
#if [ -n "${intype}" ]; then ARGS="$ARGS -t $intype"; fi
#if [ -n "${blasthome}" ]; then ARGS="$ARGS -v $blasthome"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
#if [ -n "${blastx}" ]; then ARGS="$ARGS -x $blastx"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
#if [ -n "${blastdb}" ]; then ARGS="$ARGS -y $blastdb"; fi 
#if [ -n "${ortholog}" ]; then ARGS="$ARGS -z $ortholog"; fi
#if [ -n "${ortholog}" ]; then ARGS="$ARGS -Z $ortholog"; fi
#COVERAGE, CUTOFF AND ORTHOLOG HAVE FLAG DISCREPANCIES BETWEEN ANNOT, IDENT AND RUN--NEED TO COME UP WITH A WAY TO SUPPLY THEM TO KOBAS CORRECTLY
#CHECK RUN TO MAKE SURE Z ISN'T SUPPOSED TO BE z AND VICE VERSA WITH ANNOT
      

#SO THAT THIS CONTAINER CAN BE USED BOTH IN CLI AND DE I SET KOBASHOME, KOBASDB AND BLASTDB TO THE WORKING-DIR AND THEN PEOPLE CAN OPTIONALLY OVERRIDE IN CLI
if [ $1 == "-a" ]
then 
    gunzip sqlite3/$species'.db.gz'
    gunzip sqlite3/organism.db.gz
    if [ -n "${coverage}" ]; then ARGS="$ARGS -C $coverage"; fi
    if [ -n "${eval}" ]; then ARGS="$ARGS -e $eval"; fi
    if [ -n "${infile}" ]; then ARGS="$ARGS -i $infile"; fi
    if [ -n "${kobashome}" ]; then ARGS="$ARGS -k $kobashome"; fi #MIGHT WANT TO INCLUDE IN HELP INFO THAT THIS IS THE ABSOLUTE PATH IN THE CONTAINER
    if [ -n "${fdr}" ]; then ARGS="$ARGS -n $fdr"; fi
    if [ -n "${out}" ]; then ARGS="$ARGS -o $out"; fi
    if [ -n "${blastp}" ]; then ARGS="$ARGS -p $blastp"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${kobasdb}" ]; then ARGS="$ARGS -q $kobasdb"; fi #MIGHT WANT TO INCLUDE IN HELP INFO THAT THIS IS THE ABSOLUTE PATH IN THE CONTAINER
    if [ -n "${rank}" ]; then ARGS="$ARGS -r $rank"; fi
    if [ -n "${species}" ]; then ARGS="$ARGS -s $species"; fi    
    if [ -n "${intype}" ]; then ARGS="$ARGS -t $intype"; fi
    if [ -n "${blasthome}" ]; then ARGS="$ARGS -v $blasthome"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${blastx}" ]; then ARGS="$ARGS -x $blastx"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${blastdb}" ]; then ARGS="$ARGS -y $blastdb"; fi
    if [ -n "${ortholog}" ]; then ARGS="$ARGS -z $ortholog"; fi
    if [ $intype == 'fasta:pro' ] || [ $intype == 'fasta:nuc' ] 
    then 
	gunzip seq_pep/$species'.pep.fasta.gz'
    fi
    kobas-annotate -i $infile -t $intype -s $species -o $out -v $blasthome -p $blastp -x $blastx -k $kobashome -q $kobasdb -y $blastdb $ARGS
fi

if [ $1 == "-g" ]
then
    if [ -n "${bgfile}" ]; then ARGS="$ARGS -b $bgfile"; fi
    if [[ $bgfile == "???" ]] || [[ $bgfile == "????" ]]
    then
        gunzip sqlite3/$bgfile'.db.gz'
        gunzip sqlite3/organism.db.gz
    fi
    if [ -n "${cutoff}" ]; then ARGS="$ARGS -c $cutoff"; fi
    if [ -n "${databases}" ]; then ARGS="$ARGS -d $databases"; fi
    if [ -n "${fgfile}" ]; then ARGS="$ARGS -f $fgfile"; fi
    if [ -n "${kobashome}" ]; then ARGS="$ARGS -k $kobashome"; fi #MIGHT WANT TO INCLUDE IN HELP INFO THAT THIS IS THE ABSOLUTE PATH IN THE CONTAINER
    if [ -n "${method}" ]; then ARGS="$ARGS -m $method"; fi
    if [ -n "${fdr}" ]; then ARGS="$ARGS -n $fdr"; fi
    if [ -n "${out}" ]; then ARGS="$ARGS -o $out"; fi
    if [ -n "${blastp}" ]; then ARGS="$ARGS -p $blastp"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${kobasdb}" ]; then ARGS="$ARGS -q $kobasdb"; fi #MIGHT WANT TO INCLUDE IN HELP INFO THAT THIS IS THE ABSOLUTE PATH IN THE CONTAINER
    if [ -n "${blasthome}" ]; then ARGS="$ARGS -v $blasthome"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${blastx}" ]; then ARGS="$ARGS -x $blastx"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${blastdb}" ]; then ARGS="$ARGS -y $blastdb"; fi
    kobas-identify -f $fgfile -o $out -v $blasthome -p $blastp -x $blastx -k $kobashome -q $kobasdb -y $blastdb $ARGS
fi


if [ $1 == "-a" ] && [ $2 == "-g" ]
then
    gunzip sqlite3/$species'.db.gz'
    gunzip sqlite3/organism.db.gz
    if [ -n "${bgfile}" ]; then ARGS="$ARGS -b $bgfile"; fi
    if [ -n "${cutoff}" ]; then ARGS="$ARGS -c $cutoff"; fi
    if [ -n "${coverage}" ]; then ARGS="$ARGS -C $coverage"; fi
    if [ -n "${databases}" ]; then ARGS="$ARGS -d $databases"; fi
    if [ -n "${eval}" ]; then ARGS="$ARGS -E $eval"; fi
    if [ -n "${infile}" ]; then ARGS="$ARGS -i $infile"; fi
    if [ -n "${kobashome}" ]; then ARGS="$ARGS -k $kobashome"; fi #MIGHT WANT TO INCLUDE IN HELP INFO THAT THIS IS THE ABSOLUTE PATH IN THE CONTAINER
    if [ -n "${method}" ]; then ARGS="$ARGS -m $method"; fi
    if [ -n "${fdr}" ]; then ARGS="$ARGS -n $fdr"; fi
    if [ -n "${ncpus}" ]; then ARGS="$ARGS -N $ncpus"; fi
    if [ -n "${out}" ]; then ARGS="$ARGS -o $out"; fi
    if [ -n "${blastp}" ]; then ARGS="$ARGS -p $blastp"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${kobasdb}" ]; then ARGS="$ARGS -q $kobasdb"; fi #MIGHT WANT TO INCLUDE IN HELP INFO THAT THIS IS THE ABSOLUTE PATH IN THE CONTAINER
    if [ -n "${rank}" ]; then ARGS="$ARGS -R $rank"; fi
    if [ -n "${species}" ]; then ARGS="$ARGS -s $species"; fi
    if [ -n "${inspecies}" ]; then ARGS="$ARGS -S $inspecies"; fi
    if [ -n "${intype}" ]; then ARGS="$ARGS -t $intype"; fi
    if [ -n "${blasthome}" ]; then ARGS="$ARGS -v $blasthome"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${blastx}" ]; then ARGS="$ARGS -x $blastx"; fi #MAYBE I SHOULDN'T PROVIDE THIS OPTION IF IT NEVER CHANGES
    if [ -n "${blastdb}" ]; then ARGS="$ARGS -y $blastdb"; fi
    if [ -n "${ortholog}" ]; then ARGS="$ARGS -Z $ortholog"; fi
    if [ $intype = 'fasta:pro' ] || [ $intype = 'fasta:nuc' ]
    then
        gunzip seq_pep/$species'.pep.fasta.gz'
    fi
    kobas-run -i $infile -t $intype -s $species -o $out -v $blasthome -p $blastp -x $blastx -k $kobashome -q $kobasdb -y $blastdb $ARGS
fi
#rm -r seq_pep
#rm -r sqlite3
exit 0
