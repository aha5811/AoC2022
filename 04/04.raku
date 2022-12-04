use v6.d;
use Test;

sub do04 (Str $fname, &countIf) {
    my $ret = 0;

    my &toRange = -> $_ { $_.split('-') };

    for $fname.IO.lines -> $line {
        my $groups = $line.split(',');
        if &countIf(&toRange($groups[0]), &toRange($groups[1])) {
            $ret++
        }
    }

    $ret
}

sub countIfp1 ($range1, $range2) {
    my &contains = -> $container, $containee {
        $containee[0] >= $container[0] && $containee[1] <= $container[1]
    }
    &contains($range1, $range2) || &contains($range2, $range1)
}

is do04('04.input.test', &countIfp1), 2;
say do04('04.input', &countIfp1);

sub countIfp2 ($range1, $range2) {
    # partial overlap = not disjunct
    !($range1[1] < $range2[0] || $range2[1] < $range1[0])
}

is do04('04.input.test', &countIfp2), 4;
say do04('04.input', &countIfp2);
