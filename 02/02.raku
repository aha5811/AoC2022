use v6.d;
use Test;

# rock < paper < scissors < rock
# rock = A = X = 1
# paper = B = Y = 2
# scissors = C = Z = 3
# lost = 0, draw = 3, win = 6

my %reactionS = 'X' => 1, 'Y' => 2, 'Z' => 3;

my %roundS = 'A' => { 'X' => 3, 'Y' => 6, 'Z' => 0 },
          'B' => { 'X' => 0, 'Y' => 3, 'Z' => 6 },
          'C' => { 'X' => 6, 'Y' => 0, 'Z' => 3 };

sub do02 ($fname, &chooseMy) {
    my @lines = $fname.IO.lines;

    my Int $score = 0;

    for @lines -> $line {

        my @words = $line.words;
        my $other = @words[0];
        my $my = &chooseMy(@words[1], $other);
        $score += %reactionS{$my} + %roundS{$other}{$my};

    }

    return $score;
}

sub chooseMy_1($in, $_) {
    return $in;
}

is do02('02/02.input.test', &chooseMy_1), 15;
say do02('02/02.input', &chooseMy_1); #10624

# X = loose, Y = draw, Z = win

my %strat = 'A' => { 'X' => 'Z', 'Y' => 'X', 'Z' => 'Y' },
          'B' => { 'X' => 'X', 'Y' => 'Y', 'Z' => 'Z' },
          'C' => { 'X' => 'Y', 'Y' => 'Z', 'Z' => 'X' };

sub chooseMy_2($in, $other) {
    return %strat{$other}{$in};
}

is do02('02/02.input.test', &chooseMy_2), 12;
say do02('02/02.input', &chooseMy_2); #14060
