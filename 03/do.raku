use v6.d;
use Test;

#https://adventofcode.com/2022/day/3

sub doP1 (Str $fname) of Int {
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
    for $first.comb -> $char {
        if $second.contains($char) {
            @ret.append($char)
        }
    }
    @ret
}

sub prio (Str $char) of Int {
    # a = 97 -> 1 (-96)
    # A = 65 -> 27 (-38)
    $char.ord - ($char eq $char.uc ?? 38 !! 96)
}

is doP1('input.test'), 157;
say doP1('input'); #8053

sub doP2 ($fname, $groupSize) {
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

is doP2('input.test', 3), 70;
say doP2('input', 3); #2425
