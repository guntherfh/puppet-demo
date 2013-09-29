# Last Updated 29Sep2013 by guntherfh@icloud.com

# Example of nodes file - what should be run/exist on each node.
#
# Order is not relevant, unless a dependency is required which is why they are
# deliberately out of order for different nodes.

# Global Variables to be used elsewhere - use CAPS to distinguish them

$AUTHOR = "guntherfh"
$AUTHOR_EMAIL = "guntherfh@icloud.com"

# Node List

node 'yoda' {

    include base

    package { 'vim-common':
        ensure => installed,
    }

    package { 'vim-enhanced':
        ensure => installed,
    }

    include zsh

}

node 'ahsoka' {

    include default
    include zsh
    
    # In this case I want to specifically ensure cvs is NOT on this node.
    # If I put it in default it would exclude from ALL nodes which use that class, unless I
    # use a variable to test for nodename.
    #
    # The easier method is to exclude at a node level :)
    #
    # Could have also done this by creating a module of class type "cvs" which requires
    # cvs be absent and imported that module.

    package { 'cvs':
        ensure => absent,
    }

}
