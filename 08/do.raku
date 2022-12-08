use v6.d;
use Test;

#https://adventofcode.com/2022/day/8

sub doP1 (Str $fname) {
    my @forest;
    for $fname.IO.lines -> $line {
        @forest.push($line.comb);
    }
    my ($x, $y) = @forest.elems, @forest[0].elems;

    my Int $freeTrees;

    my Int $xx = 0;
    for @forest -> @row {
        my Int $yy = 0;
        for @row -> $tree {
            if isFreeOneEdge($tree, $xx, $yy) {
                $freeTrees++
            }
            $yy++
        }
        $xx++
    }

    sub isFreeOneEdge($height, $xx, $yy) {
        # x < xx
        {
            my $ret = True;
            for [$xx^...0] -> $xxx {
                if h($xxx, $yy) >= $height {
                    $ret = False;
                    last
                }
            }
            if $ret {
                return True
            }
        }
        # x > xx
        {
            my $ret = True;
            for [$xx^...^$x] -> $xxx {
                if h($xxx, $yy) >= $height {
                    $ret = False;
                    last
                }
            }
            if $ret {
                return True
            }
        }
        # y < yy
        {
            my $ret = True;
            for [$yy^...0] -> $yyy {
                if h($xx, $yyy) >= $height {
                    $ret = False;
                    last
                }
            }
            if $ret {
                return True
            }
        }
        # y > yy
        {
            my $ret = True;
            for [$yy^...^$y] -> $yyy {
                if h($xx, $yyy) >= $height {
                    $ret = False;
                    last
                }
            }
            if $ret {
                return True
            }
        }
        False
    }

    sub h($x, $y) { @forest[$x][$y] }

    $freeTrees
}

is doP1('input.test'), 21, 'p1 test';
{
    my $res = doP1('input');
    say 'p1 = ', $res;
    is $res, 1669, 'p1';
}

sub doP2 (Str $fname) {
    my @forest;
    for $fname.IO.lines -> $line {
        @forest.push($line.comb);
    }
    my ($x, $y) = @forest.elems, @forest[0].elems;

    my @scenicScores;

    my Int $xx = 0;
    for @forest -> @row {
        my Int $yy = 0;
        for @row -> $tree {
            @scenicScores.push(scenicScore($tree, $xx, $yy));
            $yy++
        }
        $xx++
    }

    sub scenicScore($height, $xx, $yy) {
        my Int $s = 1;
        {
            my $ps = 0;
            for [$xx^...0] -> $xxx {
                $ps++;
                if h($xxx, $yy) >= $height { last }
            }
            $s *= $ps;
        }
        {
            my $ps = 0;
            for [$xx^...^$x] -> $xxx {
                $ps++;
                if h($xxx, $yy) >= $height { last }
            }
            $s *= $ps;
        }
        {
            my $ps = 0;
            for [$yy^...0] -> $yyy {
                $ps++;
                if h($xx, $yyy) >= $height { last }
            }
            $s *= $ps;
        }
        {
            my $ps = 0;
            for [$yy^...^$y] -> $yyy {
                $ps++;
                if h($xx, $yyy) >= $height { last }
            }
            $s *= $ps;
        }
        $s
    }

    sub h($x, $y) { @forest[$x][$y] }

    [max] @scenicScores
}

is doP2('input.test'), 8, 'p2 test';
{
    my $res = doP2('input');
    say 'p2 = ', $res;
    is $res, 331344, 'p2';
}

say 'took: ', (now - INIT now), 's';
