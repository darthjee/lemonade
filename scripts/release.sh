#!/bin/bash

function isLatestCommit() {
  VERSION=$(git tag | grep $(getVersion))

  if [[ $VERSION ]]; then
    return 0
  else
    return 1
  fi
}

function getVersion() {
  git describe --tags
}

function isAlreadyBuilt() {
  if ( make VERSION=$(getVersion) pull ); then
    echo "Image already exists"
    exit 1
  else
    exit 0
  fi
}

if $(isLatestCommit); then
  echo "latest commit";
else
  echo "Not last commit"
  exit 0
fi

ACTION=$1

case $ACTION in
  "check-built")
    isAlreadyBuilt
    ;;
  "build")
    make VERSION=$(getVersion) build
    ;;
  "docker-login")
    docker login -u $DOCKER_USER -p $DOCKER_TOKEN
    ;;
  "release")
    make VERSION=$(getVersion) push
    ;;
  *)
    echo Usage:
    echo "$0 build # builds docker"
    ;;
esac
