class clamps::agent (
  $amqpass               = file('/etc/puppetlabs/mcollective/credentials'),
  $amqserver             = [$::servername],
  $ca                    = $::settings::ca_server,
  $daemonize             = false,
  $master                = $::servername,
  $orch_server           = $::servername,
  $metrics_port          = 2003,
  $metrics_server        = undef,
  $nonroot_users         = 2,
  $num_facts_per_agent   = 500,
  $percent_changed_facts = 15,
  $splay                 = false,
  $splaylimit            = undef,
  $use_cached_catalog = false,
  $mco_daemon            = running,
  $run_pxp               = false,
  $enabled_users         = undef,
) {
  if $enabled_users == undef {
    $max_user = $nonroot_users + 0
  } else {
    $max_user = $enabled_users + 0
  }


  file { '/etc/puppetlabs/clamps':
    ensure => directory
  }

  file { '/etc/puppetlabs/clamps/num_facts':
    ensure  => file,
    content => "${num_facts_per_agent}",
  }

  file { '/etc/puppetlabs/clamps/percent_facts':
    ensure  => file,
    content => "${percent_changed_facts}",
  }

  int_range($nonroot_users).each |$i| {
    $username = "user${i}"
    $enabled = ($i <= $max_user)

    ::clamps::users { $username:
      servername     => $master,
      ca_server      => $ca,
      metrics_server => $metrics_server,
      metrics_port   => $metrics_port,
      daemonize      => $daemonize,
      splay          => $splay,
      splaylimit     => $splaylimit,
      run_pxp        => $enabled and $run_pxp,
      run_agent      => $enabled,
      use_cached_catalog => $use_cached_catalog,
    }

    ::clamps::mcollective { $username:
      amqservers => $amqserver,
      amqpass    => $amqpass,
    }
  }
}
