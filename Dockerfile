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
RUN apt-get update && \
	apt-get install -y --no-install-recommends libfuse-dev autoconf automake wget build-essential git  && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Install rar2fs
COPY rar2fs-assets/install_rar2fs.sh /tmp/
RUN /bin/sh /tmp/install_rar2fs.sh


# CLEAN Image
RUN apt-get remove -y autoconf build-essential git automake && \
	apt autoremove -y
RUN rm -rf /tmp/* /var/tmp/*

# Add start script
COPY rar2fs-assets/30-rar2fs-mount /etc/cont-init.d/
