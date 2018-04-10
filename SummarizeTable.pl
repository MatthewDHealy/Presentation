#!/usr/bin/perl -w
# SummarizeTable.pl
#
# Summarizes a table in tab-delimited text format
# with field names in the first line

use strict;

my $lines=0;
my $WarnCount = 0;

my @FieldName;
my %FieldNumber;
#  The @FieldName array has NAMES of fields, indexed on number
#  The %FieldNumber hash has NUMBERS of fields, indexed on name
#
#  If the same name appears more than once in the first line
#  then an underscore suffix is added.  If that doesn't make
#  the name unique, another underscore is added until it is
#  unique

my %Count;
#  Hash that will contain counts of unique values in each
#  data field, indexed first on field name and then on
#  the data value.

my $now = localtime() . "\n";
warn ("Starting parse at $now");

while(<>)
{
    my $line = $_;
    $line =~ s/[\n\r]+//g;
    my @line = split(/\t/,$line);
    $lines++;
    if ($lines == 1)
      {
          # in first line
	  for (my $i=0 ; $i < scalar(@line) ; $i++)
	    {
	       my $name = $line[$i];

	       while (defined($FieldNumber{$name}))
	         { $name = $name . '_'; }
	       # in case of duplicated field names, make unique
	       # by padding with underscores
	       $FieldName[$i] = $name;
	       $FieldNumber{$name} = $i;
	    }
      }
    else
      {
          # in data line
	  for (my $i=0 ; $i < scalar(@line) ; $i++)
	    {
	       my $value = $line[$i];
	       my $name;
	       if (defined($FieldName[$i]))
	         {
		    $name = $FieldName[$i];
		    $Count{$i}{$value}++;
	         }
               else
	         {
		    $WarnCount++;
	         }
	    }
      }
}


$now = localtime() . "\n";
warn ("Done with parse at $now");

#  $Count{$i}{$value}
#  here $i is the field number
#
#  $FieldName[$i] = $name
#  here again $i is the field number

for (my $i =0 ; $i < scalar(@FieldName) ; $i++)
  {
     my $name = $FieldName[$i];
     print "\n\nField number $i is called $name\n";
     my %ThisCount = %{$Count{$i}};
     my $n = 0;
     foreach my $key (sort { $ThisCount{$b} <=> $ThisCount{$a} } keys %ThisCount) 
       {
           $n++;
	   if ($n < 21)
	     {
                print "$name\t$n\t$key appears $ThisCount{$key} times\n";
	     }
        }
     print "there are $n unique values for this field\n";

  }

$now = localtime() . "\n";
warn ("Done with summary at $now");



if ($WarnCount > 0)
  {
     warn("Note: there were $WarnCount fields beyond those named in header line!\n");
  }

__END__
Copyright 2017 Matthew David Healy
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
