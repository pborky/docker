#!/bin/bash

. vars.sh
. functions.sh

for v in ${VOLUMES//,/ }; do
    host_dir=$(cut -d: -f1 < <(echo $v))
    chmod g+rwxs $host_dir
    chmod -R g+w $host_dir
done

docker run --name $CONT_NAME -d --restart unless-stopped \
           $(for v in ${VOLUMES//,/ }; do echo -v $v ; done) \
           $(for d in ${DEVICES//,/ }; do echo --device $d ; done) \
           $(for p in ${PUBLISH_PORTS//,/ }; do echo -p 127.0.0.1:$p:$p ; done) \
           $TAG_BASE $@

