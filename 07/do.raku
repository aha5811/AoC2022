use v6.d;
use Test;

#https://adventofcode.com/2022/day/7

sub doP1 (Str $fname) {
    my %fs = readFS($fname);

    my @dirs = findDirs(%fs);

    my Int $ret;
    for @dirs {
        my $size = $_<S>;
        if $size <= 100000 {
            $ret += $size
        }
    }
    $ret
}

sub findDirs(%fs) {
    my @ret;
    for %fs.kv -> $k, $v {
        if ($k.lc eq $k && $v<D>) {
            @ret.append(findDirs($v))
        }
    }
    @ret.push(%fs);
    @ret
}

sub readFS (Str $fname) {
    my @lines = $fname.IO.lines;
    @lines = @lines.reverse;
    @lines.pop;
    # remove cd /

    my %fs = D => True, N => '/';
    my %t := %fs;

    while @lines {
        my @line = @lines.pop.words;
        my $first = @line[0];
        if $first eq "\$" {
            if @line[1] eq "cd" {
                my $to = @line[2];
                if $to eq ".." {
                    %t := %t<P>;
                } else {
                    %t := %t{$to};
                }
            }
            # ls is default action
        } else {
            my $n = @line[1];
            my %in = N => $n;
            %t.push: $n => %in;
            if $first eq "dir" {
                %in<D> = True;
                %in<P> = %t;
            } else {
                %in<S> = +$first;
            }
        }
    }

    get-set-size(%fs);

    %fs
}

sub get-set-size(%f) {
    if %f<S> {
        return %f<S>
    }

    my Int $size;
    for %f.kv -> $k, $v {
        if ($k.lc eq $k) {
            $size += get-set-size($v)
        }
    }
    %f<S> = $size
}

is doP1('input.test'), 95437, 'p1 test';
{
    my $res = doP1 ('input');
    say 'p1 = ', $res;
    is $res, 1915606, 'p1';
}

sub doP2(Str $fname) {
    my %fs = readFS($fname);

    my ($total, $needed) = 70000000, 30000000;
    my $free = $total - %fs<S>;
    $needed -= $free;

    my @dirs = findDirs(%fs);

    my @okDirs;
    for @dirs {
        if $_<S> >= $needed {
            @okDirs.push($_<S>)
        }
    }

    [min] @okDirs
}

is doP2('input.test'), 24933642, 'p2 test';
{
    my $res = doP2 ('input');
    say 'p2 = ', $res;
    is $res, 5025657, 'p2';
}
