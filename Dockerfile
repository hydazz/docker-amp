FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="AMP version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV VERSION=${VERSION} \
	HOME=/config \
	USERNAME=admin \
	PASSWORD=password \
	MODULE=ADS \
	S6_SERVICES_GRACETIME=60000

RUN set -xe && \
	echo "**** add mono and cubecoders repos ****" && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
	echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" >/etc/apt/sources.list.d/mono.list && \
	apt-key adv --fetch-keys http://repo.cubecoders.com/archive.key && \
	echo "deb http://repo.cubecoders.com/ debian/" >/etc/apt/sources.list.d/cubecoders.list && \
	echo "**** install runtime packages ****" && \
	dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		ca-certificates-mono \
		git \
		iputils-ping \
		jq \
		lib32gcc1 \
		lib32stdc++6 \
		lib32z1 \
		libbz2-1.0:i386 \
		libcurl3-gnutls:i386 \
		libcurl4 \
		libncurses5:i386 \
		libsdl2-2.0-0 \
		libsdl2-2.0-0:i386 \
		libtinfo5:i386 \
		openjdk-11-jre-headless \
		openjdk-16-jre-headless \
		openjdk-8-jre-headless \
		procps \
		socat \
		tmux \
		unzip \
		wget \
		xz-utils && \
	echo "**** configure default java version ****" && \
	update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java && \
	echo "**** ensure abc has a shell ****" && \
	usermod -d /config -m -s /bin/bash abc && \
	echo "**** install ampinstmgr ****" && \
	apt-get install -y --no-install-recommends --download-only \
		ampinstmgr && \
	dpkg-deb -x /var/cache/apt/archives/ampinstmgr_*.deb /tmp/ampinstmgr && \
	mv /tmp/ampinstmgr/opt/cubecoders/amp/ampinstmgr /usr/bin/ampinstmgr && \
	if [ -z ${VERSION} ]; then \
		VERSION=$(curl -sL "https://api.github.com/repos/hydazz/docker-amp/releases/latest" | jq -r '.tag_name'); \
	fi && \
	CACHE_VERSION=$(echo $VERSION | tr -d .) && \
	echo "**** download AMPCache-${CACHE_VERSION}.zip ****" && \
	mkdir -p /app/amp/ && \
	curl -o \
		/app/amp/AMPCache-${CACHE_VERSION}.zip -L \
		"http://cubecoders.com/Downloads/AMP_Latest.zip" && \
	echo "**** cleanup ****" && \
	apt-get remove -y jq && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
