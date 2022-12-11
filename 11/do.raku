use v6.d;
use Test;

#https://adventofcode.com/2022/day/

sub do (Str $fname) {

    my @monkeys;

    my %m = i => 0;
    for $fname.IO.lines {
        my @words = $_.words;
        given @words[0] {
            when 'Monkey' {
                if @words[1] !eq '0:' {
                    @monkeys.push(%m);
                    %m := { i => 0 }
                }
            }
            when 'Starting' {
                %m<items> = ((@words.splice: 2, *).map({ +($_.subst(',','')) })).Array
            }
            when 'Operation:' { %m<op> = @words[3]~@words[4]~@words[5] }
            when 'Test:' { %m<mod> = @words[3] }
            when 'If' {
                my Int $t = +@words[5];
                if (@words[1] eq 'true:') { %m<t> = $t }
                else { %m<f> = $t }
            }
        }
    }
    @monkeys.push(%m);

    for [1...20] {
        for @monkeys -> %m {
            while %m<items> {
                %m<i>++;
                my $i = %m<items>.shift;
                my $op = %m<op>.subst('old', $i, :g);
                $i = EVAL($op);
                $i = floor($i / 3);
                my $t = $i % %m<mod> == 0 ?? %m<t> !! %m<f>;
                @monkeys[$t]<items>.push($i);
            }
        }
    }

    [*] @monkeys.map({ $_<i> }).sort.reverse[^2]
}

is do('input.test'), 10605, 'p1 test';
{
    my $res = do('input');
    say 'p1 = ', $res;
    is $res, 119715, 'p1';
}
#`[
is do('input.test'), 0, 'p2 test';
{
    my $res = do('input');
    say 'p2 = ', $res;
    is $res, 0, 'p2';
}
]