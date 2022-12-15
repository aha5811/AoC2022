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

sub findCoveredX(@sensors, %s2range, $row) {
    my @covered;
    for @sensors -> @s { @covered.append(findCoveredX1(@s, %s2range, $row)) }
    @covered.unique; # remove duplicates
}

sub findCoveredX1(@s, %s2range, Int $y) {
    my $x = @s[0];
    my Int $range = %s2range{s(@s)};
    my @ret;
    if md([ $x, $y ], @s) <= $range { # nearest point with this y
        @ret.push($x);
        for (-1, +1) { # left, right
            loop (my $xx = $x + $_ ;; $xx = $xx + $_) { # move away
                last if md([$xx, $y], @s) > $range; #  break as soon as out of range
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
say 'p1 took: ', ($now - INIT now).round(0.1), 's'; # ~36s (throttled)

my $p2multiplier = 4000000;

sub doP2 (Str $fname, Int $min, Int $max) {

    my $in = readInput($fname);
    my @sensors = $in[0];
    my %s2range = $in[2];

    for [$min...$max] -> $row {
        my @covered = findCoveredX(@sensors, %s2range, $row);
        for [$min...$max] -> $x {
            if @covered.first($x) !~~ Int {
                return $x * $p2multiplier + $row
            }
        }
    }

}

is doP2('input.test', 0, 20), 56000011, 'p2 test';
#`{
    my $res = doP2('input', 0, 4000000);
    say 'p2 = ', $res;
    is $res, 0, 'p2';
}

say 'p2 took: ', (now - $now).round(0.1), 's';
