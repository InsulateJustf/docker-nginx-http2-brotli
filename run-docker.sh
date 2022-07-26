#!/bin/sh
git clone --branch dev https://github.com/InsulateJustf/docker-nginx-http2-brotli ./nginx
docker run --rm \
  -p 0.0.0.0:8888:80 \
  -p 0.0.0.0:8889:443/tcp \
  -p 0.0.0.0:8889:443/udp \
  -v "$PWD/nginx/tests":/static:ro \
  -v "$PWD/nginx/tests/modules.conf":/etc/nginx/main.d/modules.conf:ro \
  -v "$PWD/nginx/tests/static.conf":/etc/nginx/conf.d/static.conf:ro \
  -v "$PWD/nginx/tests/https.conf":/etc/nginx/conf.d/https.conf:ro \
  -v "$PWD/nginx/tests/localhost.crt":/etc/nginx/ssl/localhost.crt:ro \
  -v "$PWD/nginx/tests/localhost.key":/etc/nginx/ssl/localhost.key:ro \
  --name test_nginx \
  -t justf/nginx-http2-brotli
