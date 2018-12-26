
FROM python:2.7-alpine

ARG tag=1.3.10
ARG repo=https://github.com/foosel/OctoPrint.git

# UID and GID of new user
ARG uid=666
ARG gid=666
ARG user=octoprint
# GIDs to grant access rights for the new user
ARG gids=666
# home directory
ARG home=/var/octoprint

WORKDIR $${home}

# In case of alpine
RUN apk update \
 && apk upgrade \
 && apk add --no-cache --update bash git gcc linux-headers musl-dev shadow openssh-client ffmpeg \
 && rm -rf /var/cache/apk/*

#install ffmpeg static
#RUN cd /tmp \
# && wget -O ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz \
#       && mkdir -p /opt/ffmpeg \
#       && tar xvf ffmpeg.tar.xz -C /opt/ffmpeg --strip-components=1 \
#  && rm -Rf /tmp/*

#Install Octoprint
RUN pip install git+${repo}@${tag}#egg=OctoPrint \
 && rm -rf /root/.cache/pip

# add new user and set groups
RUN groupadd -g ${gid} ${user} \
 && useradd -rNm -s /bin/bash -d ${home} -g ${user} -u ${uid} ${user} \
 && for g in ${gids//,/ }; do \
      echo "New group grp$g"; \
      groupadd -g $g grp$g && usermod -aG grp$g ${user}; \
    done

#This fixes issues with the volume command setting wrong permissions
RUN mkdir ${home}/.octoprint
RUN chown -R ${user}:${user} ${home}
VOLUME ${home}/.octoprint

# switch user
USER ${user}

ENTRYPOINT ["/usr/local/bin/octoprint", "serve"]

