#!/usr/bin/perl -w
# Solgenomics@BTI // ACBS@UoA
# Surya Saha June 10, 2020
# Purpose: Create a TSV with protein name and list of Reactome, BioCyc and KEGG pathways from KOBAS


unless (@ARGV == 1){
	print "USAGE: $0 <KOBAS output>\n";
	exit;
}

use strict;
use warnings;

my ($ifname,$protein,$pathways);

$ifname=$ARGV[0];
unless(open(IN,$ifname)){print "not able to open ".$ifname."\n\n";exit;}
unless(open(OUT,">$ifname.KOBAS.pathways.tsv")){print "not able to open ".$ifname.".KOBAS.pathways.tsv\n\n";exit;}


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
			print OUT "$protein\t$pathways\n";
		}
		my @rec_arr = split "\t", $rec;
		$protein = $rec_arr[1];															#get new protein name
		$pathways = '';
	}
	elsif ( ($rec !~ /^Query:/) && (defined $protein) && ($rec ne '////') ){			#get valid pathways
		if ( ($rec =~ /Reactome/) || ($rec =~ /KEGG/) || ($rec =~ /BioCyc/) ){
			my @pathway_arr = split "\t", $rec;
			$pathways = $pathways . ',' . $pathway_arr[$#pathway_arr];
		}
	}
}


close (IN);
close (OUT);