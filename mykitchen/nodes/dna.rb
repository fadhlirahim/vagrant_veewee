require 'rubygems'
require 'json'

dna = {
  :unix_user => 'vagrant',
  
  :environment => {:framework_env => "production"},
  
  :nginx => {
    :version => "1.0.8",
    :install_path => "/opt/nginx-1.0.8",
    :configure_flags => [
      "--prefix=/opt/nginx-1.0.8",
      "--conf-path=/etc/nginx/nginx.conf",
      "--with-http_ssl_module",
      "--with-http_gzip_static_module"
    ],
    :gzip => "on",
    :gzip_http_version => "1.0",
    :gzip_comp_level => "2",
    :gzip_proxied => "any",
    :gzip_types => [
      "text/plain",
      "text/html",
      "text/css",
      "application/x-javascript",
      "text/xml",
      "application/xml",
      "application/xml+rss",
      "text/javascript"
    ],
    :keepalive => "on",
    :keepalive_timeout => 65,
    :worker_connections => 2048,
    :server_names_hash_bucket_size => 64
  },
  
  :recipes => [
    "nginx"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)