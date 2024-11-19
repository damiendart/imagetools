# Commands:
# docker build -t imagetools .
# docker run -it -v $PWD:/app --rm image-crunch test--400-800-1200.png

FROM dpokidov/imagemagick:latest-bookworm

RUN <<EOT
  set -ex
  apt-get -y update
  apt-get -y upgrade
  apt-get install -y --no-install-recommends curl python3
EOT

RUN <<EOT
  set -ex
  TEMP="$(mktemp)"
  curl --location --output "$TEMP" "https://github.com/shssoichiro/oxipng/releases/download/v9.1.2/oxipng_9.1.2-1_amd64.deb"
  dpkg -i "$TEMP"
  rm -f "$TEMP"
EOT

RUN <<EOT
  set -ex
  TEMP="$(mktemp)"
  curl --location --output "$TEMP" "https://github.com/kornelski/cavif-rs/releases/download/v1.5.5/cavif_1.5.5-1_amd64.deb"
  dpkg -i "$TEMP"
  rm -f "$TEMP"
EOT

COPY --chmod=0755 "export-images" "/usr/local/bin/export-images"

WORKDIR "/app"

ENTRYPOINT ["export-images"]
