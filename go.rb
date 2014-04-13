#! /usr/bin/env ruby

require 'erb'
require 'yaml'
require 'ostruct'

$stderr.puts "Starting"

namespace = OpenStruct.new
namespace.app_proxies = YAML.load(ENV['APP_PROXIES'])
namespace_binding = namespace.instance_eval { binding }

interpolated_conf = ERB.new(File.read('/etc/nginx/nginx.conf.erb')).result(namespace_binding)
File.open('/etc/nginx/nginx.conf', "w") do |f|
  f.print interpolated_conf
end

$stderr.puts "Starting nginx"

Process.exec('nginx')
