<p align="center">
    <img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" width="150" />
</p>

<p align="center">A web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.</p>

<p align="center">
<img src="https://github.com/InsulateJustf/docker-nginx-http2-brotli/actions/workflows/build&test.yml/badge.svg?branch=main&event=release" />
<img src="https://img.shields.io/github/v/release/InsulateJustf/docker-nginx-http2-brotli" />
</p>

<p align="center">
<a href="https://github.com/InsulateJustf/docker-nginx-http2-brotli/blob/main/README.md">中文 |<a/>
<a href="https://github.com/InsulateJustf/docker-nginx-http2-brotli/blob/main/README.EN.md">English<a/>
</p>

## What is this？
Stable and up-to-date nginx with HTTP/2 support, with brotli compression, include zlib by Cloudflare and OpenSSL library with TLS 1.3 Support, BoringSSL's Equal Preferencen Support and ChaCha20-Poly1305 Draft Version Support.In addition to this, I have added some modules.

## What's inside?
* [zlib by Cloudflare](https://github.com/cloudflare/zlib)
* OpenSSL Library with TLS 1.3 Supprt,  BoringSSL's Equal Preferencen Support and ChaCha20-Poly1305 Draft Version Support
* [Btotli Compression by eustas](https://github.com/eustas/ngx_brotli)
* [ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module/)
  
  ### Details ars as follows:

```
nginx version: nginx/1.23.1
built by gcc 10.3.1 20210424 (Alpine 10.3.1_git20210424) 
built with OpenSSL 1.1.1q  5 Jul 2022
TLS SNI support enabled
configure arguments: 
        --prefix=/etc/nginx
        --sbin-path=/usr/sbin/nginx
        --modules-path=/usr/lib/nginx/modules
        --conf-path=/etc/nginx/nginx.conf
        --error-log-path=/var/log/nginx/error.log
        --http-log-path=/var/log/nginx/access.log
        --pid-path=/var/run/nginx.pid
        --lock-path=/var/run/nginx.lock
        --http-client-body-temp-path=/var/cache/nginx/client_temp
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp
        --user=nginx
        --group=nginx
        --with-http_ssl_module
        --with-http_realip_module
        --with-http_addition_module
        --with-http_sub_module
        --with-http_dav_module
        --with-http_flv_module
        --with-http_mp4_module
        --with-http_gunzip_module
        --with-http_gzip_static_module
        --with-http_random_index_module
        --with-http_secure_link_module 
        --with-http_stub_status_module
        --with-http_auth_request_module 
        --with-http_xslt_module=dynamic 
        --with-http_image_filter_module=dynamic 
        --with-http_geoip_module=dynamic 
        --with-threads 
        --with-stream 
        --with-stream_ssl_module 
        --with-stream_ssl_preread_module 
        --with-stream_realip_module
        --with-stream_geoip_module=dynamic 
        --with-http_slice_module 
        --with-mail 
        --with-mail_ssl_module 
        --with-compat 
        --with-file-aio 
        --with-http_v2_module 
        --with-http_v2_hpack_enc 
        --with-zlib=/usr/src/zlib 
        --with-pcre=/usr/src/pcre-8.45 
        --with-pcre-jit 
        --with-libatomic=/usr/src/libatomic_ops-7.6.12 
        --add-module=/usr/src/headers-more-nginx-module-0.34 
        --add-module=/usr/src/ngx-fancyindex-0.5.2 
        --add-module=/usr/src/ngx_brotli 
        --add-module=/usr/src/ngx_http_geoip2_module 
        --add-module=/usr/src/nginx-http-flv-module 
        --add-module=/usr/src/ngx_http_substitutions_filter_module 
        --with-openssl-opt='zlib enable-weak-ssl-ciphers enable-ec_nistp_64_gcc_128 -ljemalloc -Wl,-flto'
```

## How to use？

### Quick Start
```
docker pull justf/nginx-http2-brotli:latest
```

or

```
docker pull ghcr.io/InsulateJustf/nginx-http2-brotli:latest
```

### Nginx Config
* `.conf` files mounted in `/etc/nginx/main.d` will be included in the `main` nginx context(e.g. you can call [`env` directive](http://nginx.org/en/docs/ngx_core_module.html#env) here)
* `.conf` files mounted in `/etc/nginx/conf.d` will be includednin the `http` nginx context.


#### SSL Config
This image has [ DH parameters for DHE ciphers fetched from Mozilla](https://ssl-config.mozilla.org/ffdhe2048.txt) and store in `/etc/ssl/dhparam.pem`.

So you should add this line in your nginx config:
```
ssl_dhparam /etc/ssl/dhparam.pem;
```
## Thank

[@kn007/patch](https://github.com/kn007/patch)

[@akafeng/docker-nginx](https://github.com/akafeng/docker-nginx)

[@macbre/docker-nginx-http3](https://www.github.com/macbre/docker-nginx-http3)
