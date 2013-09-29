define ontap7::create_volume(
  $filer,
  $username,
  $password,
  $volname = $title,
  $aggrname,
  $volsize) {

  exec { 'validate_aggregate':
    command => "/home/puppet/puppet-demo/modules/ontap7/scripts/validate_aggregate.pl $filer $username $password $volname $aggrname $volsize",
  }

  exec { 'create_volume':
    command => "/home/puppet/puppet-demo/modules/ontap7/scripts/create_volume.pl $filer $username $password $volname $aggrname $volsize",
    require => Exec['validate_aggregate'],
  }

}
