# == Class: autoupdate
#
# Full description of class autoupdate here.
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
#  class { autoupdate:
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
class autoupdate {
  include sudo

  vcsrepo { '/home/papply/puppet':
    ensure   => present,
    provider => git,
    source   => 'git@github.com:despairblue/puppet.git',
    user     => 'papply',
  }

  user { 'papply':
    ensure     => present,
    home       => '/home/papply',
    managehome => true,
    require    => [Package[git], Service['cronie']],
  }

  service { 'cronie':
    ensure => running,
    enable => true,
  }

  cron { 'Autoupdate':
    command => '/usr/local/bin/pull-updates',
    minute  => '*/10',
    user    => 'papply',
  }

  file { '/usr/local/bin/papply':
    ensure  => 'file',
    source  => 'puppet:///modules/autoupdate/usr/local/bin/papply',
    group   => '0',
    mode    => '0755',
    owner   => '0',
  }

  file { '/usr/local/bin/pull-updates':
    ensure  => 'file',
    source  => 'puppet:///modules/autoupdate/usr/local/bin/pull-updates',
    group   => '0',
    mode    => '0755',
    owner   => '0',
  }

  file { '/etc/sudoers.d/papply':
    ensure  => 'file',
    source  => 'puppet:///modules/autoupdate/etc/sudoers.d/papply',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
  }
}
