use v6.d;
use Test;

sub do03 ($fname) {
    my Int $prios = 0;

    for $fname.IO.lines -> $line {
        my $half = $line.chars / 2;
        my $first = $line.substr(0, $half);
        my $second = $line.substr($half);
        for $first.comb -> $c {
            if $second.contains($c) {
                # a = 97 -> 1 (-96)
                # A = 65 -> 27 (-38)
                $prios += $c.ord - ($c eq $c.uc ?? 38 !! 96);
                last
            }
        }
    }

    $prios
}

is do03('03.input.test'), 157;
say do03('03.input');
