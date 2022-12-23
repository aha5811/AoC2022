use v6.d;
use Test;

#https://adventofcode.com/2022/day/18

sub do (Str $fname) {

    # list of voxels
    my @vlist;
    for $fname.IO.lines {
        @vlist.push($_.split(',').map({ +$_ }));
    }

    # voxel space
    my @space = Array.new;
    # stones = 1, empty = Any
    for @vlist { @space[$_[0]][$_[1]][$_[2]] = 1 }

    # dims
    #`{
    my Int @max = [0, 0, 0];
    for [0...2] -> $i { @max[$i] = [max] @vlist.map({ $_[$i] }) }
    }

    my Int $vis = 0;

    for @vlist -> @v {
        my $x = @v[0];
        my $y = @v[1];
        my $z = @v[2];

        $vis +=
                [+] v($x-1,$y,$z), v($x+1,$y,$z),
                    v($x,$y-1,$z), v($x,$y+1,$z),
                    v($x,$y,$z-1), v($x,$y,$z+1)
    }

    sub v($x, $y, $z) { # is visible
        return @space[$x;$y;$z] ~~ Numeric ?? 0 !! 1
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

#is do('input.test'), 0, 'p2 test';
#`{
    my $res = do('input');
    say 'p2 = ', $res;
    is $res, 0, 'p2';
}
