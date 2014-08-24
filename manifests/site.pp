File { backup => true }
Exec { path => ['/bin', '/usr/bin', '/usr/local/bin'] }

node 'serenity' {
  include archlinux
  include ssh
  include autoupdate
}
