use v6.d;
use Test;

#https://adventofcode.com/2022/day/11

sub do (Str $fname, Int $rounds, Bool $forP2) {

    my @monkeys;

    my %m = activity => 0;
    for $fname.IO.lines {
        my @words = $_.words;
        given @words[0] {
            when 'Monkey' {
                if @words[1] !eq '0:' {
                    @monkeys.push(%m);
                    %m := { activity => 0 }
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
                else { %m<f> = $t } # false:
            }
        }
    }
    @monkeys.push(%m);

    my Int $mod;
    if $forP2 { $mod = [*] @monkeys.map({ $_<mod> }) }

    for [1...$rounds] {
        for @monkeys -> %m {
            while %m<items> {
                # takes item
                my $i = %m<items>.shift;

                # worry level changes
                $i = EVAL(%m<op>.subst('old', $i, :g));

                #inspects item
                %m<activity>++;

                # worry level decreases / worry level stays manageable
                $i = !$forP2 ?? floor($i / 3) !! $i % $mod;

                # chooses new target
                my $t = $i % %m<mod> == 0 ?? %m<t> !! %m<f>;

                # throws item
                @monkeys[$t]<items>.push($i);
            }
        }
    }

    # multiply activity of two most active monkeys
    [*] @monkeys.map({ $_<activity> }).sort.reverse[^2]
}

my Int $p1rounds = 20;
my Bool $p1forP2 = False;

my $time = now;

is do('input.test', $p1rounds, $p1forP2), 10605, 'p1 test';

say 'p1 test took ', (now - $time).round(0.1), 's';
$time = now;

{
    my $res = do('input', $p1rounds, $p1forP2);
    say 'p1 = ', $res;
    is $res, 119715, 'p1';
}

say 'p1 took ', (now - $time).round(0.1), 's';
$time = now;

my Int $p2rounds = 10000;
my Bool $p2forP2 = True;

is do('input.test', $p2rounds, $p2forP2), 2713310158, 'p2 test';

say 'p2 test took: ', (now - $time).round(0.1), 's';
$time = now;

{
    my $res = do('input', $p2rounds, $p2forP2);
    say 'p2 = ', $res;
    is $res, 18085004878, 'p2';
}

say 'p2 took: ', (now - $time).round(0.1), 's';
