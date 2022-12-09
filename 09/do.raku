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

sub doP2 (Str $fname, Int $l, $withOutput = False) {

    my @rope;
    for [0...$l] { @rope.push([0,0]) }

    my $H = @rope[0];

    my $pos = SetHash.new;
    addP;

    my ($xmin, $xmax, $ymin, $ymax) = 0, 0, 0, 0;
    if ($withOutput) {
        my Int $x;
        my Int $y;
        for $fname.IO.lines {
            my @words = $_.words;
            for [^+@words[1]] {
                given @words[0] {
                    when 'R' { $x++ }
                    when 'L' { $x-- }
                    when 'U' { $y-- }
                    when 'D' { $y++ }
                }
            }
            $xmin = min($xmin, $x);
            $xmax= max($xmax, $x);
            $ymin = min($ymin, $y);
            $ymax = max($ymax, $y);
        }
    }

    if $withOutput eq 'line' || $withOutput eq 'full' {
        say '== Initial State ==';
        say '';
        output
    }

    for $fname.IO.lines {
        if $withOutput eq 'line' || $withOutput eq 'full' { say '== ', $_, ' =='; say '' }
        my @words = $_.words;
        for [1...+@words[1]] {
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
            addP;
            if $withOutput eq 'full' { output }
        }
        if $withOutput eq 'line' { output }
    }
    if $withOutput eq 'final' { output }

    sub isN(@knot1, @knot2) {
        abs(@knot1[0] - @knot2[0]) <= 1 && abs(@knot1[1] - @knot2[1]) <= 1
    }

    sub m(@prevKnot, @knot) {
        for [0...1] {
            if @prevKnot[$_] < @knot[$_] { @knot[$_]-- }
            elsif @knot[$_] < @prevKnot[$_] { @knot[$_]++ }
        }
    }

    sub addP {
        with @rope[$l] {
            $pos.set($_[0] ~ ' ' ~ $_[1])
        }
    }

    sub output {
        my $xx = $xmax - $xmin;
        my $yy = $ymax - $ymin;

        my @map[$yy+1;$xx+1];
        for [0...$yy] -> $y {
            for [0 ... $xx] -> $x {
                @map[$y;$x] = '.'
            }
        }

        for $pos.keys {
            my @p = $_.words;
            @map[y(+@p[1]);x(+@p[0])] = '#';
        }
        @map[y(0);x(0)] = 's';
        for [$l...0] {
            my $knot = @rope[$_];
            @map[y($knot[1]);x($knot[0])] = $_ == 0 ?? 'H' !! $_
        }

        for [0...$yy] -> $y {
            my $line = '';
            for [0 ... $xx] -> $x {
                $line ~= @map[$y;$x]
            }
            say $line
        }
        say '';

        sub x($x) { $x - $xmin }
        sub y($y) { $y - $ymin }
    }

    $pos.elems
}

# p1 is p2 with $l = 1

my $p1length = 1;

is doP2('input.test', $p1length), 13, 'p1 test as p2(' ~ $p1length ~ ')';
is doP2('input', $p1length), 6037, 'p1 as p2(' ~ $p1length ~ ')';

my $p2length = 9;

is doP2('input.test', $p2length, 'full'), 1, 'p2 test.1';
is doP2('input.test.2', $p2length, 'line'), 36, 'p2 test.2';
{
    my $res = doP2('input', $p2length, 'final');
    say 'p2 = ', $res;
    is $res, 2485, 'p2';
}

say 'took: ', (now - INIT now).round(0.1), 's';
