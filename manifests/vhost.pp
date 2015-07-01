class graphite_web::vhost($http_server_type = 'nginx') {

  if $http_server_type == 'nginx' {

    include uwsgi

    class { 'nginx':
      manage_repo => false,
    }

    nginx::resource::vhost { 'graphite':
      listen_port         => '8080',
      location_custom_cfg => {
        'uwsgi_pass' => '127.0.0.1:8081',
        'include'    => 'uwsgi_params',
      },
    }

    uwsgi::manage_app { 'graphite':
      ensure  => 'present',
      uid     => $::graphite_web::user,
      gid     => $::graphite_web::user,
      config  => {
        'socket'    => ':8081',
        'processes' => 4,
        'wsgi-file' => "${::graphite_web::prefix}/conf/graphite.wsgi",
        'plugins'   => 'python',
        'logto'     => "${::graphite_web::prefix}/storage/log/webapp/uwsgi.log",
      },
      notify  => Service['uwsgi'],
      require => File["${::graphite_web::prefix}/conf/graphite.wsgi"],
    }

  } elsif $http_server_type == 'apache' {

    class { 'apache':
    }

    apache::vhost { 'graphite':
      port                        => '8080',
      docroot                     => "${::graphite_web::prefix}/webapp",
      wsgi_application_group      => '%{GLOBAL}',
      wsgi_daemon_process         => 'graphite',
      wsgi_daemon_process_options => {
        processes          => '2',
        threads            => '15',
        display-name       => '%{GROUP}',
        inactivity-timeout => 120,
      },
      wsgi_import_script          => "${::graphite_web::prefix}/conf/graphite.wsgi",
      wsgi_import_script_options  => {
        process-group     => 'graphite',
        application-group => '%{GLOBAL}'
      },
      wsgi_process_group          => 'graphite',
      wsgi_script_aliases         => {
        '/' => "${::graphite_web::prefix}/conf/graphite.wsgi",
      },
    }

  } else {

  }

}
