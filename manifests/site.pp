File { backup => true }
Exec { path => ['/bin', '/usr/bin', '/usr/local/bin'] }

file { '/tmp/puppet.lastrun':
  ensure  => file,
  content => inline_template("<%= Time.now %>\n"),
  backup  => false,
}

node 'serenity' {
  include archlinux
  include ssh
  include autoupdate
}
