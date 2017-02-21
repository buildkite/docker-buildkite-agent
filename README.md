# buildkite-agent

Docker images for the [Buildkite Agent](https://github.com/buildkite/agent). A variety of builds are provided, based on the version of Buildkite, the base operating system and whether docker and docker-compose is installed on the image.

> If you don't need to run the agent on a purely Docker-based operating system (such as Kubernetes), and instead just want to [run your builds inside Docker containers](https://buildkite.com/docs/guides/docker-containerized-builds), then we recommend using one of the standard installers (such as `apt`). See the [containerized builds guide](https://buildkite.com/docs/guides/docker-containerized-builds) for more information.

The Buildkite Agent is built on Alpine Linux, with either the stable, beta or experimental versions of the Buildkite Agent:

 * Stable agents: `latest`, `stable`, `2`, `2.3`, `2.3.2`
 * Beta agents: `beta`, `3`, `3.0`, `3.0-beta.16`
 * Latest master agents: `edge`

If in doubt, go with `buildkite/agent` — it's the most stable, and includes the docker client.

Also included in the image: `docker 1.13 (client)`, `docker-compose 1.10.0`, `tini`, `su-exec` and `jq`.

## Basic example

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

Note that this gives builds the same access to the host system as docker has, which is generally root. 

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

## Entrypoint customizations

The entrypoint uses `tini` to correctly pass signals to, and kill, sub-processes. Instead of redefining `ENTRYPOINT` we recommend you copy executable scripts into `/docker-entrypoint.d/`. All executable scripts in that directory will be executed in alphanumeric order.

## Say hi!

Come and say hi in the #docker channel in the [Buildkite Chat](https://chat.buildkite.com) slack room!
