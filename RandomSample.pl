#!/usr/bin/perl -w
# RandomSample.pl filename numchunks chunknum seedstring
#
#  TODO: make a script that just emits hashes before each line
#        like so:
#        3848\tf9d84907d77df62017944cb23cab66305e94ee6ae6c1126415b81cc5e999bdd0\t...
#        where before the SHA256 hash in hex we put the modular result, then after
#        the SHA256 hash we put the original data.
#        Of course for the FIRST line we should put:
#        ModNum\tSHA256\t...
#
#        Such hashing would have multiple uses, including:
#              splitting a file into chunks with perl one-liners
#
#              shuffling the rows of a file using the OS sort utility
#
#              seeding for Monte Carlo purposes: VERY random yet
#              completely reproducible randomness here!
#
#        ADD AN OPTION TO THE HASHING SCRIPT that determines whether it
#        emits just the hash, just the modular number, or by default both.
# 
# To sample with replacement, use different seed values
# To sample without replacement, use different chunknum values
# To make a smaller sample, use a larger numchunks value
#
# Repeatable randoumized sampling: the same command run on the
# same input file will always generate the same output
#
# For truly random sampling, use some physical source of
# random noise to generate the seed string
#
# Use of SHA-256 hashing provides a high degree of confidence
# that our sampling is statistically uncorrelated with anything
# else

use strict;
use Digest::SHA qw(sha256);

my ($infile, $modulus, $value, $seed) = @ARGV;


$modulus = 32 unless defined ($modulus);
$seed = 'MyLiTtLeuNiQuEFuNkY572846ChARactEr56StRiNg' unless defined ($seed);
$value = 9 unless defined ($value);

warn ("input=$infile, modulus=$modulus, value=$value, seedstring=$seed\n");

open (my $input, '<:encoding(UTF-8)', $infile) or die qq(Unable to open "$infile": $!);


while(<$input>)
{
    my $line = $_;
    $line =~ s/[\n\r]+//g;
    my $hash = sha256($line .  $seed . $.);
    $hash = unpack("H*", $hash);
    my $digits = $hash;
    $digits =~ s/[^0-9]+//g;
    $digits = substr($digits,0,14);
    # in hex format, 256 bits are 64 characters.  On average about
    # 40 of those 64 hex characters will be decimal digits, and
    # it will be extremely rare that fewer than 25 of them are.
    # So it is almost certain that we'll get at least 14 digits.
    my $mod = $digits % $modulus;
    if (($.==1) or ($mod == $value)) {print "$line\n";}
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
   
