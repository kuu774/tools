#! /usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use POSIX;

my $usage = <<USAGE;
Usage: perl assmbleStats.pl -i <multi fasta> -l <length>
    -i     multi fasta
    -l     contig length (default 0)
    -h     print out this
USAGE

my ($input,$length,$help) = (undef,0,undef);
GetOptions(
	   "i=s"=>\$input,
	   "l=i"=>\$length,
	   "h"=>\$help
);

if($help){
  print $usage;
  exit(0);
}

unless ($input){
  print "Input file does not provide yet\n";
  print "\n$usage\n";
  exit(1);
}

if(! -e $input){
  print "Input file '$input' does not exists\n";
  print "\n$usage\n";
  exit(1);
}

## do parsing
open(IN, $input);
my @dat; my $loopflag=0; my $count=0;
while(my $line=<IN>){
  chomp($line);

  if($line=~/^>/){
    if($loopflag==0){
      $loopflag=1;
    }
    else{
      push(@dat, $count);
      $count=0;
    }
  }

  else{
    $count+=length($line);
  }
}
push(@dat, $count);
close(IN);

my @length=();
## remove short contigs
if($length>0){
  foreach my $item(@dat){
    if($item >= $length){
      push(@length, $item);
    }
  }
}
else{
  @length=@dat;
}
##

my $num_contig=$#length+1;

## get total bases
my $sum_bases=0;
foreach my $s(@length){
  $sum_bases+=$s;
}

## get average length
my $ave_length=1.0*$sum_bases/$num_contig;

## calculate N50
my @sort=sort{$b<=>$a} @length;
my $N50=0;
my $num=0;
my $sum=0;
for(my $i=0; $i<$num_contig; $i++){
  $sum+=$sort[$i];

  #print $sort[$i],"\n";

  if($sum>=$sum_bases/2.0){
    $num=$i;
    last;
  }
}

## print
print "Number of contigs   : ".$num_contig."\n";
print "Total bases         : ".$sum_bases."\n";
print "Ave. contig size(bp): ".floor($ave_length)."\n";
print "N50 contig size (bp): ".$sort[$num]."\n";
