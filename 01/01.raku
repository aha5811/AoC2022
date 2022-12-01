use v6.d;
use Test;

sub do01 ($fname, $best) {
    my @lines = $fname.IO.lines;
    my Int @elfCals;

    my Int $calCnt = 0;
    for @lines -> $line {
        if $line == '' {
            @elfCals.push($calCnt);
            $calCnt = 0;
        } else {
            $calCnt += Numeric($line);
        }
    }
    @elfCals.push($calCnt);

    return [+] @elfCals.sort.reverse[^$best];
}

is do01('01/01.input.test', 1), 24000;
say do01('01/01.input', 1);
is do01('01/01.input.test', 3), 45000;
say do01('01/01.input', 3);
