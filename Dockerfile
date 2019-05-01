FROM ubuntu:xenial

LABEL authors="Isaac (Ike) Arias <ikester@gmail.com>"

RUN apt-get update && \
	apt-get install -y \
		curl python3.5 \
		python3-pip \
		bzip2 \
		libfreetype6 \
		libgl1-mesa-dev \
		libglu1-mesa \
		libxi6 \
		bash \
      		fluxbox \
      		git \
      		net-tools \
      		novnc \
      		socat \
      		supervisor \
      		x11vnc \
      		xterm \
      		xvfb \
		libxrender1 && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*

RUN pip3 install PyYaml
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"
ENV SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID 
ENV BLENDER_MAJOR 2.79
ENV BLENDER_VERSION 2.79
ENV BLENDER_BZ2_URL https://mirror.clarkson.edu/blender/release/Blender$BLENDER_MAJOR/blender-$BLENDER_VERSION-linux-glibc219-x86_64.tar.bz2
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes

ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY . ${APP_ROOT}/bin/
RUN cd ${APP_ROOT}/bin/ && mkdir blender && \
	curl -SL "$BLENDER_BZ2_URL" -o blender.tar.bz2 && \
	tar -jxvf blender.tar.bz2 -C ${APP_ROOT}/bin/blender --strip-components=1 && \
	rm blender.tar.bz2	
RUN cd ${APP_ROOT}/bin/blender &&  git clone https://github.com/dfki-ric/phobos.git && cd phobos && git checkout release-1.0 && python3 setup.py --startup-preset

RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
USER 10001
EXPOSE 8008
WORKDIR ${APP_ROOT}

ENTRYPOINT [ "uid_entrypoint" ]
CMD ["bash","entrypoint.sh"]


