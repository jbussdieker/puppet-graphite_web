class graphite_web(
  $prefix = '/opt/graphite',
  $source = 'https://github.com/graphite-project/graphite-web.git',
  $source_path = '/usr/local/src/graphite-web',
  $revision = 'master',
) {

  package { 'python-cairo': }
  package { 'python-django': }
  package { 'python-django-tagging': }

  vcsrepo { $source_path:
    ensure   => present,
    revision => $revision,
    source   => $source,
    provider => git,
  }

  exec { 'install_graphite_web':
    cwd     => $source_path,
    command => "/usr/bin/python setup.py install --prefix ${prefix}",
    creates => "${prefix}/webapp",
    require => Vcsrepo[$source_path],
  }

  exec { 'create_database':
    command => "/usr/bin/python ${prefix}/webapp/graphite/manage.py syncdb --noinput",
    creates => "${prefix}/storage/graphite.db",
    require => Exec['install_graphite_web'],
  }

}
