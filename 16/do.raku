use v6.d;
use Test;

#https://adventofcode.com/2022/day/16

sub do (Str $fname) {

    my %r;
    my @tunnels;

    for $fname.IO.lines {
        my @w = $_.substr(1).subst(/ <lower> || \= || \; || \, /, '', :g).words;
        my $v = @w.shift;
        %r{$v} = +@w.shift;
        for @w { @tunnels.push($v~'-'~$_) }
    }

    say %r;
    say @tunnels;

    # remove all 0 values
    # use a* to find shortes paths between all remaining valves
    # start at start
    # greedy:
    #  compare nodes by valve yield after travelling (length of path)

    0;
}

sub next(@tunnels, $v) {
    @tunnels.map({ $_.split('-').values[0] eq $v }).map({ })
}

is do('input.test'), 1651, 'p1 test';
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
