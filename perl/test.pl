use 5.20.0;
use strict; 
use warnings FATAL => "all";

say "OW HELO";

my %HUEHUE;

open (my $FIN, '<:encoding(UTF-8)', "access.log") or die uc "unacceptable";

while (my $s = <$FIN>)
{
	$s = substr $s, 0, index $s, " ";
	
	$HUEHUE{$s}++;
	
}

my @sorted = reverse sort {$HUEHUE{$a} <=> $HUEHUE{$b}} keys %HUEHUE;


foreach my $i (@sorted)
{
	print"$i - $HUEHUE{$i}\n";
}

say "I SAID GOOD DAY SIR";