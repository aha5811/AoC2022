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

is do('input.test.1', 4), 7, 'p1 test1';
is do('input.test.2', 4), 5, 'p1 test2';
is do('input.test.3', 4), 6, 'p1 test3';
is do('input.test.4', 4), 10, 'p1 test4';
is do('input.test.5', 4), 11, 'p1 test5';
{
    my $res = do('input', 4);
    say 'p1 = ', $res;
    is $res, 1566, 'p1';
}

is do('input.test.1', 14), 19, 'p2 test1';
is do('input.test.2', 14), 23, 'p2 test2';
is do('input.test.3', 14), 23, 'p2 test3';
is do('input.test.4', 14), 29, 'p2 test4';
is do('input.test.5', 14), 26, 'p2 test5';
{
    my $res = do('input', 14);
    say 'p2 = ', $res;
    is $res, 2265, 'p2';
}
