
FROM python:2.7-alpine
EXPOSE 5000

ARG tag=1.3.10

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
RUN pip install -e git+https://github.com/foosel/OctoPrint.git@${tag}#egg=OctoPrint 

RUN useradd -ms /bin/bash -G dialout -d /var/octoprint -r octoprint
RUN chown octoprint:octoprint /var/octoprint
USER octoprint

#This fixes issues with the volume command setting wrong permissions
RUN mkdir /var/octoprint/.octoprint

VOLUME /var/octoprint/.octoprint


CMD ["/usr/local/bin/octoprint", "serve"]
