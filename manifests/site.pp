File { backup => true }

node 'serenity' {
  include archlinux
  include ssh
  include autoupdate
}
