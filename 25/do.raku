use v6.d;
use Test;

#https://adventofcode.com/2022/day/

sub do (Str $fname) {
    my $sum = [+] $fname.IO.lines.map({ .&s2i });
    say ' sum is ', $sum;
    i2s($sum)
}

sub s2i(Str $s) of Int {
    sub r(Int $p, Str $x) of Int {
        my Int $m;
        given $x {
            when '=' { $m = -2 }
            when '-' { $m = -1 }
            default { $m = +$x }
        }
        5 ** $p * $m
    }
    [+] $s.comb.reverse.kv.map({ r($^a, $^b) })
}

#`{
    for 's2i.test'.IO.lines {
        my @w = $_.words;
        is s2i(@w[0]), @w[1]
    }
}

sub i2s(Int $i) of Str {

    # find biggest factor
    my Int $maxPot = 0;
    loop {
        last if 5 ** $maxPot * 3 > $i;
        $maxPot++;
    }

    my Str $s = '';
    my Int $x = $i;

    for [$maxPot ... 0] -> $p {
        my $b = 5 ** $p;

        my Int $bx = 0;
        for [^$p] { $bx += 2 * 5 ** $_ }

        if $x >= 2 * $b - $bx {
            $s ~= '2';
            $x -= 2 * $b;
        } elsif $x >= 1 * $b - $bx {
            $s ~= '1';
            $x -= 1 * $b;
        } elsif $x <= -2 * $b + $bx {
            $s ~= '=';
            $x += 2 * $b;
        } elsif $x <= -1 * $b + $bx {
            $s ~= '-';
            $x += 1 * $b;
        } else {
            $s ~= '0'
        }
    }

    $s
}

{
    for 'i2s.test'.IO.lines {
        my @w = $_.words;
        is i2s(+@w[0]), @w[1], @w[0] ~ ' ~ ' ~ @w[1]
    }
}

is do('input.test'), '2=-1=0', 'p1 test';
{
    my $res = do('input');
    say 'p1 = ', $res;
    is $res, '2==0=0===02--210---1', 'p1';
}
