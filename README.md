Reverse Proxy
-------------

Builds a Docker image that starts an nginx reverse proxy for other docker
containers.  The intended use case is if you have a few containers running on
different ports and want to do name-based virtual hosting on them.

Example With [Fig](http://orchardup.github.io/fig/)
================

A sample fig.yml file:

```yaml
app1:
  build: 'git://github.com/danfinnie/app1.git'
app2:
  build: 'git://github.com/danfinnie/app2.git'
reverseproxy:
  build: 'git://github.com/danfinnie/reverse_proxy.git'
  links:
    - "app1"
    - "app2"
  ports:
    - "80:80"
  environment:
    APP_PROXIES: 
      - [app1, 4000] # app1 exposes port 4000
      - [app2, 3000] # app2 exposes port 3000
```

Now, run `fig up` to build all of the Docker containers and start the servers.  If our server was running at example.com, then app1.example.com is proxied to an app1 Docker container on port 3000 and app2.example.com to an app2 Docker container on port 4000.

Whichever container is defined first in the `APP_PROXIES` variable is the default, so if you want something at your root domain, just list it first.

If you're playing with your configuration file and want to start your fig images from scratch, give this a whirl:

```sh
fig kill && fig rm --force && fig build reverseproxy && fig up
```
