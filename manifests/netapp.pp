# Last Updated 29Sep2013 by guntherfh@icloud.com

node 'anakin' {

  ontap7::test { 'vol01':
    filer    => 'fas01',
    username => 'root',
    password => 'netapp1',
    aggrname => 'aggr01',
    volsize  => '100m',
  }

  ontap7::create_volume { 'vol01':
    filer    => 'fas01',
    username => 'root',
    password => 'netapp1',
    aggrname => 'aggr01',
    volsize  => '100m',
  }

}
