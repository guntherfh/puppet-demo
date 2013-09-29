#!/usr/bin/perl

# volume_info.pl - displays volume info, including options

# Gunther Feuereisen <Gunther.Feuereisen@team.telstra.com>
# © Telstra Corporation Limited (ACN 051 775 556) 2013.
# http://www.in.telstra.com.au/ism/intellectualproperty/copyright.asp

# This SDK sample code is provided AS IS, with no support or
# warranties of any kind, including but not limited to
# warranties of merchantability or fitness of any kind,
# expressed or implied.  This code is subject to the license
# agreement that accompanies the SDK.
#
# Copyright 2005 Network Appliance, Inc. All rights
# reserved. Specifications subject to change without notice.

require 5.6.1;
use lib "../lib/perl/NetApp";  
use NaServer;
use NaElement;

# Command Line parsing

my $args = $#ARGV + 1;
my $filer = shift;
my $user = shift;
my $pw = shift;
my $volname = shift;
my $aggrname = shift;
my $volsize = shift;
my $expected_args = 6;

# Global variables/objects

my $out;
my $s;

# Global contants;

my %options;
$options{"nvfail"} = 1;
$options{"create_ucode"} = 1;
$options{"convert_ucode"} = 1;
$options{"fractional_reserve"} = 1;
$options{"snapshot_clone_dependency"} = 1;
$options{"no_atime_update"} = 1;

# Function calls

connect_to_filer();
volume_info();
volume_options();

# Functions

sub connect_to_filer()
{

    # check for valid number of parameters
    if ($args != $expected_args)
    {
        print_usage();
    }

    $s = NaServer->new($filer, 1, 3);
    my $response = $s->set_style(LOGIN);
    if (ref($response) eq "NaElement" && $response->results_errno != 0) 
    {
        my $r = $response->results_reason();
        print "Unable to set authentication style $r\n";
        exit(2);
    }
    $s->set_admin_user($user, $pw);
    $s->set_transport_type(HTTP);
    if (ref($response) eq "NaElement" && $response->results_errno != 0) 
    {
        my $r = $response->results_reason();
        print "Unable to set HTTP transport $r\n";
        exit(2);
    }

}

sub volume_info()
{
    $out = $s->invoke("volume-list-info",
                      "volume", $volname); 
    command_successful();

    my $vol_list = $out->child_get("volumes");
    my @result = $vol_list->children_get();

    my $vol_size = $result[0]->child_get_string("size-total");

    printf("volume: %s\n", $volname);
    printf("size: %d blocks\n", $vol_size);
}

sub volume_options()
{
    $out = $s->invoke("volume-options-list-info",
                      "volume", $volname); 
    command_successful();

    my $vol_opts = $out->child_get("options");
    my @result = $vol_opts->children_get();

    foreach $opt (@result)
    {
       my $optname = $opt->child_get_string("name");

       if (exists($options{"$optname"}))
       {
           my $optvalue = $opt->child_get_string("value");
           printf("%s = %s\n", $optname, $optvalue);
       }
    }
}

sub print_usage()
{
    print("Usage: create_volume.pl <filer> <user> <password> ");
    print("<volume name> <agreggate name> <volume size>\n");
    exit(-1);
}

sub command_successful()
{
    if ($out->results_status() eq "failed")
    {
        print($out->results_reason() . "\n");
        exit(-2);
    }
}
