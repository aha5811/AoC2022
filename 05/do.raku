use v6.d;
use Test;

#https://adventofcode.com/2022/day/5

sub do (Str $fname, &doMove) {

    my @stacksConfigLines;
    my @moves;

    {
        my $moveRex = / 'move ' (\d+) ' from ' (\d+) ' to ' (\d+) /;

        my &toMove = {
            my @groups = ($_ ~~ $moveRex).values;
            { n => @groups[0], from => @groups[1] - 1, to => @groups[2] - 1 }
        }

        for $fname.IO.lines -> $line {
            if $line eq '' {
                #
            } elsif $line.match($moveRex) {
                @moves.push(&toMove($line))
            } else {
                @stacksConfigLines.push($line)
            }
        }
    }

    # 1 2 3 4 .. n
    my $nOfStacks = @stacksConfigLines.pop.words.reverse.first;

    my @stacks[$nOfStacks];
    {
        my $rex = / [ \s? (\s ** 3 | '['<:Lu>']') ]+ /; # ___ or [X]
        while @stacksConfigLines {
            my $pos = 0;
            for (@stacksConfigLines.pop ~~ $rex).values -> $s {
                if $s !~~ /^\s+$/ { # is not whitespace
                    my $crate = $s.substr(1, 1);
                    @stacks[$pos].push($crate);
                }
                $pos++
            }
        }
    }

    for @moves { &doMove(@stacks, $_) }

    [~] @stacks.map(-> @_ { @_[@_.end] })
    # join topmost (last) element of each stack
}

sub doMoveP1 (@stacks, %move) {
    for ^%move<n> {
        my $crate = @stacks[%move<from>].pop;
        @stacks[%move<to>].push($crate);
    }
}

is do('input.test', &doMoveP1), 'CMZ', 'p1 test';
{
    my $res = do('input', &doMoveP1);
    say 'p1 = ', $res;
    is $res, 'VCTFTJQCG', 'p1';
}

sub doMoveP2 (@stacks, %move) {
    my @grabStack;
    for ^%move<n> {
        my $crate = @stacks[%move<from>].pop;
        @grabStack.push($crate);
    }
    while @grabStack {
        my $crate = @grabStack.pop;
        @stacks[%move<to>].push($crate);
    }
}

is do('input.test', &doMoveP2), 'MCD', 'p2 test';
{
    my $res = do('input', &doMoveP2);
    say 'p2 = ', $res;
    is $res, 'GCFGLDNJZ', 'p2';
}
