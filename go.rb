#! /usr/bin/env ruby

require 'erb'
require 'yaml'
require 'ostruct'

$stderr.puts "Starting"

class AppProxy
  def initialize(ip, port)
    @ip, @port = ip, port
  end

  def server_name
    "#@ip.localhost"
  end

  def proxy_pass
    "http://#{host}"
  end

  private

  def host
    ENV["#{prefix}ADDR"] + ":" + ENV["#{prefix}PORT"]
  end

  def prefix
    "#{@ip.upcase}_1_PORT_#{@port}_TCP_"
  end
end

namespace = OpenStruct.new
namespace.app_proxies = YAML.load(ENV['APP_PROXIES']).map { |args| AppProxy.new(*args) }
namespace_binding = namespace.instance_eval { binding }

interpolated_conf = ERB.new(File.read('/etc/nginx/nginx.conf.erb')).result(namespace_binding)
File.open('/etc/nginx/nginx.conf', "w") do |f|
  f.print interpolated_conf
end

$stderr.puts "Starting nginx"

Process.exec('nginx')
