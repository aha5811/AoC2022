use v6.d;
use Test;

#https://adventofcode.com/2022/day/14

my Int ($dropX, $dropY) = 500, 0;

sub doP1 (Str $fname) {

    my Int ($xMin, $xMax, $yMax);

    my $rex = / [ [\-\>]? (\d+\,\d+) ]+ /;

    for $fname.IO.lines {
        for $_.subst(' -> ', ' ', :g).words {
            my ($x, $y) = $_.split(',').map({ +$_ });
            $xMin = min($xMin, $x);
            $xMax = max($xMax, $x);
            $yMax = max($yMax, $y);
        }
    }

    my @structure = [ '.' xx $yMax + 1 ] xx $xMax + 1;

    for $fname.IO.lines {
        my Int $x = -1;
        my Int $y = -1;
        for $_.subst(' -> ', ' ', :g).words {
            my ($x2, $y2) = $_.split(',').map({ +$_ });
            if $x != -1 {
                if $x == $x2 {
                    for [$y...$y2] {
                        @structure[$x][$_] = '#';
                    }
                } else {
                    for [$x...$x2] {
                        @structure[$_][$y] = '#';
                    }
                }
            }
            $x := $x2;
            $y := $y2;
        }
    }

    loop { last if !drop }

    sub drop {
        my $x = $dropX;
        my $y = $dropY;
        loop {
            if $x < 0 || $x > $xMax || $y > $yMax {
                return False # drop to infinity
            }
            @structure[$x][$y] = 'x'; # just for output
            if isFree($x, $y+1) {
                $y++
            } elsif isFree($x-1, $y+1) {
                $x--;
                $y++;
            } elsif isFree($x+1, $y+1) {
                $x++;
                $y++;
            } else {
                @structure[$x][$y] = 'o';
                return True
            }
        }
    }

    sub isFree($x, $y) {
        if $x < 0 || $x > $xMax || $y > $yMax {
            return True
        }
        my $c = @structure[$x][$y];
        $c !eq 'o' && $c !eq '#'
    }

    sub out {
        for [0..$yMax] -> $y {
            my @r;
            for [$xMin..$xMax] -> $x {
                @r.push(@structure[$x][$y]);
            }
            say [~] @r
        }
    }

    out;

    [+] @structure.List.flat.map({ $_ eq 'o' ?? 1 !! 0})
}

is doP1('input.test'), 24, 'p1 test';
{
    my $res = doP1('input');
    say 'p1 = ', $res;
    is $res, 825, 'p1';
}

sub doP2 (Str $fname) {

    my Int ($xMin, $xMax, $yMax);

    my $rex = / [ [\-\>]? (\d+\,\d+) ]+ /;

    for $fname.IO.lines {
        for $_.subst(' -> ', ' ', :g).words {
            my ($x, $y) = $_.split(',').map({ +$_ });
            $xMin = min($xMin, $x);
            $xMax = max($xMax, $x);
            $yMax = max($yMax, $y);
        }
    }

    $yMax += 2;
    $xMax = max($dropX + $yMax, $xMax);
    my $xOff = $dropX - $yMax < 0 ?? $yMax - $dropX !! 0; # x range < 0

    my @structure = [ '.' xx $yMax + 1 ] xx $xMax + $xOff + 1;

    for [0...$xMax + $xOff] {
        @structure[$_][$yMax] = '#'
    }

    for $fname.IO.lines {
        my Int $x = -1;
        my Int $y = -1;
        for $_.subst(' -> ', ' ', :g).words {
            my ($x2, $y2) = $_.split(',').map({ +$_ });
            if $x != -1 {
                if $x == $x2 {
                    for [$y...$y2] {
                        set($x, $_, '#');
                    }
                } else {
                    for [$x...$x2] {
                        set($_, $y, '#');
                    }
                }
            }
            $x := $x2;
            $y := $y2;
        }
    }

    sub get($x, $y) {
        @structure[$x - $xOff][$y]
    }

    sub set($x, $y, $v) {
        @structure[$x - $xOff][$y] = $v;
        $xMin = min($xMin, $x);
        $xMax = max($xMax, $x);
    }

    loop {
        last if !isFree($dropX, $dropY);
        last if !drop;
    }

    sub drop {
        my $x = $dropX;
        my $y = $dropY;
        loop {
            if $x < 0 || $x > $xMax || $y > $yMax {
                return False # drop to infinity
            }
            set($x, $y, 'x'); # just for output
            if isFree($x, $y+1) {
                $y++
            } elsif isFree($x-1, $y+1) {
                $x--;
                $y++;
            } elsif isFree($x+1, $y+1) {
                $x++;
                $y++;
            } else {
                set($x, $y, 'o');
                return True
            }
        }
    }

    sub isFree($x, $y) {
        if $x < 0 || $x > $xMax || $y > $yMax {
            return True
        }
        my $c = get($x, $y);
        $c !eq 'o' && $c !eq '#'
    }

    sub out {
        for [0..$yMax] -> $y {
            my @r;
            for [$xMin..$xMax] -> $x {
                @r.push(get($x, $y));
            }
            say [~] @r
        }
    }

    out;

    [+] @structure.List.flat.map({ $_ eq 'o' ?? 1 !! 0})
}

is doP2('input.test'), 93, 'p2 test';
{
    my $res = doP2('input');
    say 'p2 = ', $res;
    is $res, 26729, 'p2';
}
