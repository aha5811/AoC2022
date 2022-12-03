use v6.d;
use Test;

sub do03p1 (Str $fname) of Int {
    my Int $prioSum = 0;

    for $fname.IO.lines -> $line {
        my $half = $line.chars / 2;
        my $first = $line.substr(0, $half);
        my $second = $line.substr($half);

        $prioSum += prio(findDupes($first, $second)[0]);
    }

    $prioSum
}

sub findDupes($first, $second) {
    my @ret;
    for $first.comb -> $c {
        if $second.contains($c) {
            @ret.append($c)
        }
    }
    @ret
}

sub prio (Str $c) of Int {
    # a = 97 -> 1 (-96)
    # A = 65 -> 27 (-38)
    $c.ord - ($c eq $c.uc ?? 38 !! 96)
}

is do03p1('03.input.test'), 157;
say do03p1('03.input');

sub do03p2 ($fname, $groupSize) {
    my Int $badgeSum = 0;

    my @group;
    for $fname.IO.lines -> $line {
        @group.append($line);
        if @group.elems == $groupSize {
            $badgeSum += prio(findBadges(@group)[0]);
            @group.splice;
        }
    }

    $badgeSum
}

sub findBadges (@group) {
    my @ret = @group.pop.comb;
    while @group {
       @ret = findDupes(@ret, @group.pop)
    }
    @ret
}

is do03p2('03.input.test', 3), 70;
say do03p2('03.input', 3);
