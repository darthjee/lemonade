#!/bin/bash

function isLatestCommit() {
  VERSION=$(git tag | grep $(git describe  --tags))

  if [[ $VERSION ]]; then
    return 0
  else
    return 0
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
  "build")
    make build
    ;;
  *)
    echo Usage:
    echo "$0 build # builds docker"
    ;;
esac
