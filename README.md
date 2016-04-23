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

## Invoking Docker from within a build

There are two ways of calling Docker from within a Docker build:

* Expose the Docker host inside the container, usually by mounting `/var/run/docker.sock` via the Docker compose config or from your own bash script. This is supported by all the agent docker images, but has the downside that you’re basically giving root access to the build containers.
* Use Docker-in-Docker to create a separate Docker daemon inside the container. This is supported only by the `-docker` versions of the agent docker images. This has the downside that each build has it’s own separate image cache.

## Docker-in-Docker

This image is identical to the Ubuntu image, except that it has docker running inside it. This requires the `--privileged` flag.

```bash
docker run -it --privileged -e DIND=true -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent:ubuntu-docker
```

If you simply want to use the docker client in a docker image, you can drop the `DIND` environment variable and the `--privileged` flag.

You can specify arguments for the inner Docker daemon using the `DOCKER_DAEMON_ARGS`, for example `-e DOCKER_DAEMON_ARGS="-s overlay"`

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

## SSH Configuration

There are many approaches to exposing secrets, such as SSH keys, into containers.

One approach is to run `ssh-agent` on the host machine and mount the ssh-agent socket into the containers. See the [Buildkite Agent SSH keys documentation](https://buildkite.com/docs/agent/ssh-keys) for examples on using ssh-agent.

A less-recommended approach is to use the built-in [docker-ssh-env-config](https://github.com/buildkite/docker-ssh-env-config) which allows you to enble SSH debug output, set known hosts, and set private keys via environment variables. See [its readme](https://github.com/buildkite/docker-ssh-env-config#readme) for usage details.

Another approach is to use the [environment agent hook](https://buildkite.com/docs/agent/hooks) to pull down the key into the container’s file system before the `git checkout` occurs. Note: the key will exist in Docker’s file system unless it is destroyed.

## Say hi!

Come and say hi in the #docker channel in the [Buildkite Chat](https://chat.buildkite.com) slack room!
