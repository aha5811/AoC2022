use v6.d;
use Test;

#https://adventofcode.com/2022/day/18

sub do (Str $fname, Bool $forP2 = False) {

    # list of voxels
    my @vlist;
    for $fname.IO.lines {
        @vlist.push($_.split(',').map({ +$_ }));
    }

    # dims
    my Int @max = [0, 0, 0];
    for [0...2] -> $i { @max[$i] = 1 + [max] @vlist.map({ $_[$i] }) }
    # +1 so water in part 2 can reach everything
    # luckily no -1 was needed

    # voxel space
    my @space = Array.new;

    my Int ($empty, $stone, $water) = 0, 1, 2;

    # fill empty
    for [0...@max[0]] -> $x {
        for [0...@max[1]] -> $y {
            for [0 ... @max[2]] -> $z {
                @space[$x][$y][$z] = $empty
            } } }

    # place stones
    for @vlist { @space[$_[0]][$_[1]][$_[2]] = $stone }

    sub oob($x, $y, $z) of Bool {
        $x < 0 || $x > @max[0] || $y < 0 || $y > @max[1] || $z < 0 || $z > @max[2]
    }

    if $forP2 { # fill with water
        my @flood;
        p(0, 0, 0);
        while @flood { checkAddSpread(@flood.shift.flat) }

        sub p($x, $y, $z) { @flood.push([$x, $y, $z]) }

        sub checkAddSpread(@v) {
            my ($x, $y, $z) = @v;

            if !oob($x, $y, $z) && @space[$x][$y][$z] == $empty {
                @space[$x][$y][$z] = $water;

                p($x-1, $y, $z);
                p($x+1, $y, $z);
                p($x, $y-1, $z);
                p($x, $y+1, $z);
                p($x, $y, $z-1);
                p($x, $y, $z+1);
            }
        }
    }

    my Int $visIf = $forP2 ?? $water !! $empty;

    my Int $vis = 0;

    for @vlist -> @v {
        my ($x, $y, $z) = @v;
        $vis += [+] visFrom($x-1,$y,$z), visFrom($x+1,$y,$z),
                    visFrom($x,$y-1,$z), visFrom($x,$y+1,$z),
                    visFrom($x,$y,$z-1), visFrom($x,$y,$z+1)
    }

    # 1 iff visible
    sub visFrom($x, $y, $z) of Int {
        # always visible from outside the boundaries
        if oob($x, $y, $z) { return 1 }

        @space[$x][$y][$z] == $visIf ?? 1 !! 0
    }

    if $forP2 {
        for [0 ... @max[2]] -> $z {
            say 'z: ', $z;
            for [0 ... @max[1]] -> $y {
                my $line = '';
                for [0 ... @max[0]] -> $x {
                    given @space[$x][$y][$z] {
                        when $water { $line ~= '+' }
                        when $stone { $line ~= '@' }
                        when $empty { $line ~= ' ' }
                    }
                }
                say $line;
            }
        }
    }

    $vis
}

is do('input.test0'), 10, 'p1 test';
is do('input.test'), 64, 'p1 test';
{
    my $res = do('input');
    say 'p1 = ', $res;
    is $res, 3466, 'p1';
}

is do('input.test', True), 58, 'p2 test';
{
    my $res = do('input', True);
    say 'p2 = ', $res;
    is $res, 2012, 'p2';
}
