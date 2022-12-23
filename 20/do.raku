use v6.d;
use Test;

#https://adventofcode.com/2022/day/20

sub do (Str $fname, Int $dkey = 1, Int $times = 1, Int $verbosity = 0) {

    # the list we are changing
    my @list = Array.new;

    # a map to track positions of items
    my %ps;

    {
        my Int $p = 0;
        for $fname.IO.lines {
            @list.push(+$_ * $dkey);
            %ps{$p} = $p;
            $p := $p + 1;
        }
    }

    my Int $maxPos = @list.elems - 1;

    if $verbosity > 0 { say 'initial: ', @list }

    for [1...$times] -> $n {
        for [0 ... $maxPos] -> $k {
            my $p = %ps{$k};

            my $i = @list[$p];
            if $i == 0 {
                if $verbosity > 1 {
                    say 'step ', $k + 1, ': ', $i, '@', $p, ' skipped'
                }
                next
            }

            # remove, compute new pos and insert
            @list.splice($p, 1);
            my $nextP = ($p + $i) % $maxPos;
            if $nextP == 0 { $nextP = $maxPos } # as per instructions
            @list.splice($nextP, 0, $i);

            if $verbosity > 1 {
                say 'step ', $k + 1, ': ', $i, '@', $p, ' -> ', $nextP;
                say ' -> ', @list;
            }

            # update positions in positions tracker
            for [0 ... $maxPos] {
                my $ip = %ps{$_};
                if $p < $nextP && $p < $ip <= $nextP {
                    %ps{$_} = %ps{$_} - 1
                } elsif $nextP < $p && $nextP <= $ip < $p {
                    %ps{$_} = %ps{$_} + 1
                }
            }
            %ps{$k} = $nextP;

            if $verbosity > 1 { say ' > ', %ps }
        }

        if $verbosity > 0 { say 'after round ', $n, ': ', @list }
    }

    my Int $pZero = @list.first(0, :k);

    [+] (
    @list[($pZero + 1000) % ($maxPos + 1)],
    @list[($pZero + 2000) % ($maxPos + 1)],
    @list[($pZero + 3000) % ($maxPos + 1)]
    )
}

is do('input.test', 1, 1, 2), 3, 'p1 test';
{
    my $res = do('input');
    say 'p1 = ', $res;
    is $res, 11073, 'p1';
}

my $now = now;
say 'p1 took: ', ($now - INIT now).round(0.1), 's'; #~70s

my $p2dkey = 811589153;
my $p2times = 10;

is do('input.test', $p2dkey, $p2times, 1), 1623178306, 'p2 test';
{
    my $res = do('input', $p2dkey, $p2times);
    say 'p2 = ', $res;
    is $res, 11102539613040, 'p2';
}

say 'p2 took: ', (now - $now).round(0.1), 's'; #~700s
