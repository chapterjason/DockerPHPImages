ARG PHP_IMAGE_VERSION=8.0.3-fpm-alpine
ARG PHP_IMAGE=php:${PHP_IMAGE_VERSION}
FROM ${PHP_IMAGE}

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
	    postgresql-dev \
	; \
    docker-php-ext-configure zip; \
	docker-php-ext-install -j$(nproc) \
	    intl \
	    zip \
	    sockets \
	    gd \
	    pdo \
	    pdo_mysql \
	    pdo_pgsql \
	; \
	pecl install \
	    apcu-5.1.21 \
	    redis \
	    timezonedb \
	    xdebug \
	; \
	pecl clear-cache; \
	docker-php-ext-enable \
	    apcu \
	    opcache \
	    redis \
	    timezonedb \
	; \
	runDeps="$( \
	    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
	        | tr ',' '\n' \
	        | sort -u \
	        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .phpexts-rundeps $runDeps; \
	apk del .build-deps;

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
