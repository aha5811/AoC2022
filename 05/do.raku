use v6.d;
use Test;

#https://adventofcode.com/2022/day/5

sub do (Str $fname, &doMove) {

    my @stacksConfigLines;
    my @moves;

    {
        my $moveRex = rx/"move "(\d+)" from "(\d+)" to "(\d+)/;

        my &toMove = -> $line {
            my @groups = ($line ~~ $moveRex).values;
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
    my $nOfStacks = [max] @stacksConfigLines.pop.split(' ');

    my @stacks[$nOfStacks];
    {
        my $rex = rx/(\s ** 3 | \[\S\])[\s(\s ** 3 | \[\S\])]*/;
        # ___|[X]_...
        while @stacksConfigLines {
            my $pos = 0;
            for (@stacksConfigLines.pop ~~ $rex).values -> $s {
                if ($s.trim !eq "") {
                    my $crate = $s.substr(1, 1);
                    @stacks[$pos].push($crate);
                }
                $pos++
            }
        }
    }

    for @moves -> %move { &doMove(@stacks, %move) }

    [~] @stacks.map(-> @_ { @_[@_.end] })
    # join topmost (last) element of each stack
}

sub doMoveP1 (@stacks, %m) {
    for ^%m<n> {
        my $crate = @stacks[%m<from>].pop;
        @stacks[%m<to>].push($crate);
    }
}

is do('input.test', &doMoveP1), 'CMZ';
say do('input', &doMoveP1); #VCTFTJQCG

sub doMoveP2 (@stacks, %m) {
    my @grabStack;
    for ^%m<n> {
        my $crate = @stacks[%m<from>].pop;
        @grabStack.push($crate);
    }
    while @grabStack {
        my $crate = @grabStack.pop;
        @stacks[%m<to>].push($crate);
    }
}

is do('input.test', &doMoveP2), 'MCD';
say do('input', &doMoveP2); #GCFGLDNJZ

