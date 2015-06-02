File { backup => true }
Exec { path => ['/bin', '/usr/bin', '/usr/local/bin'] }

file { '/tmp/puppet.lastrun':
  ensure  => file,
  content => inline_template("<%= Time.now %>\n"),
  backup  => false,
}

hiera_include('classes')

# Move to hiera somehow
node 'serenity' {
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

node 'firefly' {
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
