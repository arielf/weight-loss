#!/usr/bin/perl -w

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use File::Basename;
$ENV{'PATH'} = '/bin:/usr/bin:.';

use constant IS_MOD_PERL => exists $ENV{'MOD_PERL'};
use constant IS_CGI      => IS_MOD_PERL || exists $ENV{'GATEWAY_INTERFACE'};

my $Q = {};
my $Filename = '';
my $Email = '';
my $UploadDir = 'Uploads';
my $UploadFH;

if (IS_CGI) {
    open(STDERR, ">&STDOUT");
    $| = 1;
    $CGI::POST_MAX = 1024 * 5000;
    $Q = new CGI;
    $Filename = $Q->param("data");
    $Email = $Q->param("email_address");
    $UploadFH = $Q->upload("data");
    print $Q->header();
    print $Q->start_html(title => "Weight-Loss Data", -bgcolor => "#ffffff");
} else {
    $Filename = 'data.csv';
    $UploadFH = 'STDIN';
};


sub cgi_die(@) {
    die "@_\n";
}

sub upload($) {
    my ($filename) = @_;
    unless ((defined $filename) and $filename =~ /\w/) {
        cgi_die("You must provide a filename to upload\n");
    }
    $filename =~ s,.*/,,;       # strip leading dirs
    $filename =~ tr/ /_/;
    $filename =~ tr/A-Za-z0-9_.-/_/cs;

    my $store_path = "$filename";
    open(my $store_fh, ">$store_path") or die "$0: open(>$store_path): $!\n";
    binmode $store_fh;

    my $chunk;
    while ($chunk = <$UploadFH>) {
        print $store_fh $chunk;
    }
    close $store_fh;
    $store_path;
}

sub file2str($) {
    my ($file) = @_;
    local $/; undef $/;
    open(my $fh, $file) || cgi_die("$0: $file: $!\n");
    my $str = <$fh>; 
    close $fh;
    $str;
}

sub data2chart($) {
    my ($data_file) = @_;
    my $output = `../data2image "$data_file"`;
    my ($tmp_dir) = ($output =~ m{^(_z[^/]+)/data.scores.png$}m);
    cgi_die("Something failed - Sorry\n")
        unless (defined $tmp_dir);
    $tmp_dir;
}

sub body_content($$) {
    my ($scores_txt, $chart_path) = @_;
    qq[
<h2>Your Scores</h2>
<pre>
$scores_txt
</pre>
<p>
<h2>Your Chart (click to enlarge)</h2>
  <a href="$chart_path">
    <img src="$chart_path" width=500 height=809>
  </a>
]
}

sub generate_result_page($) {
    my ($tmp_dir) = @_;

    my $chart_path  = "Uploads/$tmp_dir/data.scores.png";
    my $scores_path = "$tmp_dir/scores.txt";
    my $scores_txt = file2str($scores_path);
    print body_content($scores_txt, $chart_path);
    $Q->end_html();
}

#
# -- main
#
chdir($UploadDir) || cgi_die("chdir($UploadDir): $!\n");

my $data_path = upload($Filename);
my $tmp_dir = data2chart($data_path);
generate_result_page($tmp_dir);

