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
      uid     => $user,
      gid     => $user,
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

  }

}
