# docker-nginx

![Build Status](https://img.shields.io/github/workflow/status/robin-moser/docker-nginx/Docker%20Release?logo=github&logoColor=white)
[![Docker Pulls](https://img.shields.io/docker/pulls/robinmoser/nginx?logo=docker&logoColor=white&color=blue)](https://hub.docker.com/r/robinmoser/nginx)

A simple Docker container which contains the nginx webserver on top of alpine:edge. It uses [S6-overlay](https://github.com/just-containers/s6-overlay) as an init system to start additional services.

## Environment Variables

| Variable       | Default         |
| -------------- | --------------- |
| TIMEZONE       | `Europe/Berlin` |
| NGINX_WEB_ROOT | `/app/src`      |
| NGINX_DOMAIN   |                 |
| NGINX_INDEX    | `index.html`    |

If the variable `NGINX_DOMAIN` is set, every request that comes from a different domain will be redirected to the `NGINX_DOMAIN` while keeping its path and parameters.
