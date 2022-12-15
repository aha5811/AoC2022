use v6.d;
use Test;

#https://adventofcode.com/2022/day/

sub do (Str $fname, Int $row) {

    my @sensors;
    my @beacons;
    #my %s2b;
    my %s2md;

    # Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    for $fname.IO.lines {
        my @w = $_.subst(/ x||y||\=||\,||\: /, :g).words;
        my @s = [ +@w[2], +@w[3] ];
        my @b = [ +@w[8], +@w[9] ];

        @sensors.push(@s);
        @beacons.push(@b);

        #%s2b{s(@s)} = @b;
        %s2md{s(@s)} = md(@s, @b);
    }

    sub s(@x) of Str { @x[0]~'x'~@x[1] } # point to Str
    sub md(@x, @y) { abs(@x[0] - @y[0]) + abs(@x[1] - @y[1]) } # manhattan distance

    say @sensors;
    say @beacons;
    #say %s2b;
    say %s2md;

    my @ret;

    for @sensors -> @s { @ret.append(findCoveredX(@s, $row)) }

    sub findCoveredX(@s, Int $y) {
        my $x = @s[0];
        my $md = %s2md{s(@s)};
        my @ret;
        if md([ $x, $y ], @s) <= $md {
            @ret.push($x);
            for (-1, +1) {
                loop (my $xx = $x + $_ ;; $xx = $xx + $_) {
                    last if md([$xx, $y], @s) > $md;
                    @ret.push($xx)
                }
            }
        }
        say @s, ' with ', $md, ' sees ', @ret;
        @ret
    }

    # remove duplicates
    @ret = @ret.unique;

    my $ret = @ret.elems;

    for @beacons.grep({ $_[1] == $row }).map({ $_[0] }).unique {
        if @ret.first($_) {
            $ret--
        }
    }

    $ret
}

is do('input.test', 10), 26, 'p1 test';
{
    my $res = do('input', 2000000);
    say 'p1 = ', $res;
    is $res, 0, 'p1';
}

#is do('input.test', 0), 0, 'p2 test';
#`{
    my $res = do('input', 0);
    say 'p2 = ', $res;
    is $res, 0, 'p2';
}
