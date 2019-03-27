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


RUN mkdir /usr/local/blender && \
	curl -SL "$BLENDER_BZ2_URL" -o blender.tar.bz2 && \
	tar -jxvf blender.tar.bz2 -C /usr/local/blender --strip-components=1 && \
	rm blender.tar.bz2
	
RUN git clone https://github.com/dfki-ric/phobos.git && cd phobos && git checkout release-1.0 && python3 setup.py --startup-preset
RUN mkdir /app
COPY . /app
ENTRYPOINT ["app/entrypoint.sh"]
EXPOSE 8008
