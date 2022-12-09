use v6.d;
use Test;

#https://adventofcode.com/2022/day/9

sub doP1 (Str $fname) {

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

is doP1('input.test'), 13, 'p1 test';
{
    my $res = doP1('input');
    say 'p1 = ', $res;
    is $res, 6037, 'p1';
}

sub doP2 (Str $fname, Int $l) {

    my @rope;
    for [0...$l] { @rope.push([0,0]) }

    my $H = @rope[0];

    my $pos = SetHash.new;
    addP;

    for $fname.IO.lines {
        my @words = $_.words;
        for [^+@words[1]] {
            given @words[0] {
                when 'R' { $H[0]++ }
                when 'L' { $H[0]-- }
                when 'U' { $H[1]-- }
                when 'D' { $H[1]++ }
            }
            for [1...$l] {
                my $prevKnot = @rope[$_ - 1];
                my $knot = @rope[$_];
                if !isN($prevKnot, $knot) { m($prevKnot, $knot) }
            }
            addP
        }
    }

    sub isN(@knot1, @knot2) {
        abs(@knot1[0] - @knot2[0]) <= 1 && abs(@knot1[1] - @knot2[1]) <= 1
    }

    sub m(@prevKnot, @knot) {
        for [0...1] {
            if @prevKnot[$_] < @knot[$_] {
                @knot[$_]--
            } elsif @knot[$_] < @prevKnot[$_] {
                @knot[$_]++
            }
        }
    }

    sub addP {
        with @rope[$l] {
            $pos.set($_[0] ~ 'x' ~ $_[1])
        }
    }

    $pos.elems
}

# p1 is p2 with $l = 1

my $p1length = 1;

is doP2('input.test', $p1length), 13, 'p1 as p2(' ~ $p1length ~ ') test';
is doP2('input', $p1length), 6037, 'p1 as p2(' ~ $p1length ~ ')';

my $p2length = 9;

is doP2('input.test', $p2length), 1, 'p2 test.1';
is doP2('input.test.2', $p2length), 36, 'p2 test.2';
{
    my $res = doP2('input', $p2length);
    say 'p2 = ', $res;
    is $res, 2485, 'p2';
}

say 'took: ', (now - INIT now).round(0.1), 's';
