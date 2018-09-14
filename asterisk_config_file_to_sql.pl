#
# @Author: Gaël Barbier
# @Date:   2018-09-14 16:41:14
# @Last Modified by:   Gaël Barbier
# @Last Modified time: 2018-09-14 17:47:08
#

#!/usr/bin/perl
use Asterisk::config;
use File::Basename;

# Pass to 1 to print debug
my $debug =		0;
my $rc =		new Asterisk::config(file=>$ARGV[0]);
my $file =		basename($ARGV[0]);
my $cat_count =	0;

$parsed = $rc->fetch_sections_hashref();
foreach my $sec (sort keys %{$parsed})
{
    $var_count=1;
	print "Category = $sec\n" if $debug;
    while ( my ($c, $v) = each(%{$parsed->{$sec}}) )
    {
		foreach my $values (@{$v})
		{
		    print "filename=$file cat_metric=$cat_count var_metric=$var_count category=$sec var_name=$c var_val=$values\n" if $debug;
			print "INSERT INTO ast_config (cat_metric, var_metric, filename, category, var_name, var_val) VALUES ($cat_count $var_count $file $sec $c $values);\n";
			$var_count++;
		}
    }
    $cat_count++;
}