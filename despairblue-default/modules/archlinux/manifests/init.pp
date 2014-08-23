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
  $git_package        = 'git',
  $supervisor_package = 'supervisor',
  $zsh_package        = 'zsh',
  $puppet_service     = 'puppet'
) {
  user { $user:
    ensure     => present,
    home       => "/home/${user}",
    managehome => true,
    shell      => '/bin/zsh',
    require    => Package[$zsh_package],
  }
  user { 'papply':
    ensure     => present,
    home       => '/home/papply',
    managehome => true,
    require    => Package[$git_package],
  }
  package { $zsh_package:
    ensure => installed,
  }
  package { $trash_cli_package:
    ensure => installed,
  }
  package { $git_package:
    ensure => installed,
  }
  package { $supervisor_package:
    ensure => installed,
  }
  package { 'puppet':
    ensure => installed,
  }
  package { 'htop':
    ensure => installed,
  }
  package { 'atom-editor':
    ensure => installed,
  }

  file { '/etc/environment':
    ensure  => file,
    source  => 'puppet:///modules/archlinux/etc/environment',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
  }
}
