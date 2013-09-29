# Last Updated 29Sep2013 by guntherfh@icloud.com

# An example of some defaults for all servers.
#
# These are deliberately out of order to show how the orchestration can be
# achieved via the require keyword.

class base {

    service { 'sshd':
        ensure  => running,
        enable  => true,
        require => Package['openssh'],
    }

    package { 'openssh':
        ensure => "4.3p2-82.el5",
    }

    file { '/etc/ssh/sshd_config':
        # Note that puppet inserts "files" between the module name and the filename
        # automatically - if you explicitly put it in it doesn't work! :(
        source  => "puppet:///modules/base/sshd_config",
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Service['sshd'],
        #notify  => Service['sshd'],
    }

    file { '/root/.ssh':
        ensure => 'directory',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Service['sshd'],
    }
    
    file { '/root/.ssh/authorized_keys':
        # Note that puppet inserts "files" between the module name and the filename
        # automatically - if you explicitly put it in it doesn't work! :(
        source  => "puppet:///modules/base/id_dsa.pub",
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => File['/root/.ssh'],
    }

    # This example highlights dynamic file creation using built in facter
    # variables as well as site defined global variables

    file { '/etc/motd':
        content => "
        Welcome to this PUPPET ${puppetversion} managed host!

        HOSTNAME   = ${hostname}
        IP ADDRESS = ${ipaddress_eth0}
        OS VERSION = ${operatingsystem} ${operatingsystemrelease}

        Any problems, email the site administrator ${AUTHOR_EMAIL}

",
        owner => 'root',
        group => 'root',
        mode  => '0644',
    }

}
