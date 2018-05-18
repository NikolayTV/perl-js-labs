use 5.20.0;
use strict;

my %ips;


open(my $FILE,"<", "access.log") or die uc "\nALLAHU AKBAR !!!";


say "\nHERE IS YOUR IP MY LORD:\n";


while (my $ip = <$FILE>) {
	if( $ip =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/)
		{$ips{$1} += 1;}}
	my $q = 0;
	foreach my $ip (sort {$ips{$b} <=> $ips{$a} } keys %ips) {
	    print "$ip = $ips{$ip} \n ";
	    ++$q;
	    if ($q == 10){
	   		last;
 	}
 }
 
close ($FILE);


