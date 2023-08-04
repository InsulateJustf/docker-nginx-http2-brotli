<p align="center">
    <img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" width="150" />
</p>

<p align="center">A web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.</p>

<p align="center">
<img src="https://github.com/InsulateJustf/docker-nginx-http2-brotli/actions/workflows/push.yml/badge.svg" />
<img src="https://img.shields.io/github/v/release/InsulateJustf/docker-nginx-http2-brotli" />
</p>

<p align="center">
<a href="https://github.com/InsulateJustf/docker-nginx-http2-brotli/blob/main/README.md">中文 |<a/>
<a href="https://github.com/InsulateJustf/docker-nginx-http2-brotli/blob/main/README.EN.md">English<a/>
</p>

## 这是个啥玩意儿？
稳定和最新的 nginx，支持 HTTP/2, brotli压缩。包含了 Cloudflare 优化的 zlib 和 支持 TLS 1.3 、BoringSSL 等价加密套件、 CHACHA20-Poly1305 草案的 OpenSSL 库。除此之外，我还添加了一些 nginx 模块。

## 里面有些啥？

* [zlib by Cloudflare](https://github.com/cloudflare/zlib)
* 包含了 TLS 1.3 支持、BoringSSL 等价加密套件和 CHACHA20-Poly1305 草案的 OpenSSL 库
* [Btotli Compression by google](https://github.com/google/ngx_brotli)
* [ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module/)
  
  ### 详情如下:
```
nginx version: nginx/1.25.1
built by gcc 10.3.1 20210424 (Alpine 10.3.1_git20210424) 
built with OpenSSL 1.1.1u  30 May 2023
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
	--with-zlib=/usr/src/zlib 
	--with-pcre=/usr/src/pcre-8.45 
	--with-pcre-jit 
	--with-libatomic=/usr/src/libatomic_ops-7.8.0 
	--add-module=/usr/src/headers-more-nginx-module-0.34 
	--add-module=/usr/src/ngx-fancyindex-0.5.2 
	--add-module=/usr/src/ngx_brotli 
	--add-module=/usr/src/ngx_http_geoip2_module 
	--add-module=/usr/src/nginx-http-flv-module 
	--add-module=/usr/src/ngx_http_substitutions_filter_module 
	--with-openssl=/usr/src/openssl-1.1.1u 
	--with-openssl-opt='zlib enable-tls1_3 enable-weak-ssl-ciphers enable-ec_nistp_64_gcc_128 -ljemalloc -Wl,-flto'
```
## 咋用？

### 快速开始

```
docker pull justf/nginx-http2-brotli:latest
```

或者

```
docker pull ghcr.io/InsulateJustf/nginx-http2-brotli:latest
```

### Nginx 配置
* 挂载在 /etc/nginx/main.d 中的 .conf 文件将被包含在 nginx.conf 的上下文中。（你可以在这里调用 env 指令）

* 挂载在 /etc/nginx/conf.d 中的 .conf 文件将被包含在 nginx.conf 中的 http 块中。
```
include /etc/nginx/main.d/*.conf;
...
http{
        ...;
        include /etc/nginx/conf.d/*.conf;

}
```
#### SSL 配置
这个镜像里包含了了来自 [ Mozilla 的 DHparameter 文件](https://ssl-config.mozilla.org/ffdhe2048.txt)并且保存在 ```/etc/ssl/dhparam.pem``` 中。
所以你应该在你的 nginx 配置中添加如下一行：
```
ssl_dhparam /etc/ssl/dhparam.pem;
```

## 感谢

[@kn007/patch](https://github.com/kn007/patch)

[@akafeng/docker-nginx](https://github.com/akafeng/docker-nginx)

[@macbre/docker-nginx-http3](https://www.github.com/macbre/docker-nginx-http3)
