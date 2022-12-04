use v6.d;
use Test;

#https://adventofcode.com/2022/day/1

sub do ($fname, $best) {

    my Int @calsPerElf;

    my $calCnt = 0;
    for $fname.IO.lines -> $line {
        if $line == '' {
            @calsPerElf.push($calCnt);
            $calCnt = 0
        } else {
            $calCnt += +$line
        }
    }
    @calsPerElf.push($calCnt);

    [+] @calsPerElf.sort.reverse[^$best]
}

is do('input.test', 1), 24000;
say do('input', 1); #75501
is do('input.test', 3), 45000;
say do('input', 3); #215594
