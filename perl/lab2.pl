use 5.20.0;
use strict; 
do './Query.pm';

sub SlashSlash
{
	my $obj = shift;
	if ($obj->{QueryHHTP} =~ / \/\/ /)
	{
		return 1;
	}
	return 0;
}

sub BackToGodhead
{
	my $obj = shift;
	if ($obj->{UserAgent} eq "-")
	{
		return 1;
	}
	return 0;
}

sub EtoHex
{
	my $obj = shift;
	if (($obj->{QueryHHTP} =~ /\\x[0-9A-F]/g) or ($obj->{Reference} =~ /\\x[0-9A-F]/g))
	{
		return 1;
	}
	return 0;
}

sub QuQu
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

sub MainPhp
{
	my $obj = shift;
	if ($obj->{QueryHHTP} =~ /main\.php/)
	{
		return 1;
	}
	return 0;
}

sub AdminRights
{
	my $obj = shift;
	if (lc $obj->{QueryHHTP} =~ /admin[^a-zA-Z]/)
	{
		return 1;
	}
	return 0;
}

sub PhpSetup
{
	my $obj = shift;
	if (lc $obj->{QueryHHTP} =~ /setup\.php/)
	{
		return 1;
	}
	return 0;
}

sub NoSQL
{
	my $obj = shift;
	if (lc $obj->{QueryHHTP} =~ /sql/)
	{
		return 1;
	}
	return 0;
}

sub CookieQuery
{
	my $obj = shift;
	if ($obj->{QueryHHTP} =~ /cookie/)
	{
		return 1;
	}
	return 0;
}

sub Symbols
{
	my $obj = shift;
	if ($obj->{QueryHHTP} =~ /[,$~]+/)
	{
		return 1;
	}
	return 0;
}

sub BlackHole
{
	my $obj = shift;
	if ($obj->{QueryHHTP} eq "")
	{
		return 1;
	}
	return 0;
}

sub CheckQuery
{
	my $obj = shift;
	my %ranks = %{shift()};
	
	
	if (SlashSlash $obj)
	{
		push @{$obj->{ListOfAttributes}}, "SlashSlash";
		$obj->{Rank} += $ranks{"SlashSlash"};
	}
	
	if (BackToGodhead $obj)
	{
		push @{$obj->{ListOfAttributes}}, "BackToGodhead";
		$obj->{Rank} += $ranks{"BackToGodhead"};
	}
	
	if (EtoHex $obj)
	{
		push @{$obj->{ListOfAttributes}}, "EtoHex";
		$obj->{Rank} += $ranks{"EtoHex"};
	}
	
	if (QuQu $obj)
	{
		push @{$obj->{ListOfAttributes}}, "QuQu";
		$obj->{Rank} += $ranks{"QuQu"};
	}
	
	if (MainPhp $obj)
	{
		push @{$obj->{ListOfAttributes}}, "MainPhp";
		$obj->{Rank} += $ranks{"MainPhp"};
	}
	
	if (AdminRights $obj)
	{
		push @{$obj->{ListOfAttributes}}, "AdminRights";
		$obj->{Rank} += $ranks{"AdminRights"};
	}
	
	if (PhpSetup $obj)
	{
		push @{$obj->{ListOfAttributes}}, "PhpSetup";
		$obj->{Rank} += $ranks{"PhpSetup"};
	}
	
	if (NoSQL $obj)
	{
		push @{$obj->{ListOfAttributes}}, "NoSQL";
		$obj->{Rank} += $ranks{"NoSQL"};
	}
	
	if (CookieQuery $obj)
	{
		push @{$obj->{ListOfAttributes}}, "CookieQuery";
		$obj->{Rank} += $ranks{"CookieQuery"};
	}
	
	if (Symbols $obj)
	{
		push @{$obj->{ListOfAttributes}}, "Symbols";
		$obj->{Rank} += $ranks{"Symbols"};
	}
	
	if (BlackHole $obj)
	{
		push @{$obj->{ListOfAttributes}}, "BlackHole";
		$obj->{Rank} += $ranks{"BlackHole"};
	}
}

my %Ranks = (
			'AdminRights' => 6,
			'CookieQuery' => 7,
			'QuQu' => 10,
			'SlashSlash' => 2,
			'BackToGodhead' => 11,
			'EtoHex' => 9,
			'NoSQL' => 5,
			'PhpSetup' => 3,
			'Symbols' => 8,
			'MainPhp' => 4,
			'BlackHole' => 1,
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
		say "CANT OPEN - ALLAH AKBAR $file";
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

say "Thank you for attention - OM NOM NOM";


