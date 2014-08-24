File { backup => true }
Exec { path => ['/bin', '/usr/bin', '/usr/local/bin'] }

file { '/tmp/puppet.lastrun':
  ensure  => file,
  content => inline_template("<%= Time.now %>\n"),
  backup  => false,
}

node 'baselinux' {
  include archlinux
  include ssh
  include autoupdate
}

node 'serenity' inherits 'baselinux'{
  class { 'tinc':
    nodenumber => 1,
  }
}

node 'firefly' inherits 'baselinux'{
  class { 'tinc':
    nodenumber => 2,
  }
}
