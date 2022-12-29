use v6.d;
use Test;

#https://adventofcode.com/2022/day/17

my $maxx = 6;
my $dropYspace = 3;
my $dropLeft = 2;

sub doP1 (Str $fname, Int $nRocks, Int $verbose = 0) {

    my @rocks = readRocks('rocks');
    my @jets = $fname.IO.lines[0].comb.map({ $_ eq '<' ?? -1 !! +1 });

    my @settledRocks;
    # top = y, left = x, r = rock

    my Int $top = 0;

    my Int $rnum = 0;
    loop {
        my %r = rockNext;

        $top = @settledRocks ?? @settledRocks[0]<t> + 1 !! 0;
        $top += $dropYspace + %r<h> - 1;
        my $left = $dropLeft;

        if $verbose >= 3 { out($top, %r, $left) }

        loop {
            my $jet = jetNext;
            if $verbose >= 3 { say 'jet: ', $jet }
            # check collision with borders
            if $left + $jet >= 0 && $left + $jet + %r<w> - 1 <= $maxx {
                # check collisions with rocks
                if noCollision(%r, $top, $left + $jet) {
                    $left += $jet
                }
            }

            if $verbose >= 3 { out($top, %r, $left) }

            # check collision with bottom
            my Bool $ok = $top - %r<h> >= 0;
            if $ok {
                # check collision with tiles with $top ... $top - %r<h>
                $ok = noCollision(%r, $top - 1, $left);
            }
            if $ok {
                $top--;
                if $verbose >= 3 { out($top, %r, $left) }
            } else {
                # save tile form with current top to settledRocks
                my %sr = t => $top, l => $left, r => %r;
                if @settledRocks.elems == 0 {
                    @settledRocks.unshift(%sr)
                } else {
                    my Int $p;
                    for @settledRocks.kv -> $i, %asr {
                        $p = $i;
                        last if $top > %asr<t>
                    }
                    @settledRocks.splice($p, 0, %sr);
                }
                if $verbose >= 2 { out($top) }
                last
            }
        }

        $rnum++;
        last if $rnum == $nRocks
    }

    if $verbose == 1 { out($top) }

    sub getSettledRocksLine($y) {
        my Bool @line = [False xx $maxx + 1];
        for @settledRocks -> %s {
            last if %s<t> < $y;
            my %r = %s<r>;
            my Int $rline = %s<t> - $y;
            if $rline >= %r<h> { next }
            for [^%r<w>] -> $x {
                @line[%s<l> + $x] ||= %r<f>[$x; $rline]
            }
        }
        @line
    }

    sub noCollision(%r, $top, $left) {
        for [^%r<h>] -> $y {
            my @srline = getSettledRocksLine($top - $y);
            for [^%r<w>] -> $x {
                if @srline[$left + $x] && %r<f>[$x;$y] {
                    return False
                }
            }
        }
        True
    }

    sub out($top, %r = {}, $left = -1) {
        my Int $ncMax = $top.Str.chars;
        for [$top ... 0] -> $y {
            my $o = '';

            # number
            {
                my $n = $y.Str;
                my $nc = $n.chars;
                if $nc < $ncMax {
                    $o ~= [~] [' ' xx $ncMax - $nc]
                }
                $o ~= $n ~ ' |';
            }

            # field
            my @srline = getSettledRocksLine($y);
            for [0 ... $maxx] -> $x {
                my $c = '.';
                if $left >= 0 # draw current rock
                    && $y > $top - %r<h> # in rock height
                    && $x >= $left && $x < $left + %r<w> # in rock width
                {
                    $c = %r<f>[$x - $left;$top - $y] ?? '@' !! '.'
                }
                if $c eq '.' && @srline[$x] {
                    $c = '#'
                }
                $o ~= $c
            }

            $o ~= '|';
            say $o
        }

        # bottom line
        {
            my $o = [~] [' ' xx $ncMax];
            $o ~= ' +';
            for [0 ... $maxx] {
                $o ~= '-'
            }
            $o ~= '+';
            say $o
        }
    }

    sub rockNext {
        my $r = @rocks.shift;
        @rocks.push($r);
        $r
    }

    sub jetNext {
        my $j = @jets.shift;
        @jets.push($j);
        $j
    }

    my $ret = @settledRocks[0]<t> + 1;
    say $nRocks, ': ', $ret;
    $ret
}

sub readRocks(Str $fname) {
    my @rocks;
    {
        my @rlines;
        for $fname.IO.lines -> $_ {
            if $_ eq '' {
                my %rock = w => @rlines[0].chars, h => @rlines.elems;
                my @f[%rock<w>; %rock<h>];
                for @rlines.kv -> $y, $tl {
                    for $tl.comb.kv -> $x, $c {
                        @f[$x; $y] = $c eq '#'
                    }
                }
                @rlines := Array.new;
                %rock<f> = @f;
                @rocks.push(%rock)
            } else {
                @rlines.push($_)
            }
        }
    }
    @rocks
}

my $p1rocks = 2022;

is doP1('input.test', $p1rocks, 0), 3068, 'p1 test';
{
    my $res = doP1('input', $p1rocks);
    say 'p1 = ', $res;
    is $res, 3161, 'p1';
}

my $now = now;
say 'p1 took: ', ($now - INIT now).round(0.1), 's'; # 1.7s (on power)
# with output of input.test: 9.9s (on power)

my $p2rocks = 1000000000000;

sub doP2(Str $fname) {

    my @rocks = readRocks('rocks');
    my @jets = $fname.IO.lines[0].comb.map({ $_ eq '<' ?? -1 !! +1 });

    # find period = kgv(5, 10091) = 50455 (both prime numbers)
    # only for input: with .test we have a much lower period
    say @rocks.elems, ' rocks * ', @jets.elems, ' jets';
    my $nRocks = @jets.elems * @rocks.elems;
    say ' = ', $nRocks;

    # => simulate 50455 stones
    # find height of 50455 stones
    my $megaH = doP1($fname, $nRocks);
    say ' => height: ', $megaH;

    my $dheight = doP1($fname, 2 * $nRocks);
    say ' => height x 2: ', $dheight;

    my $off = $dheight - $megaH * 2;
    say 'megablocks overlap: ', $off;

    # (nRocks / 50455) * period_height
    my $n = floor($p2rocks / $nRocks);
    say ' => x ', $n;
    my $h = $n * $megaH + ($n - 1) * $off;
    say ' = ', $h;

    # simulate nRocks % period_rockNum rocks
    my $rest = $p2rocks - $n * $nRocks;
    say ' rest: ', $rest;
    my $restH = $rest == 0 ?? 0 !! doP1($fname, $rest) + $off;
    say ' with height: ', $restH;

    $h + $restH
}

is doP2('input.test'), 1514285714288, 'p2 test'; # fails too low
{
    my $res = doP2('input');
    say 'p2 = ', $res;
    is $res, 1575760578723, 'p2'; # wrong
}

say 'p2 took: ', (now - $now).round(0.1), 's'; # 69s (on power)
