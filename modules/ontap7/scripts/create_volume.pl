#!/usr/bin/perl

# This SDK sample code is provided AS IS, with no support or
# warranties of any kind, including but not limited to
# warranties of merchantability or fitness of any kind,
# expressed or implied.  This code is subject to the license
# agreement that accompanies the SDK.
#
# Copyright 2005 Network Appliance, Inc. All rights
# reserved. Specifications subject to change without notice.

require 5.6.1;
use lib "/home/puppet/puppet-demo/modules/ontap7/lib/perl/NetApp";  
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

# Global contantsx

# Function calls

connect_to_filer();
create_volume();

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

sub create_volume()
{
    $out = $s->invoke("volume-create",
                      "containing-aggr-name", $aggrname, 
                      "size", $volsize, 
                      "space-reserve", "none",
                      "volume", $volname);

    command_successful();

    $out = $s->invoke("volume-set-option",
                      "volume", $volname,
                      "option-name", "nvfail",
                      "option-value", "on");
    command_successful();

    $out = $s->invoke("volume-set-option",
                      "volume", $volname,
                      "option-name", "create_ucode",
                      "option-value", "on");
    command_successful();

    $out = $s->invoke("volume-set-option",
                      "volume", $volname,
                      "option-name", "convert_ucode",
                      "option-value", "on");
    command_successful();

    $out = $s->invoke("volume-set-option",
                      "volume", $volname,
                      "option-name", "fractional_reserve",
                      "option-value", "100");
    command_successful();

    $out = $s->invoke("volume-set-option",
                      "volume", $volname,
                      "option-name", "snapshot_clone_dependency",
                      "option-value", "on");
    command_successful();

    $out = $s->invoke("volume-set-option", 
                      "volume", $volname,
                      "option-name", "no_atime_update",
                      "option-value", "on");
    command_successful();
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
