use v6.d;
use Test;

#https://adventofcode.com/2022/day/12

sub do (Str $fname, Bool $forP2 = False) {

    my Int $g = 'z'.ord - 'a'.ord + 1;

    # read input to height map
    my @map is Array;
    for $fname.IO.lines {
        @map.push(
            Array.new($_.comb.map({
                given $_ {
                    when 'S' { -1 }
                    when 'E' { $g }
                    default { .ord - 'a'.ord }
                }
            })))
    }
    my ($xMax, $yMax) = @map.elems, @map[0].elems; # dimensions

    my Str $start;
    my Str $goal;
    my @nodes;
    my @edges;
    my %h; # manhattan distance as heuristics

    sub height($x, $y) { @map[$x][$y] } # height for each point

    # find goal node, compute %h, find all nodes, find all edges
    {
        my @g;
        for [^$xMax] -> $x {
            for [^$yMax] -> $y {
                my $n = toN($x, $y);
                @nodes.push($n);
                addEdges($x, $y);
                if height($x, $y) == $g {
                    @g = ($x, $y);
                    $goal = $n;
                } elsif height($x, $y) == -1 {
                    $start = $n;
                }
            }
        }

        for [^$xMax] -> $x {
            for [^$yMax] -> $y {
                %h{toN($x, $y)} = dist($x, $y)
            }
        }

        sub dist($x, $y) { sqrt(($x - @g[0])**2 + ($y - @g[1])**2) }

        sub addEdges($x, $y) {
            my $h = height($x, $y);
            checkAdd($x - 1, $y);
            checkAdd($x + 1, $y);
            checkAdd($x, $y - 1);
            checkAdd($x, $y + 1);

            sub checkAdd($xx, $yy) {
                if $xx >= 0 && $xx < $xMax && $yy >= 0 && $yy < $yMax
                    && height($xx, $yy) <= $h + 1
                {
                    @edges.push([ toN($x, $y), toN($xx, $yy) ])
                }
            }
        }
    }

    sub toN($x, $y) of Str { $x~'x'~$y }

    #A*
    my @open;
    my @closed;

    @open.push($start);

    my %cost = $start => 0;
    my %parent;

    loop {

        last if @open.elems == 0;

        my $n = @open.shift;

        if $n eq $goal {
            next
        }

        @closed.push($n);

        my Bool $doSort = False;

        for getSucc($n) -> $c {

            if @closed.first($c).Bool { next }

            my $inOpen = @open.first($c).Bool;

            my $edgeCost = 1;
            if ($forP2) {
                # idea: edges between heights of 0-0 and -1-0 cost nothing
                # lucky? that it works although %h could overestimate the actual cost
                my ($nx, $ny) = $n.split('x').values;
                my ($sx, $sy) = $c.split('x').values;
                my $hn = height($nx, $ny);
                my $hs = height($sx, $sy);
                if ($hn == -1 && $hs == 0 || $hn == 0 && $hs == 0 || $hn == 0 && $hs == -1) {
                    $edgeCost = 0
                }
            }

            my $cCost = $edgeCost + %cost{$n};

            if $inOpen && $cCost >= %cost{$c} {
                next
            }

            %parent{$c} = $n;
            %cost{$c} = $cCost;
            if !$inOpen {
                @open.push($c);
                $doSort = True
            }
        }

        if $doSort {
            @open = @open.sort({ (%h{$^a} + %cost{$^a}) cmp (%h{$^b} + %cost{$^b}) })
        }
    }

    sub getSucc($n) {
        @edges.grep({ $_[0] eq $n }).map({ $_[1] })
    }

    # draw path on map
    my $n = $goal;
    loop {
        last if !%parent.EXISTS-KEY($n);
        my ($x, $y) = $n.split('x').values;
        @map[$x][$y] = '*';
        $n := %parent{$n};
    }

    out;

    sub out {
        say '';
        for [^$xMax] -> $x {
            my @ret;
            for [^$yMax] -> $y {
                my $v = @map[$x][$y].Str;
                if $v.chars == 1 { $v = ' '~$v }
                $v = ' '~$v;
                @ret.push($v)
            }
            say [~] @ret
        }
    }

    %cost{$goal}
}

is do('input.test'), 31, 'p1 test';
{
    my $res = do('input');
    say 'p1 = ', $res;
    is $res, 352, 'p1';
}

my $now = now;
say 'p1 took: ', ($now - INIT now).round(0.1), 's'; # ~24s

is do('input.test', True), 29, 'p2 test';
{
    my $res = do('input', True);
    say 'p2 = ', $res;
    is $res, 345, 'p2';
}

say 'p2 took: ', (now - $now).round(0.1), 's'; # ~24s
