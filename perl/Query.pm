package Query;

use strict;
use warnings;

sub new 
{
	my ($class) = shift;
	
	my $temp = shift;
	
	my @matches = $temp =~ /\"([^\"]*)\"/g;
	
	my $self = {
		Original => $temp,
		HTTPQuery => $matches[0],
		Reference => $matches[1], 
		UserAgent => $matches[2],
		ListOfAttributes => [],
		Rank => 0,
	};
	
	bless $self, $class;
	
	return $self;
}

sub PrintAll
{
	my $self = shift;
	print "QUERY = $self->{HTTPQuery}\nREFERENCE = $self->{Reference}\nUSER_AGENT = $self->{UserAgent}\nRANK = $self->{Rank}\nATTRIBUTES:";
	if (0 + @{$self->{ListOfAttributes}})
	{
		foreach my $i (@{$self->{ListOfAttributes}})
		{
			print "$i\t";
		}
		print "\n";
	}
	else
	{
		print "NONE\n";
	}
}