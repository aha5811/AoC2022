use v6.d;
use Test;

#https://adventofcode.com/2022/day/15

sub doP1 (Str $fname, Int $row) {

    my $in = readInput($fname);
    my @sensors = $in[0];
    my @beacons = $in[1];
    my %s2range = $in[2];

    my @covered = findCoveredX(@sensors, %s2range, $row);

    my $ret = @covered.elems; # count

    for @beacons.grep({ $_[1] == $row }).map({ $_[0] }) { # get all x coordinates of beacons in this y
        if @covered.first($_) { $ret-- } # remove one covered space from x pos array
    }

    $ret
}

sub readInput(Str $fname) {
    my @sensors;
    my @beacons;
    my %s2range;

    # Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    for $fname.IO.lines {
        my @w = $_.subst(/ x||y||\=||\,||\: /, :g).words;
        my @s = [ +@w[2], +@w[3] ];
        my @b = [ +@w[8], +@w[9] ];

        @sensors.push(@s);
        if !@beacons.first({ $_[0] == @b[0] && $_[1] == @b[1] }) { @beacons.push(@b) }

        %s2range{s(@s)} = md(@s, @b);
    }

    \( @sensors, @beacons, %s2range )
}

sub s(@x) of Str { @x[0]~'x'~@x[1] } # point to Str
sub md(@x, @y) { abs(@x[0] - @y[0]) + abs(@x[1] - @y[1]) } # manhattan distance

sub findCoveredX(@sensors, %s2range, $row, $min = -Inf, $max = Inf) {
    my @covered;
    for @sensors -> @s {
        @covered.append(findCoveredX1(@s, %s2range, $row, $min, $max));
    }
    @covered.unique
}

sub findCoveredX1(@s, %s2range, Int $y, $min, $max) {
    my $x = @s[0];
    my Int $range = %s2range{s(@s)};
    my @ret;
    if md([ $x, $y ], @s) <= $range { # nearest point with this y
        if $x >= $min && $x <= $max { @ret.push($x) }
        for (-1, +1) { # left, right
            loop (my $xx = $x + $_ ;; $xx = $xx + $_) { # move away
                last if $xx < $min || $xx > $max || md([$xx, $y], @s) > $range; #  break as soon as out of range
                @ret.push($xx) # add as covered
            }
        }
    }
    @ret
}

is doP1('input.test', 10), 26, 'p1 test';
{
    my $res = doP1('input', 2000000);
    say 'p1 = ', $res;
    is $res, 4793062, 'p1';
}

my $now = now;
say 'p1 took: ', ($now - INIT now).round(0.1), 's'; # ~34s

my $p2multiplier = 4000000;

sub dontP2 (Str $fname, Int $min, Int $max) { # brute force only working in example

    my $in = readInput($fname);
    my @sensors = $in[0];
    my %s2range = $in[2];

    for [$min ... $max] -> $row {
        my @covered = findCoveredX(@sensors, %s2range, $row, $min, $max);
        for [$min ... $max] -> $x {
            if @covered.first($x) !~~ Int {
                return $x * $p2multiplier + $row
            }
        }
    }

}

sub doP2 (Str $fname, Int $min, Int $max) {

    my $in = readInput($fname);
    my @sensors = $in[0];
    my %s2range = $in[2];

    for [$max ... $min] -> $row { # guess that its faster to go from max to min

        my @intervals;
        @intervals.push([$min, $max]);

        for @sensors -> @s {
            my @exclude = getCoveredRange(@s, $row);
            my @new = exclude(@intervals, @exclude);
            # say @range, ' - ', @exclude, ' -> ', @new;
            @intervals = @new;
            last if @intervals.elems == 0
        }

        if total(@intervals) == 1 {
            my $x = @intervals.List.flat.unique[0];
            return $x * $p2multiplier + $row
        }

    }

    sub total(@intervals) {
        my Int $ret = 0;
        for @intervals -> @r {
            $ret += abs(@r[1] + 1 - @r[0])
        }
        $ret
    }

    sub exclude(@intervals, @exclusion) {
        if @exclusion.elems == 0 {
            return @intervals
        }
        my @ret = Array.new;
        for @intervals -> @i {
            my ($iMin, $iMax, $eMin, $eMax) = @i[0], @i[1], @exclusion[0], @exclusion[1];
            if $eMin <= $iMin && $eMax >= $iMax { # total exclusion
                next
            } elsif $eMin > $iMax || $eMax < $iMin { # no exclusion
                @ret.push(@i)
            } else { # partial exlusion -> one or two resulting ranges
                if $eMin > $iMin { @ret.push([$iMin, $eMin - 1]) }
                if $eMax < $iMax { @ret.push([$eMax + 1, $iMax]) }
            }
        }
        @ret
    }

    sub getCoveredRange(@s, $row) of Array {
        my $r = %s2range{s(@s)};
        $r -= abs($row - @s[1]); # y distance to row
        if $r <= 0 { return [] } # does not reach
        my $x = @s[0]; # touch point
        [max($min, $x - $r), min($max, $x + $r)]
    }

    0
}

is dontP2('input.test', 0, 20), 56000011, 'p2 test';
is doP2('input.test', 0, 20), 56000011, 'p2 test';
{
    my $res = doP2('input', 0, 4000000);
    say 'p2 = ', $res;
    is $res, 10826395253551, 'p2';
}

# row = 3253551
# x = 2706598

say 'p2 took: ', (now - $now).round(0.1), 's'; # ~16.7s
