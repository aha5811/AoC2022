use v6.d;
use Test;

#https://adventofcode.com/2022/day/1

sub do ($fname, $best) {

    my Int @calsPerElf;

    my Int $calCnt;
    for $fname.IO.lines -> $line {
        if $line eq '' {
            @calsPerElf.push($calCnt);
            $calCnt = 0;
        } else {
            $calCnt += +$line;
        }
    }
    @calsPerElf.push($calCnt);

    [+] @calsPerElf.sort.reverse[^$best]
}

is do('input.test', 1), 24000, 'p1 test';
{
    my $res = do('input', 1);
    say 'p1 = ', $res;
    is $res, 75501, 'p1';
}

is do('input.test', 3), 45000, 'p2 test';
{
    my $res = do('input', 3);
    say 'p2 = ', $res;
    is $res, 215594, 'p2';
}
