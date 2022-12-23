use v6.d;
use Test;

#https://adventofcode.com/2022/day/17

#`[

####

.#.
###
.#.

..#
..#
###

#
#
#
#

##
##

]

my $p1width = 7;
my $p1dropYspace = 3;
my $p1dropXspace = 2;
my $p1rocks = 2022;

sub do (Str $fname) {

    # TODO

    0;
}

is do('input.test'), 3068, 'p1 test';
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
