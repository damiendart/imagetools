# Copyright (C) Damien Dart, <damiendart@pobox.com>.
# This file is distributed under the MIT licence. For more information,
# please refer to the accompanying "LICENCE" file.

FROM dpokidov/imagemagick:latest-bookworm

ARG USER_ID
ARG GROUP_ID

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
  echo "87e29d91762b8fabd10fa60a8173e6285cac8680ab38cf66c1118d5fc604b034 $TEMP" | sha256sum -c --quiet -
  dpkg -i "$TEMP"
  rm -f "$TEMP"
EOT

RUN <<EOT
  set -ex
  TEMP="$(mktemp)"
  curl --location --output "$TEMP" "https://github.com/kornelski/cavif-rs/releases/download/v1.5.5/cavif_1.5.5-1_amd64.deb"
  echo "b21a836dc06c1c6f144bd34b181aba1a5a10df55e3cb6807a32ee032f326f12b $TEMP" | sha256sum -c --quiet -
  dpkg -i "$TEMP"
  rm -f "$TEMP"
EOT

RUN <<EOT
  set -ex
  if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then
    groupadd -g ${GROUP_ID} imagetools
    useradd -l -u ${USER_ID} -g imagetools imagetools
  fi
EOT

COPY --chmod=0755 "export-images" "/usr/local/bin/export-images"

WORKDIR "/app"
USER "imagetools"

ENTRYPOINT ["export-images"]
