# == Class: archlinux
#
# Full description of class archlinux here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { archlinux:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class archlinux (
  $user = 'despairblue',
  $trash_cli_package  = 'trash-cli',
  $supervisor_package = 'supervisor',
  $zsh_package        = 'zsh',
  $fish_package       = 'fish',
  $puppet_service     = 'puppet',
  $packages           = [],
) {
  include ssh

  user { $user:
    ensure     => present,
    home       => "/home/${user}",
    managehome => true,
    shell      => '/usr/bin/fish',
    require    => Package[$fish_package],
  }

  ssh_authorized_key { 'despairblue@serenity':
    user => 'despairblue',
    type => 'rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDCJKQo9Ce7aZtg10JvPKwcjmC3/UNKPpBW7BGUrCDAfkHWU9k8gH6uuAH+7H7BoBKGhrfs++JIvlOc7RKsHOfe5WAbd1gmIVKXsl2kg1Q1odUeU509hTfbx3/dPgZDSo0ebuJMDuuZvQ+W0w8RazkbYy8FXUXwW4MrimTTLyAW6jMZJJnceExZFecGIsnTV6355dMUsTSKxtKO30VdbQWL4VrwU5El6hzPy6LMR0t3N0hKYyYU4fZXFqpzjWhiM/tSWU1JsogLQ3ZpKCJsvm187aT75lZVleOw6rw3Oyv5kNQdd8G8fs5NymL3qMwPOtAobH0rSlAOY8JrH4/aMheZ',
  }

  ssh_authorized_key { 'despairblue@firefly':
    user => 'despairblue',
    type => 'rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJhp2Yl0EbUfphhLTe09AlNJuTHNXbD22OMcMLg+9/5F5eIsX78t0S95lER8RC5O2djHSJKwXgu+rwfYU2BYSDyvSAcIrQ4zlX961BPNdOtWV/44ciq1rFCg2xGZs/0EVAz6mpRKrANI9RRqAZbyDzjZ9WYY8UQrjOHkKoHv0JnJUZy05AGsBHwClxPTQc0+Kr0NVTeScqJoolIKn1L0XeVT+AHlofqcI+luOTNoFZ87OjAhPwShz5uyjcJb4LYfKF25fAttnoBZBsW74EBOark7Zd5ZLAmeBva3iO2xzOMI6PBe+gDGM7fj90vF1zd3DsX+ekGY0n+aum/E+Wwewp',
  }

  vcsrepo { "/home/${user}/vcs/git/puppet-module-skeleton":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/garethr/puppet-module-skeleton.git',
    user     => $user,
  }

  ensure_packages(any2array($packages))

  ensure_packages([
    'librarian-puppet'
  ], {
    provider => gem,
    require  => File['/etc/gemrc'],
  })

  rootfile {
    [
      '/etc/environment',
      '/etc/gemrc',
      '/etc/mkinitcpio.conf',
      '/etc/pacman.conf',
      '/etc/systemd/logind.conf',
      '/etc/NetworkManager/NetworkManager.conf',
      '/etc/lightdm/lightdm-gtk-greeter.conf',
    ]:
  }

  rootfile { '/etc/NetworkManager/dispatcher.d/10-ntpd':
    mode => '0600',
  }

  rootdirectory {
    [
      '/etc/modprobe.d',
      '/etc/pam.d',
      '/etc/sysctl.d',
    ]:
  }

  roottemplate {
    [
      '/etc/motd',
      '/etc/makepkg.conf',
    ]:
  }
}

# == Define: rootfile
#
define rootfile ($path = $title, $mode = '0644') {
  file { $path:
    ensure => file,
    source => "puppet:///modules/archlinux/${path}",
    mode   => $mode,
    owner  => root,
    group  => root,
  }
}

# == Define: rootdirectory
#
define rootdirectory ($path = $title, $mode = '0644') {
  file { $path:
    ensure  => directory,
    source  => "puppet:///modules/archlinux/${path}",
    mode    => $mode,
    group   => root,
    owner   => root,
    recurse => true,
  }
}

# == Define: roottemplate
#
define roottemplate ($path = $title, $mode = '0644') {
  file { $path:
    ensure  => file,
    content => template("archlinux/${path}.erb"),
    mode    => $mode,
    group   => root,
    owner   => root,
  }
}
