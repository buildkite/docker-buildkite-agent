# buildkite-agent

Docker images for the [Buildkite Agent](https://github.com/buildkite/agent). A variety of builds are provided, based on the version of Buildkite, the base operating system and whether docker and docker-compose is installed on the image.

> If you don't need to run the agent on a purely Docker-based operating system (such as Kubernetes), and instead just want to [run your builds inside Docker containers](https://buildkite.com/docs/guides/docker-containerized-builds), then we recommend using one of the standard installers (such as `apt`). See the [containerized builds guide](https://buildkite.com/docs/guides/docker-containerized-builds) for more information.

The Buildkite Agent is available via an Alpine Linux based image, with either the stable, beta or experimental versions of the Buildkite Agent, with or without docker:

 * Stable agents: `latest`, `alpine`, `alpine-docker-1.11`
 * Beta agents: `beta`, `beta-alpine`, `beta-alpine-docker-1.11`
 * Experimental agents: `edge`, `edge-alpine`, `edge-alpine-docker-1.11`

If in doubt, go with `buildkite/agent`—it's the smallest, most stable, and includes the docker client.

For older versions of Docker (such as `1.9`) see the [complete tag list on Docker Hub](https://hub.docker.com/r/buildkite/agent/tags).

## Basic example

For most simple cases, we recommend our minimal Alpine Linux based build. It has a minimal footprint and the latest docker client installed.

```bash
docker run -it \
  -e BUILDKITE_AGENT_TOKEN=xxx \
  buildkite/agent
```

## Invoking Docker from within a build

To invoke Docker from within builds you'll need to mount the Docker socket into the container:

```bash
docker run -it \
  -e BUILDKITE_AGENT_TOKEN=xxx \
  -v /var/run/docker.sock:/var/run/docker.sock \
  buildkite/agent
```

It is also possible, but not recommended, to use Docker-in-Docker by setting the `DIND` environment variable and the `--privileged` flag. You can also specify arguments for the inner Docker daemon using `DOCKER_DAEMON_ARGS`.

```bash
docker run -it \
  -e BUILDKITE_AGENT_TOKEN=xxx \
  --privileged \
  -e DIND=true \
  -e DOCKER_DAEMON_ARGS="-s overlay" \
  buildkite/agent
```

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
