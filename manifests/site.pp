File { backup => true }
Exec { path => ['/bin', '/usr/bin', '/usr/local/bin'] }

file { '/tmp/puppet.lastrun':
  ensure  => file,
  content => inline_template("<%= Time.now %>\n"),
  backup  => false,
}

hiera_include('classes')

# Move to hiera somehow
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
}

node 'firefly' inherits 'baselinux'{
}
