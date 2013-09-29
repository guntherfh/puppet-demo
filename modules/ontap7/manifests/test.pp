define ontap7::test(
  $filer,
  $username,
  $password,
  $volname = $title,
  $aggrname,
  $volsize) {

  notify { "[ONTAP::TEST] $username:$password@$filer vol create $volname $aggrname $volsize\n": }

}
