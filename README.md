imagetools
==========

## Getting started

``` shell
$ docker build --build-arg USER_ID="$(id -u ${USER})" --build-arg GROUP_ID="$(id -g ${USER})" -t imagetools .
$ docker run -it -v "$PWD:/app" --rm imagetools image--400-800.png
```
