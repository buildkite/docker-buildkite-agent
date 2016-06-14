#!/bin/bash

set -eo pipefail

## Download all the required buildkite files to be copied into docker builds

agent_release() {
  local arch="$1"
  local release="${2:-stable}"
  local url
  local extraargs=""

  if [[ $release == "beta" ]] ; then
    extraargs="&prerelease=true"
  fi

  url=$(curl -fs "https://buildkite.com/agent/releases/latest?platform=linux&arch=${arch}${extraargs}" \
  	| awk -F= '/url/ { print $2}')

  echo $url
}

download() {
  local url="$1"
  local file="$2"
  printf "\nDownloading $url\n"

  # use last modified to avoid redownloading if possible
  if [[ -f $file ]] ; then
    curl -Lf "$url" -z "$file" -o "$file"
  else
    curl -Lf "$url"  -o "$file"
  fi
}

cd $(dirname $0)/../
mkdir -p assets
cd assets/

download https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh ssh-env-config.sh
chmod +x ssh-env-config.sh

download "$(agent_release amd64)" stable-amd64.tar.gz
rm -rf stable-amd64/
mkdir -p stable-amd64/
tar xzvf stable-amd64.tar.gz -C stable-amd64/
chmod +x stable-amd64/buildkite-agent

download "$(agent_release amd64 beta)" beta-amd64.tar.gz
rm -rf beta-amd64/
mkdir -p beta-amd64/
tar xzvf beta-amd64.tar.gz -C beta-amd64/
chmod +x beta-amd64/buildkite-agent

rm -rf edge-amd64/
mkdir -p edge-amd64/
download "https://download.buildkite.com/agent/experimental/latest/buildkite-agent-linux-amd64" edge-amd64/buildkite-agent
chmod +x edge-amd64/buildkite-agent
