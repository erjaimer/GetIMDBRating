#!/usr/bin/perl -w
use strict;                     
use warnings; 
#########################################################################
#			USE						#
#########################################################################
#
#	Script Format:
#			imdbRatigAverage.pl  'fimlNameI' 'filmName2' ...
#
#	Depend to IMD no official API: http://imdbapi.org for more info.
#########################################################################
#			LIBRARY						#
#########################################################################
use JSON qw( decode_json );     # From CPAN                  
use URI::Escape;		# From CPAN
use WWW::Curl::Easy;		# From CPAN
#########################################################################
#			FUNCTIONS					#
#########################################################################
# Call to command unix GET.
sub httpGet;
#########################################################################
#			MAIN						#
#########################################################################
die "Fail!!! one argument expetect\n" unless @ARGV;
my $noteAdd=0.0; 							#  	All rating
my $numFilms= @ARGV;							#	Num of ratings  =  num args.
my $correctProcess =0.0;						#	Correct film processed.								
my $titleField = 'title';						#	Title field in hash.
my $ratingField = 'rating';						#	Rating  Field in  hash.							
foreach my $nameFilm( @ARGV )
{
	my $json = httpGet( uri_escape($nameFilm) );			#	Convert film to URL FORMAT and Get. 
	next if( $json eq '');						#	if error then next film
	my $coderInstance = JSON::XS->new->utf8->pretty->allow_nonref;
	my $perlData = $coderInstance->decode ($json);
	eval
	{
		my @hash =  @{$perlData};
		foreach( @hash )
		{
			my %hash2 = %{$_};
			print $hash2{$titleField}.' '.$hash2{$ratingField};
			print "\n";
			$noteAdd += $hash2{$ratingField};
			$correctProcess++;
		}
	}
}
if( $correctProcess != $numFilms )					#	Check errors
{
	warn "****** Exist Errors in films process  ******\n";
}
my $average = $noteAdd/$numFilms;					#	Calculate average
print "Average Films: $average\n";
#########################################################################
#			END MAIN					#
#########################################################################
sub httpGet
{
	return '' unless @_;
	my $IMDBAPI='http://imdbapi.org/?title=';
	my $url = $IMDBAPI.$_[0];
        my $curl = WWW::Curl::Easy->new;
        $curl->setopt(CURLOPT_HEADER,0);
        $curl->setopt(CURLOPT_URL, $url);
        my $response_body;
        $curl->setopt(CURLOPT_WRITEDATA,\$response_body);
        my $retcode = $curl->perform;
        return ($retcode == 0)?$response_body:'';
}
