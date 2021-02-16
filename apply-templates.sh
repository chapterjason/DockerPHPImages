#!/usr/bin/env bash

# Config
PHP_VERSIONS=("7.4" "8.0")
PHP_TYPES=("cli" "fpm" "cli-node" "fpm-node")
APCU_VERSION="5.1.19"

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
    if [[ "$PHP_TYPE" == *-node ]]; then
      REAL_TYPE=${PHP_TYPE%"-node"}
      IMAGE="php:$PHP_VERSION-$REAL_TYPE-alpine"
    else
      IMAGE="php:$PHP_VERSION-$PHP_TYPE-alpine"
    fi

    FILE="php/$PHP_VERSION/$PHP_TYPE/Dockerfile"

    # Create directory
    mkdir -p "php/$PHP_VERSION/$PHP_TYPE"

    # Copy template
    cp base.template "$FILE"

    if [[ "$PHP_TYPE" == *-node ]]; then
      cat node.partial.template >> "$FILE"
    fi

    if [[ $MACHINE == "Mac" ]]; then
      # Replace image placeholder
      sed -i '' "s/{{ IMAGE }}/$IMAGE/" "$FILE"

      # Replace apcu placeholder
      sed -i '' "s/{{ APCU }}/$APCU_VERSION/" "$FILE"
    else
      # Replace image placeholder
      sed -i "s/{{ IMAGE }}/$IMAGE/" "$FILE"

      # Replace apcu placeholder
      sed -i "s/{{ APCU }}/$APCU_VERSION/" "$FILE"
    fi
  done
done
