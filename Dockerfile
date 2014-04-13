#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM dockerfile/ubuntu

# Install Nginx.
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -y nginx ruby1.9.3

# Set working directory.
WORKDIR /etc/nginx

ADD nginx.conf.erb /etc/nginx/nginx.conf.erb
ADD go.rb /etc/nginx/go.rb

# Expose ports.
EXPOSE 80

ENTRYPOINT '/etc/nginx/go.rb'
ENTRYPOINT '/bin/bash'
