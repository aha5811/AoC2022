use v6.d;
use Test;

#https://adventofcode.com/2022/day/21

my $root = 'root';

sub doP1 (Str $fname) {

    my %m = read($fname);

    simplify(%m);

    %m{$root}
}

sub read(Str $fname) {
    my %m;
    for $fname.IO.lines {
        my @t = $_.subst(/\s+/, '', :g).split(':');
        %m{@t[0]} = @t[1] ~~ /\d+/ ?? +@t[1] !! @t[1];
    }
    %m
}

my $rop = /\*||\/||\+||\-/;
my $ropPlus = /\*||\/||\+||\-||\=/;

sub simplify(%m) {
    my Int $lc = 0;
    loop {
        my Int $repl = 0;
        for %m.kv -> $k, $v {
            if $v !~~ Numeric {
                my $newV = $v;
                my @t = $v.split($ropPlus);
                for [0 ... 1] -> $i {
                    my $t = @t[$i];
                    if $t !~~ /\d+/ && %m{$t} ~~ Numeric {
                        $newV = $newV.subst($t, %m{$t})
                    }
                }
                if $newV !eq $v {
                    if $newV ~~ /\d+<$rop>\d+/ {
                        $newV = EVAL $newV
                    }
                    %m{$k} = $newV;
                    $repl++
                }
            }
        }
        $lc++;
        last if $repl == 0
    }
    say ' > simplify loop count: ', $lc
}

is doP1('input.test'), 152, 'p1 test';
{
    my $res = doP1('input');
    say 'p1 = ', $res;
    is $res, 158731561459602, 'p1';
}

my $now = now;
say 'p1 took: ', ($now - INIT now).round(0.1), 's';

my $p2todo = 'humn';

sub doP2 (Str $fname) {

    my %m = read($fname);

    %m{$root} = %m{$root}.subst($rop, '=');
    %m{$p2todo}:delete;

    simplify(%m);

    # we assume that all entries with non-numeric values have only one variable
    # they're either "abcd op n" or "n op abcd"

    my ($var, $val) = %m{$root}:delete.split('='); # abcd=n -> abcd n

    # remove all abcd => n entries
    for %m.kv -> $k, $v { if $v ~~ Numeric { %m{$k}:delete } }

    my Int $lc = 0;
    loop {
        my $right = %m{$var};

        # current $val = $right, which is  abcd op n or n op abcd

        my ($first, $op, $second) = $right.split($rop, :v);
        $op = $op.Str;

        my Bool $nFirst = ($first ~~ /\d+/).Bool;

        $var = $nFirst ?? $second !! $first;

        my Int $n = $nFirst ?? +$first !! +$second;

        given $op {
            when '+' { # x = abcd + n -> abcd = x - n
                $val = $val - $n;
            }
            when '-' {
                if $nFirst { # x = n - abcd -> abcd = n - x
                    $val = $n - $val;
                } else {  # x = abcd - n -> abcd = x + n
                    $val = $val + $n;
                }
            }
            when '*' { # x = abcd * n -> abcd = x / n
                $val = $val / $n;
            }
            when '/' {
                if $nFirst { # x = n / abcd -> abcd = n / x
                    $val = $n / $val;
                } else { # x = abcd / n -> abcd = x * n
                    $val = $val * $n;
                }
            }
        }
        $lc++;
        last if $var eq $p2todo
    }
    say ' > solving loop count: ', $lc;

    $val
}

is doP2('input.test'), 301, 'p2 test';
{
    my $res = doP2('input');
    say 'p2 = ', $res;
    is $res, 3769668716709, 'p2';
}

say 'p2 took: ', (now - $now).round(0.1), 's';
