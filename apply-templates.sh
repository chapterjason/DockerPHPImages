#!/usr/bin/env bash

# Config
PHP_VERSIONS=("8.0" "8.0.3" "8.1")
PHP_TYPES=("cli" "fpm" "cli-node" "fpm-node")
APCU_VERSION="5.1.20"

# Detect os
UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
Darwin*) MACHINE=Mac ;;
*) MACHINE="Other:${UNAME_OUT}" ;;
esac

# Cleanup
rm -r php

# Actual generating
for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
  for PHP_TYPE in "${PHP_TYPES[@]}"; do
    PHP_IMAGE_VERSION="$PHP_VERSION-$PHP_TYPE-alpine"

    if [[ "$PHP_TYPE" =~ "node" ]]; then
      PHP_IMAGE_VERSION=${PHP_IMAGE_VERSION//"-node"/}
    fi

    FILE="php/$PHP_VERSION/$PHP_TYPE/Dockerfile"

    # Create directory
    mkdir -p "php/$PHP_VERSION/$PHP_TYPE"

    touch "$FILE"

    ##########
    ##### Args in default order
    ##########
    cat "templates/args/php.args.template" >> "$FILE"

    ##########
    ##### Pre in reverse order
    ##########
    cat "templates/pre/php.pre.template" >> "$FILE"

    ##########
    ##### Base in default order
    ##########
    cat "templates/php.template" >> "$FILE"
    cat "templates/composer.template" >> "$FILE"

    if [[ "$PHP_TYPE" =~ "node" ]]; then
      cat templates/node.template >> "$FILE"
    fi

    if [[ $MACHINE == "Mac" ]]; then
      # Replace image placeholder
      sed -i '' "s/{{ PHP_IMAGE_VERSION }}/$PHP_IMAGE_VERSION/" "$FILE"

      # Replace apcu placeholder
      sed -i '' "s/{{ APCU }}/$APCU_VERSION/" "$FILE"
    else
      # Replace image placeholder
      sed -i "s/{{ PHP_IMAGE_VERSION }}/$PHP_IMAGE_VERSION/" "$FILE"

      # Replace apcu placeholder
      sed -i "s/{{ APCU }}/$APCU_VERSION/" "$FILE"
    fi
  done
done
