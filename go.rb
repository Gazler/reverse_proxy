#! /usr/bin/env ruby

require 'erb'

$stderr.puts "Starting"

interpolated_conf = ERB.new(File.read('/etc/nginx/nginx.conf.erb')).result
File.open('/etc/nginx/nginx.conf', "w") do |f|
  f.print interpolated_conf
end

$stderr.puts "Starting nginx"

Process.exec('nginx')
