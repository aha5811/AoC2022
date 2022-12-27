use v6.d;
use Test;

#https://adventofcode.com/2022/day/22

# start top left looking right
# . = free, # = wall, space = void
# R = turn 90 right, L = turn 90 left

sub do (Str $fname) {

    my @mlines;
    my @commands;

    my $width = 0;

    for $fname.IO.lines {
        if $_ ~~ /<alnum>+/ {
            for $_.split(/R||L/, :v) {
                my $t = $_.Str;
                @commands.push($t ~~ /^<digit>+$/ ?? +$t !! $t)
            }
        } elsif $_ !eq '' {
            @mlines.push($_);
            $width = max($width, $_.chars);
        }
    }

    my $height = @mlines.elems;

    my @m[$width;$height];
    {
        my Int $y = 0;
        for @mlines {
            for $_.comb.kv -> $k, $v {
                @m[$k;$y] = $v
            }
            for [$_.chars..^$width] {
                @m[$_;$y] = ' '
            }
            $y++
        }
    }

    # start
    my Int ($x, $y) = -1, 0;
    my $d = 'R';

    sub turn($cmd) {
        given $d {
            when 'R' { $d = $cmd eq 'R' ?? 'D' !! 'U' }
            when 'L' { $d = $cmd eq 'R' ?? 'U' !! 'D' }
            when 'U' { $d = $cmd eq 'R' ?? 'R' !! 'L' }
            when 'D' { $d = $cmd eq 'R' ?? 'L' !! 'R' }
        }
        @m[$x;$y] = d2s
    }

    # this is slow because for each step(!) the range of 'all' next x or y values is computed
    # we could create one range for each go cmd (but then we'd have to shift & push)
    # or we compute only the next (wrapped-around) x or y value for each step

    sub go(Int $i) {
        for [^$i] {
            given $d {
                when 'R' { updateXP }
                when 'L' { updateXM }
                when 'U' { updateYM }
                when 'D' { updateYP }
            }
            @m[$x;$y] = d2s
        }

        sub updateXP { updateX((flat [$x^...^$width], [^$x]).Array) }
        sub updateXM { updateX((flat [$x^...0], [$width^...^$x]).Array) }
        sub updateX(@range) {
            for @range -> $nx {
                given @m[$nx;$y] {
                    when ' ' { next }
                    when '#' { return }
                    default { $x = $nx; return }
                }
            }
        }
        sub updateYP { updateY((flat [$y^...^$height], [^$y]).Array) }
        sub updateYM { updateY((flat [$y^...0], [$height^...^$y]).Array) }
        sub updateY(@range) {
            for @range -> $ny {
                given @m[$x;$ny] {
                    when ' ' { next }
                    when '#' { return }
                    default { $y = $ny; return }
                }
            }
        }
    }

    sub d2s {
        given $d {
            when 'R' { return '>' }
            when 'D' { return 'v' }
            when 'L' { return '<' }
            when 'U' { return '^' }
        }
    }

    sub out {
        for [^$height] -> $y {
            my $line = '';
            for [^$width] -> $x {
                if @m[$x;$y] {
                    $line ~= @m[$x;$y]
                }
            }
            say $line
        }
    }

    sub d2p {
        given $d {
            when 'R' { return 0 }
            when 'D' { return 1 }
            when 'L' { return 2 }
            when 'U' { return 3 }
        }
    }

    # move to first free position
    go(1);

    for @commands {
        if $_ ~~ Numeric { go($_) }
        else { turn($_) }
    }

    out;

    1000 * ($y + 1) + 4 * ($x + 1) + d2p
}

is do('input.test'), 6032, 'p1 test';
{
    my $res = do('input');
    say 'p1 = ', $res;
    is $res, 93226, 'p1';
}

my $now = now;
say 'p1 took: ', ($now - INIT now).round(0.1), 's'; #~27s

#is do('input.test'), 0, 'p2 test';
#`{
    my $res = do('input');
    say 'p2 = ', $res;
    is $res, 0, 'p2';
}

#say 'p2 took: ', (now - $now).round(0.1), 's';
