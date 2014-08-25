# == Class: tinc
#
# Full description of class tinc here.
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
#  class { tinc:
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
class tinc(
  $nodenumber = 'UNSET',
) {
  ensure_packages(['tinc'])

  service { 'tincd@home':
    ensure     => running,
    enable     => true,
  }

  file { '/etc/tinc':
    ensure => directory,
  }

  file { '/etc/tinc/home':
    ensure  => directory,
    source  => 'puppet:///modules/tinc/etc/tinc/home',
    group   => root,
    owner   => root,
    recurse => true,
    notify  => Service['tincd@home'],
    require => Package['tinc'],
  }

  roottemplate2 {
    [
      '/etc/tinc/home/tinc-down',
      '/etc/tinc/home/tinc-up',
      '/etc/tinc/home/tinc.conf',
    ]:
  }
}

# == Define: roottemplate
#
# TODO: write a definiton module
define roottemplate2 ($path = $title, $mode = '0755') {
  file { $path:
    ensure  => file,
    content => template("tinc/${path}.erb"),
    mode    => $mode,
    group   => root,
    owner   => root,
    notify  => Service['tincd@home'],
  }
}
