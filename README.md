
# DockerPHPImages

These are the default php images with some extras.
I use them as base images for my symfony projects.
Feel free to use them.

```console
docker push chapterjason/php:tagname
```

Tagnames:

- 8.0-fpm-alpine
- 8.0-cli-alpine
- 8.0-cli-node-alpine
- 8.0-fpm-node-alpine
- 7.4-fpm-alpine
- 7.4-cli-alpine
- 7.4-fpm-node-alpine
- 7.4-cli-node-alpine

Images with `node` contains a nodejs, npm and yarn installation.
Might be the case that you need to build some assets.
