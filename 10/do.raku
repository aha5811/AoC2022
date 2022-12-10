use v6.d;
use Test;

#https://adventofcode.com/2022/day/10

sub doP1 (Str $fname) {

    my Int $ssSum;

    # checkpoints
    my @cps = (20, 60, 100, 140, 180, 220).reverse;
    my $cp = @cps.pop;

    my Int $cycle = 0;
    my Int $X = 1;

    my Int $ret;

    for $fname.IO.lines {
        my @words = $_.words;
        if @words[0] eq 'noop' {
            check
        } else { # add
            check;
            check;
            $X += +@words[1]
        }
    }

    sub check {
        $cycle++;
        if $cycle == $cp {
            $ssSum += $cp * $X;
            if @cps {
                $cp = @cps.pop
            } else {
                $ret = $ssSum
            }
        }
    }

    $ret
}

doP1('input.test0');

is doP1('input.test'), 13140, 'p1 test';
{
    my $res = doP1('input');
    say 'p1 = ', $res;
    is $res, 10760, 'p1';
}

sub doP2 (Str $fname) {

    my Int $p = 0;
    my Int $X = 1;
    my $line = '';

    for $fname.IO.lines {
        my @words = $_.words;
        if @words[0] eq 'noop' {
            check
            } else { # add
            check;
            check;
            $X += +@words[1]
        }
    }

    sub check {
        $line ~= $X - 1 <= $p <= $X + 1 ?? '#' !! '.';
        $p++;
        if $p % 40 == 0 {
            say $line;
            $line = '';
            $p = 0;
        }
    }
}

doP2('input.test');
#`[
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
]

doP2('input');
#`[
####.###...##..###..#..#.####..##..#..#.
#....#..#.#..#.#..#.#..#.#....#..#.#..#.
###..#..#.#....#..#.####.###..#....####.
#....###..#.##.###..#..#.#....#.##.#..#.
#....#....#..#.#....#..#.#....#..#.#..#.
#....#.....###.#....#..#.#.....###.#..#.
]
# FPGPHFGH
