#!/usr/bin/perl -w
# Solgenomics@BTI // ACBS@UoA
# Surya Saha June 10, 2020
# Purpose: Create 2 output files and stats
# 1. TSV with protein name and list of Reactome, BioCyc and KEGG pathways from KOBAS
# 2. TSV Reactome, BioCyc and KEGG pathways from KOBAS and a list of member proteins
# 3. Stats: average number of genes per pathway, number of genes with pathways, number of pathways

unless (@ARGV == 1){
	print "USAGE: $0 <KOBAS OUTPUT FILE>\n";
	exit;
}

use strict;
use warnings;

my ($ifname,$protein,$pathways,%pathway_hash);
my ($protein_ctr, $pathway_ctr) = 0;

$ifname=$ARGV[0];
unless(open(IN,$ifname)){print "not able to open ".$ifname."\n\n";exit;}
unless(open(OUT_ACC_PATHWAY,">${ifname}_KOBAS_acc_pathways.tsv")){print "not able to open ".$ifname."_KOBAS_acc_pathways.tsv\n\n";exit;}
unless(open(OUT_PATHWAY_ACC,">${ifname}_KOBAS_pathways_acc.tsv")){print "not able to open ".$ifname."_KOBAS_pathways_acc.tsv\n\n";exit;}


while (my $rec = <IN>){
	chomp $rec;

	if ( ($rec =~ /^Query:/) && (!defined $protein) ){									#first protein
		my @rec_arr = split "\t", $rec;
		$protein = $rec_arr[1];															#get protein name
		$pathways = '';
	}
	elsif( ($rec =~ /^Query:/) && (defined $protein) ){
		if ( length $pathways > 0 ){
			$pathways =~ s/^,//;
			print OUT_ACC_PATHWAY "$protein\t$pathways\n";
			$protein_ctr++;
		}
		my @rec_arr = split "\t", $rec;
		$protein = $rec_arr[1];															#get new protein name
		$pathways = '';
	}
	elsif ( ($rec !~ /^Query:/) && (defined $protein) && ($rec ne '////') ){			#get valid pathways
		if ( ($rec =~ /Reactome/) || ($rec =~ /KEGG/) || ($rec =~ /BioCyc/) ){
			my @pathway_arr = split "\t", $rec;
			my $db = $pathway_arr[ $#pathway_arr - 1 ];
			if ( $db =~ /KEGG/ ){ $db = 'KEGG'; }
			$pathways = $pathways . ',' . $db . ':' . $pathway_arr[$#pathway_arr];

			if ( exists $pathway_hash{$db . ':' . $pathway_arr[$#pathway_arr] } ){		#add protein to pathway hash
				$pathway_hash{$db . ':' . $pathway_arr[$#pathway_arr] } = $pathway_hash{$db . ':' . $pathway_arr[$#pathway_arr] } . ',' . $protein;
			}
			else{
				$pathway_hash{$db . ':' . $pathway_arr[$#pathway_arr] } = $protein;	
			}
		}
	}
}

while (my ($pathway,$proteins) = each %pathway_hash){
	print OUT_PATHWAY_ACC $pathway . "\t" .$proteins . "\n";
	$pathway_ctr++;
}

close (IN);
close (OUT_ACC_PATHWAY);
close (OUT_PATHWAY_ACC);

print STDERR "Total proteins in pathways: $protein_ctr\n";
print STDERR "Total pathways annotated: $pathway_ctr\n";
print STDERR "Avg number of proteins per pathway: " .sprintf("%.2f", $protein_ctr/$pathway_ctr). "\n";
