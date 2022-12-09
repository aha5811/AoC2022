use v6.d;
use Test;

#https://adventofcode.com/2022/day/9

sub do (Str $fname) {

    my ($x, $y, $tx, $ty) = 0, 0, 0, 0;

    my $pos = SetHash.new;
    addP;

    for $fname.IO.lines {
        my @words = $_.words;
        for [^+@words[1]] {
            given @words[0] {
                when 'R' { $x++ }
                when 'L' { $x-- }
                when 'U' { $y-- }
                when 'D' { $y++ }
            }
            if !isN() { m() }
            addP;
        }
    }

    sub isN { abs($x - $tx) <= 1 && abs($y - $ty) <= 1 }

    sub m {
        if $x < $tx { $tx-- } elsif $tx < $x { $tx++ }
        if $y < $ty { $ty-- } elsif $ty < $y { $ty++ }
    }

    sub addP {
        $pos.set($tx ~ 'x' ~ $ty);
    }

    $pos.elems;
}

is do('input.test'), 13, 'p1 test';
{
    my $res = do('input');
    say 'p1 = ', $res;
    is $res, 6037, 'p1';
}

#`[
is do('input.test'), 1, 'p2 test.1';
is do('input.test.2'), 36, 'p2 test.2';
{
    my $res = do('input');
    say 'p2 = ', $res;
    is $res, 0, 'p2';
}
#]