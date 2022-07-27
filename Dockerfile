ARG NGINX_VERSION=1.23.1

FROM alpine:3.14 AS base
LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"

# https://nginx.org/en/download.html
ARG NGINX_VERSION
ARG NGINX_PATCH="https://raw.githubusercontent.com/kn007/patch/master/nginx.patch"
ARG NGINX_CRYPT_PATCH="https://raw.githubusercontent.com/kn007/patch/master/use_openssl_md5_sha1.patch"

# openssl
ARG OPENSSL_VERSION="1.1.1q"
ARG OPENSSL_URL="https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz"
ARG OPENSSL_PATCH="https://raw.githubusercontent.com/kn007/patch/master/openssl-1.1.1.patch"

# zlib by cloudflare
ARG ZLIB_URL="https://github.com/cloudflare/zlib.git"

# jemalloc
ARG JEMALLOC_VERSION=5.3.0
ARG JEMALLOC_URL="https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2"

# brotil
ARG BROTLI_URL="https://github.com/eustas/ngx_brotli"

# https://github.com/openresty/headers-more-nginx-module#installation
ARG HEADERS_MORE_VERSION=0.34
ARG HEADERS_MORE_URL="https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v${HEADERS_MORE_VERSION}.tar.gz"

# https://github.com/leev/ngx_http_geoip2_module/releases
ARG GEOIP2_VERSION=3.4

ARG PCRE_VERSION="8.45"
ARG PCRE_URL="https://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz"

ARG LIBATOMIC_VERSION="7.6.12"
ARG LIBATOMIC_URL="https://github.com/ivmai/libatomic_ops/releases/download/v${LIBATOMIC_VERSION}/libatomic_ops-${LIBATOMIC_VERSION}.tar.gz"

ARG HTTP_FLV_URL="https://github.com/winshining/nginx-http-flv-module.git"

ARG FANCYINDEX_VERSION="0.5.2"
ARG FANCYINDEX_URL="https://github.com/aperezdc/ngx-fancyindex/releases/download/v${FANCYINDEX_VERSION}/ngx-fancyindex-${FANCYINDEX_VERSION}.tar.xz"

ARG SUBS_FILTER_URL="https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git"



RUN \
	apk add --no-cache --virtual .build-deps \
		patch \
		gcc \
		libc-dev \
		make \
		musl-dev \
		go \
		mercurial \
		pcre-dev \
		zlib-dev \
		linux-headers \
		curl \
		gnupg1 \
		libxslt-dev \
		gd-dev \
		geoip-dev \
		perl-dev \
	&& apk add --no-cache --virtual .brotli-build-deps \
		autoconf \
		libtool \
		automake \
		git \
		g++ \
		cmake

WORKDIR /usr/src/

RUN \
  echo "Cloning zlib by cloudflare ..." \
  && cd /usr/src \
  && git clone --depth 1 ${ZLIB_URL} \
  && cd /usr/src/zlib \
  && make -f Makefile.in distclean 

RUN \
  echo "Downloading Openssl $OPENSSL_VERSION " \
  && cd /usr/src \
  && wget -O openssl-${OPENSSL_VERSION}.tar.gz ${OPENSSL_URL} \
  && tar -xzvf openssl-${OPENSSL_VERSION}.tar.gz \
  && cd /usr/src/openssl-${OPENSSL_VERSION} \
  && curl ${OPENSSL_PATCH} | patch -p1

RUN \
  echo "Cloning nginx $NGINX_VERSION ..." \
  && wget -O nginx.tar.gz https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar -xzvf nginx.tar.gz -C /usr/src \
  && rm -f nginx.tar.gz \
  && cd /usr/src/nginx-${NGINX_VERSION} \
  && curl ${NGINX_PATCH} | patch -p1 \
  && curl ${NGINX_CRYPT_PATCH} | patch -p1

RUN \
  echo "Cloning ngx_http2_geoip2_module ..." \
  # ngx_http_geoip2_module needs libmaxminddb-dev
  && apk add --no-cache libmaxminddb-dev \
  && cd /usr/src \
  && git clone --depth 1 --branch ${GEOIP2_VERSION} https://github.com/leev/ngx_http_geoip2_module 

RUN \
  echo "Cloning ngx_brotli ..." \
  && cd /usr/src \
  && git clone https://github.com/eustas/ngx_brotli.git \
  && cd /usr/src/ngx_brotli \
  && git submodule update --init --recursive

RUN \
  echo "Cloning nginx-http-flv-module & nginx_substitutions_filter ..." \
  && cd /usr/src \
  && git clone --depth 1 ${HTTP_FLV_URL} \
  && git clone --depth 1 ${SUBS_FILTER_URL} 

RUN \
  echo "Downloading headers-more-nginx-module ..." \
  && cd /usr/src \
  && wget https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v${HEADERS_MORE_VERSION}.tar.gz -O headers-more-nginx-module.tar.gz \
  && tar -xf headers-more-nginx-module.tar.gz

RUN \
  echo "Downloading libatomic_ops ..." \
  && cd /usr/src \
  && wget -O libatomic_ops-${LIBATOMIC_VERSION}.tar.gz ${LIBATOMIC_URL} \
  && tar -xzvf libatomic_ops-${LIBATOMIC_VERSION}.tar.gz \
  && cd /usr/src/libatomic_ops-${LIBATOMIC_VERSION} \
  &&  ./configure \
  && make -j $(nproc) \
  && ln -s .libs/libatomic_ops.a src/libatomic_ops.a

RUN \
  echo "Downloading ngx-fancyindex ..." \
  && cd /usr/src \
  && wget -O ngx-fancyindex-${FANCYINDEX_VERSION}.tar.xz ${FANCYINDEX_URL} \
  && tar -xvf ngx-fancyindex-${FANCYINDEX_VERSION}.tar.xz 

RUN \
  echo "Downloading PCRE ..." \
  && cd /usr/src \
  && wget -O pcre-${PCRE_VERSION}.tar.gz ${PCRE_URL} \
  && tar -xzvf pcre-${PCRE_VERSION}.tar.gz

RUN \
  echo "Downloading and build jemalloc" \
  && cd /usr/src \
  && wget -O jemalloc.tar.gz ${JEMALLOC_URL} \
  && tar -xvf jemalloc.tar.gz\
  && cd jemalloc-${JEMALLOC_VERSION} \
  && ./configure \
  && make install -j$(nproc)

RUN \
	echo "Building nginx ..." \
	&& cd /usr/src/nginx-$NGINX_VERSION \
	&& ./configure \
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--modules-path=/usr/lib/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--user=nginx \
		--group=nginx \
		--with-http_ssl_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_stub_status_module \
		--with-http_auth_request_module \
		--with-http_xslt_module=dynamic \
		--with-http_image_filter_module=dynamic \
		--with-http_geoip_module=dynamic \
		--with-threads \
		--with-stream \
		--with-stream_ssl_module \
		--with-stream_ssl_preread_module \
		--with-stream_realip_module \
		--with-stream_geoip_module=dynamic \
		--with-http_slice_module \
		--with-mail \
		--with-mail_ssl_module \
		--with-compat \
		--with-file-aio \
		--with-http_v2_module \
		--with-http_v2_hpack_enc \
		--with-zlib=/usr/src/zlib \
		--with-pcre=/usr/src/pcre-${PCRE_VERSION} \
		--with-pcre-jit \
		--with-libatomic=/usr/src/libatomic_ops-${LIBATOMIC_VERSION} \
		--add-module=/usr/src/headers-more-nginx-module-${HEADERS_MORE_VERSION} \
		--add-module=/usr/src/ngx-fancyindex-${FANCYINDEX_VERSION} \
		--add-module=/usr/src/ngx_brotli \
		--add-module=/usr/src/ngx_http_geoip2_module \
		--add-module=/usr/src/nginx-http-flv-module \
		--add-module=/usr/src/ngx_http_substitutions_filter_module \
		--with-openssl=/usr/src/openssl-${OPENSSL_VERSION} \
		--with-openssl-opt="zlib enable-tls1_3 enable-weak-ssl-ciphers enable-ec_nistp_64_gcc_128 -ljemalloc -march=native -Wl,-flto" \
	&& make -j$(getconf _NPROCESSORS_ONLN)

RUN \
	cd /usr/src/nginx-$NGINX_VERSION \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir /etc/nginx/conf.d/ \
	&& strip /usr/sbin/nginx* \
	&& strip /usr/lib/nginx/modules/*.so \
	\
	# https://tools.ietf.org/html/rfc7919
	# https://github.com/mozilla/ssl-config-generator/blob/master/docs/ffdhe2048.txt
	&& curl -fSL https://ssl-config.mozilla.org/ffdhe2048.txt > /etc/ssl/dhparam.pem \
	\
	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
	&& apk add --no-cache --virtual .gettext gettext \
	\
	&& scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /usr/bin/envsubst \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u > /tmp/runDeps.txt

FROM alpine:3.14
ARG NGINX_VERSION
ARG NGINX_COMMIT

ENV NGINX_VERSION $NGINX_VERSION
ENV NGINX_COMMIT $NGINX_COMMIT

COPY --from=base /tmp/runDeps.txt /tmp/runDeps.txt
COPY --from=base /etc/nginx /etc/nginx
COPY --from=base /usr/lib/nginx/modules/*.so /usr/lib/nginx/modules/
COPY --from=base /usr/sbin/nginx /usr/sbin/
COPY --from=base /usr/local/lib/perl5/site_perl /usr/local/lib/perl5/site_perl
COPY --from=base /usr/bin/envsubst /usr/local/bin/envsubst
COPY --from=base /etc/ssl/dhparam.pem /etc/ssl/dhparam.pem

RUN \
	addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	&& apk add --no-cache --virtual .nginx-rundeps tzdata $(cat /tmp/runDeps.txt) \
	&& rm /tmp/runDeps.txt \
	&& ln -s /usr/lib/nginx/modules /etc/nginx/modules \
	# forward request and error logs to docker log collector
	&& mkdir /var/log/nginx \
	&& touch /var/log/nginx/access.log /var/log/nginx/error.log \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl_common.conf /etc/nginx/conf.d/ssl_common.conf

# show env
RUN env | sort

# test the configuration
RUN nginx -V; nginx -t

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
