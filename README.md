# Docker Images for buildkite-agent

[![Build status](https://badge.buildkite.com/5ab4d67e882c6ab2cf988790ec23f13c1913ebb9aaee2502d2.svg)](https://buildkite.com/buildkite/docker-buildkite-agent)

Docker images for the [Buildkite Agent](https://github.com/buildkite/agent). 

> If you don't need to run the agent on a purely Docker-based operating system (such as Kubernetes), and instead just want to [run your builds inside Docker containers](https://buildkite.com/docs/guides/docker-containerized-builds), then we recommend using one of the standard installers (such as `apt`). See the [containerized builds guide](https://buildkite.com/docs/guides/docker-containerized-builds) for more information.

The Buildkite Agent is built on Alpine Linux, with either the stable, beta or experimental versions of the Buildkite Agent:

 * Stable agents: `latest`, `stable`, `2`
 * Beta agents: `beta`, `3`
 * Latest master agents: `edge`

If in doubt, go with `buildkite/agent` — it's the most stable, and includes the docker client. Minor versions are also tagged, e.g `3.0-beta.16` if you want to make sure nothing changes. 

Also included in the image are `docker 1.13 (client)`, `docker-compose 1.10.0`, `tini`, `su-exec` and `jq`.

## Basic example

```bash
docker run -it buildkite/agent start
```

## Securely configuring your agent

Environment variables and command line arguments are insecure. The recommended way to set your agent token is to mount a data volume containing a [Buildkite Agent configuration file](https://buildkite.com/docs/agent/configuration).

Here's an example showing how to create a `buildkite-config` container that you can use with the `--volumes-from` to securely get your agent token (and any other secrets you require) into the container:

```shell
$ docker create --name buildkite-config -v /buildkite/config bash
2ddff324267a8e322678870779580805185add70ca9634092bbafd3b4423c879
$ docker run -it --rm --volumes-from buildkite-config bash
bash-4.4# echo 'token=xxx' >> /buildkite/config/buildkite-agent.cfg
bash-4.4# echo 'name=agent-%n' >> /buildkite/config/buildkite-agent.cfg
bash-4.4# echo 'meta-data=somekey=someval' >> /buildkite/config/buildkite-agent.cfg
bash-4.4# exit
exit
$ docker run -d --name=buildkite-agent-1 --volumes-from buildkite-config buildkite/agent start --config /buildkite/config/buildkite-agent.cfg
7da6569ff14cc177a01421040fdd296e9f6926a8eff8ec2e8f31964218dfbc3d
$ docker run -d --name=buildkite-agent-2 --volumes-from buildkite-config buildkite/agent start --config /buildkite/config/buildkite-agent.cfg
c830dd341044d30f2e4488e6d28b2c3bd2c2f0030907ea3b12b4e33523587845
```

## Invoking Docker from within a build

To invoke Docker from within builds you'll need to mount the Docker socket into the container:

```bash
docker run -it \
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

Another approach is to use a [Docker data volume](https://docs.docker.com/engine/tutorials/dockervolumes/) to store the secrets, and mount it into the container using `--volumes-from`.

A less-recommended approach is to use the built-in [docker-ssh-env-config](https://github.com/buildkite/docker-ssh-env-config) which allows you to enble SSH debug output, set known hosts, and set private keys via environment variables. See [its readme](https://github.com/buildkite/docker-ssh-env-config#readme) for usage details.

Another approach is to use the [environment agent hook](https://buildkite.com/docs/agent/hooks) to pull down the key into the container’s file system before the `git checkout` occurs. Note: the key will exist in Docker’s file system unless it is destroyed.

## Entrypoint customizations

The entrypoint uses `tini` to correctly pass signals to, and kill, sub-processes. Instead of redefining `ENTRYPOINT` we recommend you copy executable scripts into `/docker-entrypoint.d/`. All executable scripts in that directory will be executed in alphanumeric order.

## Say hi!

Come and say hi in the #docker channel in the [Buildkite Chat](https://chat.buildkite.com) slack room!
