
FROM python:2.7-alpine as base

FROM base AS build

ARG tag=1.3.10
ARG repo=https://github.com/foosel/OctoPrint.git

# build dependencies
RUN apk add --no-cache --update bash git gcc linux-headers musl-dev shadow openssh-client \
 && rm -rf /var/cache/apk/*

#install ffmpeg static
#RUN cd /tmp \
# && wget -O ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz \
#       && mkdir -p /opt/ffmpeg \
#       && tar xvf ffmpeg.tar.xz -C /opt/ffmpeg --strip-components=1 \
#  && rm -Rf /tmp/*

#Install Octoprint
RUN pip install --no-warn-script-location --no-cache-dir --compile --prefix /install --prefer-binary \
                git+${repo}@${tag}#egg=OctoPrint \
 && find /install -type f -name '*.py' -exec rm "{}" +

FROM base

# UID and GID of new user
ARG uid=666
ARG gid=666
ARG user=octoprint
# GIDs to grant access rights for the new user
ARG gids=
# home directory
ARG home=/var/octoprint

WORKDIR $${home}

# run dependencies
RUN apk add --no-cache --update bash musl ffmpeg \
 && rm -rf /var/cache/apk/*

COPY --from=build /install /usr/local

# add new user and set groups
RUN addgroup -g ${gid} -S ${user} \
 && adduser -SHD --home ${home} -G ${user} -u ${uid} ${user} \
 && for g in ${gids//,/ }; do \
      if ! grep -q "[^:]*[:][^:]*[:]$g[:]" /etc/group; then \
        echo "New group grp$g"; \
        addgroup -g $g -S grp$g && adduser $user grp$g; \
      fi; \
    done

#This fixes issues with the volume command setting wrong permissions
RUN mkdir -p ${home}/.octoprint
RUN chown -R ${user}:${user} ${home}
VOLUME ${home}/.octoprint

# switch user
USER ${user}

ENTRYPOINT ["/usr/local/bin/octoprint", "serve"]

