File { backup => true }
Exec { path => ['/bin', '/usr/bin', '/usr/local/bin'] }

file { '/tmp/puppet.lastrun':
  ensure  => file,
  content => inline_template("<%= Time.now %>\n"),
  backup  => false,
}

node 'baselinux' {
  case $::osfamily {
    'Archlinux': {
      include archlinux
      include ssh
      include autoupdate
    }
    default: {
      fail("${::osfamily} not supported.")
    }
  }
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
