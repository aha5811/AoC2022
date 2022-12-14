use v6.d;
use Test;
use JSON::Tiny;

#https://adventofcode.com/2022/day/13

sub doP1 (Str $fname) {

    my $first;
    my $second;
    my $gotFirst = False;

    my @correctPs;

    my Int $p;
    for $fname.IO.lines {
        if $_ !eq '' {
            if !$gotFirst {
                $first = parse($_);
                $gotFirst = True;
            } else {
                $second = parse($_);
                $p++;
                my $c = compare($first, $second);
                #say $one, ' cmp ', $two, ': ', $c;
                if $c == Order::Less { @correctPs.push($p) }
                $gotFirst = False;
            }
        }
    }

    [+] @correctPs
}

sub parse($s) of Array { from-json $s }

sub compare($first, $second) {
    if $first ~~ Int && $second ~~ Int {
        return $first cmp $second
    }
    my $one = toArray($first);
    my $two = toArray($second);
    my Int $i = 0;
    loop {
        if $one.elems == $i && $two.elems == $i {
            return Order::Same
        } elsif $one.elems == $i {
            return Order::Less
        } elsif $two.elems == $i {
            return Order::More
        } else {
            my $ret = compare($one[$i], $two[$i]);
            if $ret !== Order::Same {
                return $ret
            }
        }
        $i++
    }
}

sub toArray($x) {
    if $x !~~ Array {
        my $ret = Array.new;
        if $x ~~ Int {
            $ret.push($x);
        }
        return $ret;
    }
    $x
}

is doP1('input.test'), 13, 'p1 test';
{
    my $res = doP1('input');
    say 'p1 = ', $res;
    is $res, 5625, 'p1';
}

sub doP2 (Str $fname) {

    my $first = parse('[[2]]');
    my $second = parse('[[6]]');

    my @a = [ $first, $second ];

    for $fname.IO.lines {
        if $_ !eq '' {
            @a.push(parse($_));
        }
    }

    @a = @a.sort(&compare);

    (@a.first($first, :k) + 1) * (@a.first($second, :k) + 1)
}

is doP2('input.test'), 140, 'p2 test';
{
    my $res = doP2('input');
    say 'p2 = ', $res;
    is $res, 23111, 'p2';
}

#`[
grammar L {
    token TOP { <l> }
    token l { '[' <es> ']' }
    token es { <e>+ % ',' }
    token e { <l> | <n> }
    token n { \d+ }
}

class Lx {
    method TOP ($/) { make $<l>.made }
    method l ($/) { make Array.new($<es>.made) }
    method es ($/) { make $<e>.map({ .made }) }
    method e ($/) { make $<l> ?? $<l>.made !! $<n>.made }
    method n ($/) { make +$/ }
}

sub parse($s) {
    say L.parse($s, actions => Lx).made
}
]
