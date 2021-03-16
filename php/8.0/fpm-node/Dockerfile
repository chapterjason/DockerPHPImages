FROM php:8.0-fpm-alpine

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
	;

RUN set -eux; \
	docker-php-ext-configure zip; \
	docker-php-ext-install -j$(nproc) \
	    intl \
	    zip \
	    gd \
	    pdo \
	    pdo_mysql \
	    pdo_pgsql \
	;

RUN set -eux; \
	pecl install \
	    apcu-5.1.20 \
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

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Allow composer for all
# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

# Add NodeJS
RUN apk add --no-cache \
        nodejs \
        yarn \
        npm \
    ;
