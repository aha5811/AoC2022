use v6.d;
use Test;

#https://adventofcode.com/2022/day/8

sub doP1 (Str $fname) {
    my @forest;
    for $fname.IO.lines { @forest.push($_.comb.map({ +$_ })) }
    my ($xMax, $yMax) = @forest.elems, @forest[0].elems;

    my Int $freeCnt;

    for [^$xMax] -> $x {
        for [^$yMax] -> $y {
            if isFreeOneEdge($x, $y) {
                $freeCnt++
            }
        }
    }

    sub isFreeOneEdge($x, $y) {
        my $height = h($x, $y);
        # xx < x
        {
            my $isFree = True;
            for [$x^...0] -> $xx {
                if h($xx, $y) >= $height {
                    $isFree = False;
                    last
                }
            }
            if $isFree {
                return True
            }
        }
        # xx > x
        {
            my $isFree = True;
            for [$x^...^$xMax] -> $xx {
                if h($xx, $y) >= $height {
                    $isFree = False;
                    last
                }
            }
            if $isFree {
                return True
            }
        }
        # yy < y
        {
            my $isFree = True;
            for [$y^...0] -> $yy {
                if h($x, $yy) >= $height {
                    $isFree = False;
                    last
                }
            }
            if $isFree {
                return True
            }
        }
        # yy > y
        {
            my $isFree = True;
            for [$y^...^$yMax] -> $yy {
                if h($x, $yy) >= $height {
                    $isFree = False;
                    last
                }
            }
            if $isFree {
                return True
            }
        }

        False
    }

    sub h(Int $x, Int $y) of Int { @forest[$x][$y] }

    $freeCnt
}

is doP1('input.test'), 21, 'p1 test';
{
    my $res = doP1('input');
    say 'p1 = ', $res;
    is $res, 1669, 'p1';
}

sub doP2 (Str $fname) {
    my @forest;
    for $fname.IO.lines { @forest.push($_.comb.map({ +$_ })) }
    my ($xMax, $yMax) = @forest.elems, @forest[0].elems;

    my @scenicScores;

    for [^$xMax] -> $x {
        for [^$yMax] -> $y {
            @scenicScores.push(scenicScore($x, $y));
        }
    }

    sub scenicScore($x, $y) {
        my Int $ss = 1;

        my $height = h($x, $y);

        # xx < x
        {
            my $ps = 0;
            for [$x^...0] -> $xx {
                $ps++;
                if h($xx, $y) >= $height { last }
            }
            $ss *= $ps;
        }
        # xx > x
        if $ss != 0 {
            my $ps = 0;
            for [$x^...^$xMax] -> $xx {
                $ps++;
                if h($xx, $y) >= $height { last }
            }
            $ss *= $ps;
        }
        # yy < y
        if $ss != 0 {
            my $ps = 0;
            for [$y^...0] -> $yy {
                $ps++;
                if h($x, $yy) >= $height { last }
            }
            $ss *= $ps;
        }
        # yy > y
        if $ss != 0 {
            my $ps = 0;
            for [$y^...^$yMax] -> $yy {
                $ps++;
                if h($x, $yy) >= $height { last }
            }
            $ss *= $ps;
        }

        $ss
    }

    sub h(Int $x, Int $y) of Int { @forest[$x][$y] }

    [max] @scenicScores
}

is doP2('input.test'), 8, 'p2 test';
{
    my $res = doP2('input');
    say 'p2 = ', $res;
    is $res, 331344, 'p2';
}

say 'took: ', (now - INIT now).round(0.1), 's';
