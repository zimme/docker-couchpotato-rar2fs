FROM zimme/alpine.python
LABEL maintainer="zimme"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# set python to use utf-8 rather than ascii.
ENV PYTHONIOENCODING="UTF-8"

RUN \
  echo "**** install app ****" && \
  git clone --depth 1 https://github.com/CouchPotato/CouchPotatoServer /app/couchpotato

# add local files
COPY root/ /

# ports and volumes
EXPOSE 5050
WORKDIR /app/couchpotato
VOLUME /config /downloads /movies

# Add libs & tools
RUN apk add --no-cache --update fuse-dev autoconf automake wget alpine-sdk git

# Install rar2fs
COPY rar2fs-assets/install_rar2fs.sh /tmp/
RUN /bin/sh /tmp/install_rar2fs.sh


# CLEAN Image
RUN apk del autoconf automake alpine-sdk git

# Add start script
COPY rar2fs-assets/30-rar2fs-mount /etc/cont-init.d/
