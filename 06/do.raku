use v6.d;
use Test;

#https://adventofcode.com/2022/day/6

sub do (Str $fname, $n) {
    my Int $pos;

    my $line = $fname.IO.lines.first;
    my @m;
    for $line.comb {
        $pos++;
        @m.push($_);
        if @m.elems > $n {
            @m.splice(0, 1)
        }
        if @m.elems == $n && isDupeFree(@m) {
            return $pos
        }
    }
}

sub isDupeFree(@arr) {
    for @arr {
        if count(@arr, $_) > 1 {
            return False
        }
    }
    return True
}

sub count(@arr, $e) {
    my $ret;
    for @arr {
        if $_ eq $e {
            $ret++
        }
    }
    $ret
}

my $p1n = 4;

is do('input.test.1', $p1n), 7, 'p1 test1';
is do('input.test.2', $p1n), 5, 'p1 test2';
is do('input.test.3', $p1n), 6, 'p1 test3';
is do('input.test.4', $p1n), 10, 'p1 test4';
is do('input.test.5', $p1n), 11, 'p1 test5';
{
    my $res = do('input', $p1n);
    say 'p1 = ', $res;
    is $res, 1566, 'p1';
}

my $p2n = 14;

is do('input.test.1', $p2n), 19, 'p2 test1';
is do('input.test.2', $p2n), 23, 'p2 test2';
is do('input.test.3', $p2n), 23, 'p2 test3';
is do('input.test.4', $p2n), 29, 'p2 test4';
is do('input.test.5', $p2n), 26, 'p2 test5';
{
    my $res = do('input', $p2n);
    say 'p2 = ', $res;
    is $res, 2265, 'p2';
}
