use v6.d;
use Test;

#https://adventofcode.com/2022/day/19

my Int $p1mins = 24;

sub do (Str $fname, Bool $verbose = False) {

    my @blueprints;
    for $fname.IO.lines {
        my %bp;
        my $l = $_.substr($_.index(':') + 1)
                .subst(/Each/, '', :g)
                .subst(/robot/, '', :g)
                .subst(/costs/, '', :g)
                .subst(/and/, '', :g); # type n mineral (n mineral)*
        for $l.split('.') {
            my @words = $_.words;
            if @words.elems == 0 { next }
            my Int $w = 0;
            my %costs;
            %bp{@words[$w++]} = %costs;
            loop {
                my $type = @words[$w + 1];
                my $amnt = +@words[$w];
                %costs{$type} = $amnt;
                $w += 2;
                last if $w == @words.elems
            }
        }
        @blueprints.push($%bp)
    }

    my Str @minerals = 'geode', 'obsidian', 'clay', 'ore';

    my Int $qlsum = 0;
    my Int $bpcnt = 1;
    for @blueprints -> %bp {

        my %robots;
        my %wares;
        for @minerals -> $m {
            %robots{$m} = 0;
            %wares{$m} = 0;
        }
        %robots{'ore'}++;

        for [1...$p1mins] {
            if $verbose { say '== Minute ', $_, ' ==' }

            my %newRobots;
            for @minerals -> $m {

                # TODO
                # better decision making

                my %costs = %bp{$m};
                if [&&] %costs.kv.map({ %wares{$^a} >= $^b }) {
                    if $verbose {
                        my $cost = join ' and ', %costs.kv.map({ $^b ~ ' ' ~ $^a });
                        say 'Spend ', $cost, ' to start building a ',
                                $m, '-collecting robot.';
                    }
                    for %costs.kv -> $am, $n { %wares{$am} -= $n }
                    %newRobots{$m}++
                }
            }

            # existing robots add wares
            for @minerals -> $m {
                my $producers = %robots{$m};
                if $producers > 0 {
                    %wares{$m} += $producers;
                    if $verbose {
                        say $producers, ' ', $m, ' collecting robots collect ',
                                $producers, '; you now have ', %wares{$m}, ' ', $m;
                    }
                }
            }

            # robots are built
            for %newRobots.kv -> $k, $v {
                %robots{$k} += $v;
                if $verbose {
                    say 'The new ', $k, '-collecting robot is ready;',
                            ' you now have ', %robots{$k}, ' of them.'
                }
            }

            if $verbose { say '' }
        }

        $qlsum += %wares{'geode'} * $bpcnt++
    }

    $qlsum
}

is do('input.test', True), 33, 'p1 test'; # fails
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
