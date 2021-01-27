FROM php:7.4-fpm-alpine

# persistent / runtime deps
RUN apk add --no-cache \
        acl \
        fcgi \
        freetype \
        libpng \
        libjpeg-turbo \
        file \
        gettext \
        git \
        jq \
    ;

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
	    $PHPIZE_DEPS \
	    icu-dev \
	    libzip-dev \
	    zlib-dev \
	    freetype-dev \
	    libpng-dev \
	    libjpeg-turbo-dev \
	;

RUN set -eux; \
	docker-php-ext-configure zip; \
	docker-php-ext-install -j$(nproc) \
	    intl \
	    zip \
	    gd \
	    pdo \
	    pdo_pgsql \
	;

RUN set -eux; \
	pecl install \
	    apcu-5.1.19 \
	    redis \
	    timezonedb \
	;

RUN set -eux; \
	pecl clear-cache; \
	docker-php-ext-enable \
	    apcu \
	    opcache \
	    redis \
	    timezonedb \
	;

RUN set -eux; \
	runDeps="$( \
	    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
	        | tr ',' '\n' \
	        | sort -u \
	        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .phpexts-rundeps $runDeps; \
	\
	apk del .build-deps
