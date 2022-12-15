use v6.d;
use Test;

#https://adventofcode.com/2022/day/12

sub do (Str $fname) {

    my Int $g = 'z'.ord - 'a'.ord + 1;

    my @map is Array;
    for $fname.IO.lines {
        @map.push(
            Array.new($_.comb.map({
                given $_ {
                    when 'S' { -1 }
                    when 'E' { $g }
                    default { .ord - 'a'.ord }
                }
            })))
    }
    my ($xMax, $yMax) = @map.elems, @map[0].elems;

    my @g; # goalpoint
    for [^$xMax] -> $x {
        for [^$yMax] -> $y {
            my @p = [$x, $y];
            if h(@p) == $g {
                @g = @p
            }
        }
    }
    my @dmap; #distanceMap
    for [^$xMax] -> $x {
        my @row = Array.new;
        for [^$yMax] -> $y {
            @row.push(dist([$x, $y]))
        }
        @dmap.push(@row)
    }

    sub dist(@p) { sqrt((@p[0] - @g[0])**2 + (@p[1] - @g[1])**2) }

    sub d(@p) { @dmap[@p[0]][@p[1]] } # dist for each point

    sub h(@p) { @map[@p[0]][@p[1]] } # height for each point

    my $start = Array.new;
    $start.push((0,0).Array);

    my $ret = findShortest($start);

    # naive recursive complete search

    sub findShortest(@path) {
        if h(@path[0]) == $g {
            return @path.elems - 1
        } else {
            my @lengths;
            for ns(@path) -> @n {
                @lengths.push(findShortest(with(@path, @n)))
            }
            return [min] @lengths
        }

        sub with(@path, @p) { @path.clone.unshift(@p) }

        sub ns(@path) {
            my @ret;

            my @p := @path[0];
            my $x = @p[0];
            my $y = @p[1];
            my $h = h(@p);

            checkAdd($x - 1, $y);
            checkAdd($x + 1, $y);
            checkAdd($x, $y - 1);
            checkAdd($x, $y + 1);

            return @ret.sort({ d($^a) cmp d($^b) });

            sub checkAdd($xx, $yy) {
                if $xx >= 0 && $xx < $xMax && $yy >= 0 && $yy < $yMax {
                    my @x = ($xx, $yy).Array;
                    if h(@x) <= $h + 1 && !contains(@path, @x) {
                        @ret.push(@x)
                    }
                }
            }

            sub contains(@path, @p) {
                for @path -> @x {
                    if @x[0] == @p[0] && @x[1] == @p[1] {
                        return True
                    }
                }
                return False;
            }

        }
    }

    $ret
}

is do('input.test'), 31, 'p1 test';

# works only on example
