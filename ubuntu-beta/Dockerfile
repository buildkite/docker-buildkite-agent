FROM buildkite/agent:ubuntu
MAINTAINER Tim Lucas <tim@buildkite.com>
# BK-TAG: beta-ubuntu

RUN DESTINATION=/buildkite BETA=true bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"
