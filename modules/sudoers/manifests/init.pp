class sudoers {
  file { '/etc/sudoers':
    content => template('sudoers/sudoers'),
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
  }
}

include sudoers
