use v6.d;
use Test;

#https://adventofcode.com/2022/day/18

sub do (Str $fname) {

    # TODO

    0;
}

is do('input.test0'), 10, 'p1 test';
is do('input.test'), 64, 'p1 test';
#`{
    my $res = do('input');
    say 'p1 = ', $res;
    is $res, 0, 'p1';
}

#is do('input.test'), 0, 'p2 test';
#`{
    my $res = do('input');
    say 'p2 = ', $res;
    is $res, 0, 'p2';
}
