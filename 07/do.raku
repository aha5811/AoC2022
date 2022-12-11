use v6.d;
use Test;

#https://adventofcode.com/2022/day/7

sub readFS (Str $fname) {
    my @lines = $fname.IO.lines;
    @lines.shift; # remove cd /

    my %fs = :D; # = D => True

    #`[
    each file is a % with
        S -> size (initially only set for files)
        D -> True ("isDirectory", only set for directories)
        P -> parent directory (only set for directories)
    the contents of dirs are added as key-values like
        filename -> %
    root % is a dir without parent
    ]

    my %cd := %fs; # pointer to current dir

    while @lines {
        my @words = @lines.shift.words;
        my $first = @words[0];
        if $first eq "\$" {
            if @words[1] eq "cd" {
                my $to = @words[2];
                %cd := $to eq ".." ?? %cd<P> !! %cd{$to};
            } # else ... ls is default action
        } else {
            my $n = @words[1];
            %cd{$n} = my %f;
            if $first eq "dir" {
                %f<D> = True;
                %f<P> = %cd;
            } else { # size
                %f<S> = +$first;
            }
        }
    }

    compute-set-dir-sizes(%fs);

    %fs
}

sub compute-set-dir-sizes(%f) {
    if %f<S> {
        return %f<S>
    }

    my Int $size;
    for %f.kv -> $k, $v {
        if ($k.lc eq $k) { # key is filename
            $size += compute-set-dir-sizes($v)
        }
    }
    %f<S> = $size
}

sub getDirs(%dir) {
    my @ret;
    for %dir.kv -> $k, $v {
        if ($k.lc eq $k && $v<D>) { # key is filename and value is dir
            @ret.append(getDirs($v))
        }
    }
    @ret.push(%dir)
}

my $p1maxSize = 100000;

sub doP1 (Str $fname) {
    my %fs = readFS($fname);

    [+] getDirs(%fs).grep({ .<S> <= $p1maxSize }).map({ .<S> })
}

is doP1('input.test'), 95437, 'p1 test';
{
    my $res = doP1 ('input');
    say 'p1 = ', $res;
    is $res, 1915606, 'p1';
}

my ($p2total, $p2needed) = 70000000, 30000000;

sub doP2(Str $fname) {
    my %fs = readFS($fname);

    my $free = $p2total - %fs<S>;
    my $needed = $p2needed - $free;

    [min] getDirs(%fs).grep({ .<S> >= $needed }).map({ .<S> })
}

is doP2('input.test'), 24933642, 'p2 test';
{
    my $res = doP2 ('input');
    say 'p2 = ', $res;
    is $res, 5025657, 'p2';
}
