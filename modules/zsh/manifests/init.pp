# Last Updated 29Sep2013 by guntherfh@icloud.com

# Example of requiring a specific version of software
#
# If you had more than one (typically) this could be done by creating a generic default software
# module and listing all the of the software there. In this case it's done by the software
# family name. e.g. could have (a very large one) for all X11 software etc.


class zsh {
    
    # Use of extra messaging/notification to show where we're at!

    notify { "${hostname} : package zsh .. checking": }

    package { 'zsh':
        ensure => "4.2.6-8.el5",
    }

    # For the HTML documentation, check to see if zsh is installed first

    package { 'zsh-html':
        ensure => "4.2.6-8.el5",
        require => Package['zsh'],
    }

    notify { "${hostname} : package zsh .. complete": }

}
