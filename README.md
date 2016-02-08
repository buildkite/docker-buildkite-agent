# buildkite-agent

Docker images for the [Buildkite Agent](https://github.com/buildkite/agent). A variety of builds are provided, based on the version of Buildkite, the base operating system and whether docker and docker-compose is installed on the image.

At present we provide a variety of images based on Ubuntu or Alpine Linux base images, then with either the stable, beta or edge version of the Buildkite Agent, with or without docker:

 * `latest`, `alpine`, `ubuntu`, `ubuntu-docker-1.10`
 * `beta`, `beta-alpine`, `beta-ubuntu`, `beta-ubuntu-docker-1.10`
 * `edge`, `edge-alpine`, `edge-ubuntu`, `edge-ubuntu-docker-1.10`

If in doubt, go with `buildkite/agent:latest`, it's the smallest, the most stable and includes a docker client. Older versions of the docker images are built back to 1.6.2.

## Basic example

For most simple cases, we recommend our minimal Alpine Linux based build. It has a minimal footprint and the latest docker client installed.

```bash
docker run -it -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent
```

## Ubuntu

This image is based on Ubuntu 14.04 and includes git and docker-compose. Use this if you need a full Ubuntu environment.

```bash
docker run -it -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent:ubuntu
```

## Docker-in-Docker

This image is identical to the Ubuntu image, except that it has docker running inside it. This requires the `--privileged` flag.

```bash
docker run -it --privileged -e DIND=true -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent:ubuntu-docker
```

If you simply want to use the docker client in a docker image, you can drop the `DIND` environment and the `--privileged` flag.

## Adding Hooks

You can add custom hooks by copying (or mounting) them into the correct hooks directory, for example:

```
FROM buildkite/agent

ADD hooks /buildkite/hooks/
```

## Configuring

Almost all agent settings can be set with environment variables. Alternatively you can copy (or mount) a configuration file into the container, for example:

```
FROM buildkite/agent
ADD buildkite-agent.cfg /buildkite/buildkite-agent.cfg
ENV BUILDKITE_AGENT_CONFIG=/buildkite/buildkite-agent.cfg
```

## Third Party Images

* [blueimp/buildkite-agent](https://github.com/blueimp/buildkite-agent) is a minimal Docker-in-Docker (dind) image based on Alpine Linux and includes docker, docker-compose, python, pip, git, bash and openssh-client. It supports running docker isolated or bind-mounting the host docker socket, and can accept private SSH keys via environment variables.

## Say hi!

Come and say hi in the #docker channel in the [Buildkite Chat](https://chat.buildkite.com) slack room!
