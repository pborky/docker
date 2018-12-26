#!/bin/bash

. vars.sh 
. functions.sh

# get host volumes' and devices' gids
VOL_GIDS=($(get_host_dir_groups $VOLUMES))
DEV_GIDS=($(get_host_dir_groups $DEVICES))

# get the group ids from group names
GIDS=($(get_gid $CONT_GROUPS))

# combine, sort, uniqe
GIDS="$(merge_unique_int DEV_GIDS[@] VOL_GIDS[@] GIDS[@])"
# change to coma separated string
GIDS="${GIDS// /,}"

echo GIDS: $GIDS

BUILD_ARGS="\
          --build-arg home=$CONT_HOME \
          --build-arg gids=$GIDS \
          --build-arg uid=$CONT_UID \
          --build-arg gid=$CONT_GID \
          --build-arg user=$CONT_USER"

if [ -z "$1" ]; then
  # try to get latest branch
  if [ ! -z "$GITHUB_REPO" ]; then
    TAG=$(get_latest "$GITHUB_REPO")
    GIT="https://github.com/$GITHUB_REPO.git"
    BUILD_ARGS="$BUILD_ARGS --build-arg repo=$GIT"
  fi
  # fallback
  if [ -z "$TAG" ]; then
    TAG="master"
  fi
  BUILD_ARGS="$BUILD_ARGS --build-arg tag=$TAG"
  echo "TAG: $TAG (latest)"
  docker build . --tag=$TAG_BASE $BUILD_ARGS
  docker build . --tag=$TAG_BASE:$TAG $BUILD_ARGS
else
  TAG=$1
  BUILD_ARGS="$BUILD_ARGS --build-arg tag=$TAG"
  echo "TAG: $TAG"
  docker build . --tag=$TAG_BASE:$TAG $BUILD_ARGS
fi

