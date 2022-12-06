use v6.d;
use Test;

#https://adventofcode.com/2022/day/2

# rock = A/X = 1
# paper = B/Y = 2
# scissors = C/Z = 3

my %myScore = X => 1, Y => 2, Z => 3;

constant WIN = 6;
constant DRAW = 3;
constant LOOSE = 0;

# rock < paper < scissors < rock
my %roundScore =
        A => { X => DRAW,  Y => WIN,   Z => LOOSE },
        B => { X => LOOSE, Y => DRAW,  Z => WIN   },
        C => { X => WIN,   Y => LOOSE, Z => DRAW  };

sub do ($fname, &chooseMy) {
    my Int $score;

    for $fname.IO.lines -> $line {
        my @words = $line.words;
        my $other = @words[0];

        my $my = &chooseMy($other, @words[1]);

        $score += %myScore{$my} + %roundScore{$other}{$my}
    }

    $score
}

sub chooseMyP1 ($_, $in) { $in } # in is what to do

is do('input.test', &chooseMyP1), 15, 'p1 test';
{
    my $res = do('input', &chooseMyP1);
    say 'p1 = ', $res;
    is $res, 10624, 'p1';
}

my %i2a = X => LOOSE, Y => DRAW, Z => WIN;

sub chooseMyP2 ($other, $in) { # in is what to achieve
    my $toAchieve = %i2a{$in};
    for %roundScore{$other}.kv -> $action, $result {
        if $result == $toAchieve {
            return $action
        }
    }
}

is do('input.test', &chooseMyP2), 12, 'p2 test';
{
    my $res = do('input', &chooseMyP2);
    say 'p2 = ', $res;
    is $res, 14060, 'p2';
}
