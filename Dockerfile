
FROM python:2.7-alpine
EXPOSE 5000

ARG tag=1.3.10
ARG gid=666
ARG uid=666
ARG name=octoprint

WORKDIR /var/octoprint

# In case of alpine
RUN apk update \
 && apk upgrade \
 && apk add --no-cache bash git openssh-client gcc linux-headers musl-dev shadow \
 && rm -rf /var/cache/apk/*

#install ffmpeg static
RUN cd /tmp \
  && wget -O ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz \
	&& mkdir -p /opt/ffmpeg \
	&& tar xvf ffmpeg.tar.xz -C /opt/ffmpeg --strip-components=1 \
  && rm -Rf /tmp/*

#Install Octoprint
RUN pip install git+https://github.com/foosel/OctoPrint.git@${tag}#egg=OctoPrint \
 && rm -rf /root/.cache/pip

RUN groupadd -g ${gid} ${name} \
 && useradd -rNm -s /bin/bash -G dialout -g octoprint -d /var/octoprint -u ${uid} ${name}
RUN chown ${name}:${name} /var/octoprint
USER ${name}

#This fixes issues with the volume command setting wrong permissions
RUN mkdir /var/octoprint/.octoprint

VOLUME /var/octoprint/.octoprint


CMD ["/usr/local/bin/octoprint", "serve"]
