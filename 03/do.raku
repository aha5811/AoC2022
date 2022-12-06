use v6.d;
use Test;

#https://adventofcode.com/2022/day/3

sub doP1 (Str $fname) of Int {
    my Int $prioSum;

    for $fname.IO.lines -> $line {
        my $half = $line.chars / 2;
        my ($first, $second) = $line.substr(0, $half), $line.substr($half);
        $prioSum += prio(findDupes($first, $second)[0]);
    }

    $prioSum
}

sub findDupes($first, $second) {
    my @dupes;
    for $first.comb -> $char {
        if $second.contains($char) {
            @dupes.append($char)
        }
    }
    @dupes
}

sub prio (Str $char) of Int {
    # a = 97 -> 1 (-96)
    # A = 65 -> 27 (-38)
    $char.ord - ($char eq $char.uc ?? 38 !! 96)
}

is doP1('input.test'), 157, 'p1 test';
{
    my $res = doP1('input');
    say 'p1 = ', $res;
    is $res, 8053, 'p1';
}

sub doP2 ($fname, $groupSize) {
    my Int $badgeSum;

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

is doP2('input.test', 3), 70, 'p2 test';
{
    my $res = doP2('input', 3);
    say 'p2 = ', $res;
    is $res, 2425, 'p2';
}
