use v6.d;
use Test;

#https://adventofcode.com/2022/day/23

sub do (Str $fname, Int $maxRounds, Bool $forP2, Bool $verbose = False) {

    my Int $xmin;
    my Int $xmax;
    my Int $ymin;
    my Int $ymax;

    sub minmax($x, $y) {
        $xmin = min($xmin, $x);
        $xmax = max($xmax, $x);
        $ymin = min($ymin, $y);
        $ymax = max($ymax, $y);
    }

    my @elves;
    {
        my Int $y = 0;
        for $fname.IO.lines {
            for $_.comb.kv -> $x, $c {
                if $c eq '#' {
                    my %e = x => $x, y => $y, d => ['n', 's', 'w', 'e'];
                    minmax($x, $y);
                    @elves.push(%e);
                }
            }
            $y++
        }
    }

    my ($elf, $free, $onePropose, $multiPropose) = 1, 0, 2, 3;

    my Int $lastRound;

    for [1...$maxRounds] -> $round {

        # recompute borders to compact
        ($xmin, $xmax) = ($xmax, $xmin);
        ($ymin, $ymax) = ($ymax, $ymin);
        for @elves -> %e { minmax(%e<x>, %e<y>) }

        # -> 0,0
        my Int ($width, $height) =
            $xmax - $xmin, $ymax - $ymin;

        # compute complete map
        my @map;
        for [0...$width] -> $x {
            for [0...$height] -> $y {
                @map[$x;$y] = $free } }
        for @elves -> %e { @map[%e<x> - $xmin; %e<y> - $ymin] = $elf }

        if $round == 1 {
            say '== Initial State ==';
            out;
        }

        my Int $noMove = 0;
        for @elves -> %e {
            %e<xnext>:delete;
            %e<ynext>:delete;
            if checkPropose(%e, 'stay') {
                $noMove++
            } else {
                for %e<d>.flat -> $d {
                    last if checkPropose(%e, $d)
                }
            }
            %e<d>.push(%e<d>.shift);
        }

        sub checkPropose(%e, Str $d) of Bool {
            my Int ($x, $y) = %e<x>, %e<y>;

            my ($fnw, $fn, $fne, $fe, $fse, $fs, $fsw, $fw) =
                    f($x - 1, $y - 1), f($x, $y - 1), f($x + 1, $y - 1),
                    f($x + 1, $y),
                    f($x + 1, $y + 1), f($x, $y + 1), f($x - 1, $y + 1),
                    f($x - 1, $y);

            my $ret = False;

            if $verbose { say $x, 'x', $y, ' checks ', $d };

            given $d {
                when 'stay' {
                    if $fnw && $fn && $fne && $fe && $fse && $fs && $fsw && $fw {
                        $ret = True
                    }
                }
                when 'n' {
                    if $fnw && $fn && $fne {
                        %e<xnext> = $x;
                        %e<ynext> = $y - 1;
                        $ret = True
                    }
                }
                when 's' {
                    if $fsw && $fs && $fse {
                        %e<xnext> = $x;
                        %e<ynext> = $y + 1;
                        $ret = True
                    }
                }
                when 'w' {
                    if $fnw && $fw && $fsw {
                        %e<xnext> = $x - 1;
                        %e<ynext> = $y;
                        $ret = True
                    }
                }
                when 'e' {
                    if $fne && $fe && $fse {
                        %e<xnext> = $x + 1;
                        %e<ynext> = $y;
                        $ret = True
                    }
                }
            }

            # set propose on map only if !stay && if inside the map
            if $ret && $d !eq 'stay' {
                if $xmin <= %e<xnext> <= $xmax && $ymin <= %e<ynext> <= $ymax {
                    my $set;
                    given @map[%e<xnext> - $xmin; %e<ynext> - $ymin] {
                        when $multiPropose { $set = $multiPropose }
                        when $onePropose { $set = $multiPropose }
                        default { $set = $onePropose }
                    }
                    @map[%e<xnext> - $xmin; %e<ynext> - $ymin] = $set;
                }
            }

            if $ret && $verbose { say ' -> ', $d.uc, '!' }

            $ret
        }

        for @elves -> %e {
            if %e<xnext>:exists {
                if $verbose {
                    say %e<x>, 'x', %e<y>, ' wants to move to ', %e<xnext>, 'x', %e<ynext>
                }
                if fnext(%e<xnext>, %e<ynext>) {
                    if $verbose { say ' > MOVES!' }
                    %e<x> = %e<xnext>;
                    %e<y> = %e<ynext>;
                }
            }
        }

        sub f($x, $y) of Bool {
            #fNaive($x, $y)
            fBetter($x, $y)
        }

        sub fNaive($x, $y) of Bool {
            @elves.first({ $_{'x'} == $x && $_{'y'} == $y }) ~~ Nil
        }

        sub fBetter($x, $y) of Bool {
            $x < $xmin || $x > $xmax || $y < $ymin || $y > $ymax
            || @map[$x - $xmin; $y - $ymin] !== $elf
        }

        sub fnext($x, $y) of Bool {
            #fnextNaive($x, $y)
            fnextBetter($x, $y)
        }

        sub fnextNaive($x, $y) of Bool {
            @elves.grep({ $_<xnext>:exists && $_<xnext> == $x
                    && $_{'ynext'} == $y }).elems == 1
        }

        sub fnextBetter($x, $y) of Bool {
            $x < $xmin || $x > $xmax || $y < $ymin || $y > $ymax
            || @map[$x - $xmin; $y - $ymin] != $multiPropose
        }

        sub out {
            for [$ymin ... $ymax] -> $y {
                my $line = '';
                for [$xmin ... $xmax] -> $x {
                    $line ~= f($x, $y) ?? '.' !! '#'
                }
                say $line
            }
        }

        say '== End of Round ', $round, ' ==';
        out;

        $lastRound = $round;
        last if $noMove == @elves.elems;
    }

    if $forP2 {
        return $lastRound
    } else {
        my Int $xmin = [min] @elves.map({ $_{'x'} });
        my Int $xmax = [max] @elves.map({ $_{'x'} });
        my Int $ymin = [min] @elves.map({ $_{'y'} });
        my Int $ymax = [max] @elves.map({ $_{'y'} });

        return ($xmax - $xmin + 1) * ($ymax - $ymin + 1) - @elves.elems
    }
}

#do('input.test0', 10);
is do('input.test', 10, False), 110, 'p1 test';
{
    my $res = do('input', 10, False);
    say 'p1 = ', $res;
    is $res, 4218, 'p1';
}

my $now = now;
say 'p1 took: ', ($now - INIT now).round(0.1), 's';
# fNaive 647.5s (on battery)
# fBetter 4s (on battery)

is do('input.test', 25, True), 20, 'p2 test';
{
    my $res = do('input', 99999, True);
    say 'p2 = ', $res;
    is $res, 976 'p2';
}

say 'p2 took: ', (now - $now).round(0.1), 's'; # ~334.1s (fBetter on battery)
