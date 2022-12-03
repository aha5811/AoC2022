use v6.d;
use Test;

# rock = A/X = 1
# paper = B/Y = 2
# scissors = C/Z = 3

my %myScore = 'X' => 1, 'Y' => 2, 'Z' => 3;

constant WIN = 6;
constant DRAW = 3;
constant LOOSE = 0;

# rock < paper < scissors < rock
my %roundScore =
        'A' => { 'X' => DRAW,  'Y' => WIN,   'Z' => LOOSE },
        'B' => { 'X' => LOOSE, 'Y' => DRAW,  'Z' => WIN   },
        'C' => { 'X' => WIN,   'Y' => LOOSE, 'Z' => DRAW  };

sub do02 ($fname, &chooseMy) {
    my $score = 0;

    for $fname.IO.lines -> $line {
        my @words = $line.words;
        my $other = @words[0];

        my $my = &chooseMy($other, @words[1]);

        $score += %myScore{$my} + %roundScore{$other}{$my}
    }

    $score;
}

sub chooseMy_1($_, $in) { $in } # in is what to do

is do02('02.input.test', &chooseMy_1), 15;
say do02('02.input', &chooseMy_1); #10624

my %i2a = 'X' => LOOSE, 'Y' => DRAW, 'Z' => WIN;

sub chooseMy_2($other, $in) { # in is what to achieve
    my $toAchieve = %i2a{$in};
    for %roundScore{$other}.kv -> $action, $result {
        if ($result == $toAchieve) {
            return $action
        }
    }
}

is do02('02.input.test', &chooseMy_2), 12;
say do02('02.input', &chooseMy_2); #14060
