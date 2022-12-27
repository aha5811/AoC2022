use v6.d;
use Test;

#https://adventofcode.com/2022/day/23

sub do (Str $fname, Int $maxRounds, Bool $forP2, Bool $verbose = False) {

    my @elves;
    # elf: x, y, xnext, ynext, d = list
    {
        my Int $y = 0;
        for $fname.IO.lines {
            for $_.comb.kv -> $x, $c {
                if $c eq '#' {
                    my %e = x => $x, y => $y, d => ['n', 's', 'w', 'e'];
                    @elves.push(%e);
                }
            }
            $y++
        }
    }

    say '== Initial State ==';
    out;

    my Int $lastRound;

    for [1...$maxRounds] -> $round {

        my Int $noMove = 0;
        for @elves -> %e {
            %e<xnext>:delete;
            %e<ynext>:delete;
            if checkPropose(%e, 'f') {
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

            given $d {
                when 'f' {
                    if $verbose { say $x, 'x', $y, ' checks f' }
                    if $fnw && $fn && $fne && $fe && $fse && $fs && $fsw && $fw {
                        if $verbose { say ' -> F!' }
                        return True
                    }
                }
                when 'n' {
                    if $verbose { say $x, 'x', $y, ' checks n' }
                    if $fnw && $fn && $fne {
                        %e<xnext> = $x;
                        %e<ynext> = $y - 1;
                        if $verbose { say ' -> N!' }
                        return True
                    }
                }
                when 's' {
                    if $verbose { say $x, 'x', $y, ' checks s' }
                    if $fsw && $fs && $fse {
                        %e<xnext> = $x;
                        %e<ynext> = $y + 1;
                        if $verbose { say ' -> S!' }
                        return True
                    }
                }
                when 'w' {
                    if $verbose { say $x, 'x', $y, ' checks w' }
                    if $fnw && $fw && $fsw {
                        %e<xnext> = $x - 1;
                        %e<ynext> = $y;
                        if $verbose { say ' -> W!' }
                        return True
                    }
                }
                when 'e' {
                    if $verbose { say $x, 'x', $y, ' checks e' }
                    if $fne && $fe && $fse {
                        %e<xnext> = $x + 1;
                        %e<ynext> = $y;
                        if $verbose { say ' -> E!' }
                        return True
                    }
                }
            }

            return False
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

        say '== End of Round ', $round, ' ==';
        out;

        $lastRound = $round;
        last if $noMove == @elves.elems;
    }

    sub f($x, $y) of Bool {
        @elves.first({ $_{'x'} == $x && $_{'y'} == $y }) ~~ Nil
    }

    sub fnext($x, $y) of Bool {
        @elves.grep({ $_<xnext>:exists && $_<xnext> == $x
                    && $_{'ynext'} == $y }).elems == 1
    }

    sub out {
        my Int $xmin = [min] @elves.map({ $_{'x'} });
        my Int $xmax = [max] @elves.map({ $_{'x'} });
        my Int $ymin = [min] @elves.map({ $_{'y'} });
        my Int $ymax = [max] @elves.map({ $_{'y'} });

        for [$ymin ... $ymax] -> $y {
            my $line = '';
            for [$xmin ... $xmax] -> $x {
                $line ~= f($x, $y) ?? '.' !! '#'
            }
            say $line
        }
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
say 'p1 took: ', ($now - INIT now).round(0.1), 's'; # 647.5s (on battery)

is do('input.test', 25, True), 20, 'p2 test';
#`{
    my $res = do('input', 9999999, True);
    say 'p2 = ', $res;
    is $res, 0, 'p2';
}

say 'p2 took: ', (now - $now).round(0.1), 's'; #~700s
