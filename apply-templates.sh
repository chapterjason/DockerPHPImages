#!/usr/bin/env bash

# Config
PHP_VERSIONS=("7.4" "8.0")
APCU_VERSION="5.1.19"

# Cleanup
rm -r php

# Actual generating
for PHP_VERSION in "${PHP_VERSIONS[@]}"
do
  # Create directories
  mkdir -p "php/$PHP_VERSION/cli"
  mkdir -p "php/$PHP_VERSION/fpm"

  # Copy templates
  cp base.template "php/$PHP_VERSION/cli/Dockerfile"
  cp base.template "php/$PHP_VERSION/fpm/Dockerfile"

  # Replace image placeholder
  sed -i "s/{{ IMAGE }}/php:$PHP_VERSION-cli-alpine/" "php/$PHP_VERSION/cli/Dockerfile"
  sed -i "s/{{ IMAGE }}/php:$PHP_VERSION-fpm-alpine/" "php/$PHP_VERSION/fpm/Dockerfile"

  # Replace apcu placeholder
  sed -i "s/{{ APCU }}/$APCU_VERSION/" "php/$PHP_VERSION/fpm/Dockerfile"
  sed -i "s/{{ APCU }}/$APCU_VERSION/" "php/$PHP_VERSION/cli/Dockerfile"
done
