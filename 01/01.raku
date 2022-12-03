use v6.d;
use Test;

sub do01 ($fname, $best) {

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

is do01('01.input.test', 1), 24000;
say do01('01.input', 1); #75501
is do01('01.input.test', 3), 45000;
say do01('01.input', 3); #215594
