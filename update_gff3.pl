#!/usr/bin/perl -w
use strict;
use warnings;

die "USAGE:\n $0 <agp> <old_gff3> <new_gff3>" unless (@ARGV==3);

open (AGP, "<$ARGV[0]")||die "$!";
open (OLD,"<$ARGV[1]")||die "$!";
open (OUT,">$ARGV[2]")||die "$!";


#Chr1    1       1247401 1       W       Scaffold76      1       1247401 -
#Chr1    1247402 1247501 2       U       100     contig  yes     map
#Chr1    1247502 1442728 3       W       Scaffold138     1       195227  +

my %agp;
while(<AGP>){
    chomp $_;
    my @items=split/\t/,$_;
    my $chr=$items[0];
    my $len=$items[7];
    my $anchor=$items[1]-1;
    my $orient=$items[8];
    my $record=join "_",($chr,$len,$anchor,$orient);
       $agp{$items[5]}=$record;

}
  
#Scaffold52      maker   CDS     84878   85363   .       +       0       ID=Rle16530-RA:cds;Parent=Rle16530-RA;
#Scaffold52      maker   three_prime_UTR 85364   85857   .       +       .       ID=Rle16530-RA:three_prime_utr;Parent=Rle16530-RA;
#Scaffold52      maker   gene    13772   20812   .       -       .       ID=Rle16521;Name=Rle16521;
#Scaffold52      maker   mRNA    13772   20812   .       -       .       ID=Rle16521-RA;Parent=Rle16521;Name=Rle16521-RA;

while(<OLD>){
      chomp $_;
    if(/#/){
             print OUT "$_\n";
    }
    else{
        my @items=split/\t/,$_;
        my ($chr,$len,$anchor,$orient)=split/_/,$agp{$items[0]};
        my ($start,$end);
            if($orient eq "+"){
                $start=$items[3]+$anchor;
                $end=$items[4]+$anchor;
            }
            else{
                $start=$anchor+$len-$items[3]+1;
                $end=$anchor+$len-$items[4]+1;
            }
            print OUT "$chr\t$items[1]\t$items[2]\t$start\t$end\t$items[5]\t$items[6]\t$items[7]\t$items[8]\n";
     }
 } 
close OLD;
close OUT;
