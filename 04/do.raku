use v6.d;
use Test;

#https://adventofcode.com/2022/day/4

sub do (Str $fname, &countIf) {
    my Int $ret;

    my &toRange = { $_.split('-') };

    for $fname.IO.lines -> $line {
        my $groups = $line.split(',');
        if &countIf($groups[0].&toRange, $groups[1].&toRange) {
            $ret++
        }
    }

    $ret
}

sub countIfp1 ($range1, $range2) {
    my &contains = -> $container, $containee {
        $containee[0] >= $container[0] && $containee[1] <= $container[1]
    }
    &contains($range1, $range2) || &contains($range2, $range1)
}

is do('input.test', &countIfp1), 2, 'p1 test';
{
    my $res = do('input', &countIfp1);
    say 'p1 = ', $res;
    is $res, 538, 'p1';
}

sub countIfp2 ($range1, $range2) {
    # partial overlap = not disjunct
    !($range1[1] < $range2[0] || $range2[1] < $range1[0])
}

is do('input.test', &countIfp2), 4, 'p2 test';
{
    my $res = do('input', &countIfp2);
    say 'p2 = ', $res;
    is $res, 792, 'p2';
}
