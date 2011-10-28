define apache::reverseproxy::http (
  $ensure="present", 
  $vhost,
  $location="/",
  $proxy="http://localhost:8080/"){

  $fname = regsubst($name, "\s", "_", "G")

  include apache::params
 
  file {"${apache::params::root}/${vhost}/conf/reverseproxy-http-${fname}.conf":
    ensure => $ensure,
    content => template("apache/reverseproxy-http.erb"),
    seltype => $operatingsystem ? {
      "RedHat" => "httpd_config_t",
      "CentOS" => "httpd_config_t",
      default  => undef,
    },
    require => [ Apache::Module["proxy"], Apache::Module["proxy_http"] ],
    notify => Exec["apache-graceful"],
  }

}
