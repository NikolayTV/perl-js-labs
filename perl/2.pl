use 5.20.0;
use strict; 
use warnings FATAL => "all";
do './Query.pm';

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


sub DoubleSlash
{
	my $obj = shift;
	if ($obj->{HTTPQuery} =~ / \/\/ /)
	{
		return 1;
	}
	return 0;
}

sub FromNowhere
{
	my $obj = shift;
	if ($obj->{UserAgent} eq "-")
	{
		return 1;
	}
	return 0;
}

sub HexChars
{
	my $obj = shift;
	if (($obj->{HTTPQuery} =~ /\\x[0-9A-F]/g) or ($obj->{Reference} =~ /\\x[0-9A-F]/g))
	{
		return 1;
	}
	return 0;
}

sub DontSmilePls
{
	my $obj = shift;
	my @q = split "", $obj->{Original};
	my $opened = 0;
	foreach my $i (@q)
	{
		if ($i eq "(")
		{
			$opened++;
			next;
		}
		if ($i eq")")
		{
			if ($opened == 0)
			{
				return 1;
			}
			$opened--;
		}
	}
	return 0;
}

sub TakeMyMain
{
	my $obj = shift;
	if ($obj->{HTTPQuery} =~ /main\.php/)
	{
		return 1;
	}
	return 0;
}

sub BeAdmin
{
	my $obj = shift;
	if (lc $obj->{HTTPQuery} =~ /admin[^a-zA-Z]/)
	{
		return 1;
	}
	return 0;
}

sub SetupMe
{
	my $obj = shift;
	if (lc $obj->{HTTPQuery} =~ /setup\.php/)
	{
		return 1;
	}
	return 0;
}

sub NoSQLPls
{
	my $obj = shift;
	if (lc $obj->{HTTPQuery} =~ /sql/)
	{
		return 1;
	}
	return 0;
}

sub COOKIEOMNOMNOM
{
	my $obj = shift;
	if ($obj->{HTTPQuery} =~ /cookie/)
	{
		return 1;
	}
	return 0;
}

sub StrangeChars
{
	my $obj = shift;
	if ($obj->{HTTPQuery} =~ /[,$~]+/)
	{
		return 1;
	}
	return 0;
}

sub YouSoEmpty
{
	my $obj = shift;
	if ($obj->{HTTPQuery} eq "")
	{
		return 1;
	}
	return 0;
}

sub CheckQuery
{
	my $obj = shift;
	my %ranks = %{shift()};
	
	
	if (DoubleSlash $obj)
	{
		push @{$obj->{ListOfAttributes}}, "DoubleSlash";
		$obj->{Rank} += $ranks{"DoubleSlash"};
	}
	
	if (FromNowhere $obj)
	{
		push @{$obj->{ListOfAttributes}}, "FromNowhere";
		$obj->{Rank} += $ranks{"FromNowhere"};
	}
	
	if (HexChars $obj)
	{
		push @{$obj->{ListOfAttributes}}, "HexChars";
		$obj->{Rank} += $ranks{"HexChars"};
	}
	
	if (DontSmilePls $obj)
	{
		push @{$obj->{ListOfAttributes}}, "DontSmilePls";
		$obj->{Rank} += $ranks{"DontSmilePls"};
	}
	
	if (TakeMyMain $obj)
	{
		push @{$obj->{ListOfAttributes}}, "TakeMyMain";
		$obj->{Rank} += $ranks{"TakeMyMain"};
	}
	
	if (BeAdmin $obj)
	{
		push @{$obj->{ListOfAttributes}}, "BeAdmin";
		$obj->{Rank} += $ranks{"BeAdmin"};
	}
	
	if (SetupMe $obj)
	{
		push @{$obj->{ListOfAttributes}}, "SetupMe";
		$obj->{Rank} += $ranks{"SetupMe"};
	}
	
	if (NoSQLPls $obj)
	{
		push @{$obj->{ListOfAttributes}}, "NoSQLPls";
		$obj->{Rank} += $ranks{"NoSQLPls"};
	}
	
	if (COOKIEOMNOMNOM $obj)
	{
		push @{$obj->{ListOfAttributes}}, "COOKIEOMNOMNOM";
		$obj->{Rank} += $ranks{"COOKIEOMNOMNOM"};
	}
	
	if (StrangeChars $obj)
	{
		push @{$obj->{ListOfAttributes}}, "StrangeChars";
		$obj->{Rank} += $ranks{"StrangeChars"};
	}
	
	if (YouSoEmpty $obj)
	{
		push @{$obj->{ListOfAttributes}}, "YouSoEmpty";
		$obj->{Rank} += $ranks{"YouSoEmpty"};
	}
}

my %Ranks = (
			'BeAdmin' => 6,
			'COOKIEOMNOMNOM' => 7,
			'DontSmilePls' => 10,
			'DoubleSlash' => 2,
			'FromNowhere' => 11,
			'HexChars' => 9,
			'NoSQLPls' => 5,
			'SetupMe' => 3,
			'StrangeChars' => 8,
			'TakeMyMain' => 4,
			'YouSoEmpty' => 1,
);



my @filelist = <access.log>;

my @loglist;


foreach my $file (@filelist)
{
	
	if (not ($file =~ /gz/))
	{
		push @loglist, $file;
	}
}

undef @filelist;

#push @loglist, "access.log";

my @qlist;


say 0 + @loglist;

say %Ranks;


foreach my $file (@loglist)
{
	say "open $file";
	if (open (my $FIN, '<:encoding(UTF-8)', $file))
	{
		while (my $s = <$FIN>)
		{
			chomp $s;
			push @qlist, Query->new($s);
		}
	}
	else
	{
		say "CANT OPEN $file";
	}
}

say 0 + @qlist." Total";

my @suspect;

foreach my $i (@qlist)
{	
	
	CheckQuery $i, \%Ranks;
	##$i->PrintAll;
	if (0 + @{$i->{ListOfAttributes}} > 1)
	{
		push @suspect, $i;
	}
}

say 0 + @suspect." Suspected";

my @sortedsuspect = sort{$a->{Rank} <=> $b->{Rank}} @suspect;

for (my $i = 1; $i < 51; $i++)
{
	say "oh my GODs $i";
	$sortedsuspect[-$i]->PrintAll;
}

say "I SAID GOOD DAY SIR";


