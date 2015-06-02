# buildkite-agent

Docker images for the [Buildkite Agent](https://github.com/buildkite/agent). There is a minimal Alpine Linux based image suitable for running Docker-based builds, and a larger Ubuntu based image.

Available tags:

* `latest` ([source](https://github.com/buildkite/docker-buildkite-agent/blob/master/Dockerfile)) - Alpine Linux
* `ubuntu` ([source](https://github.com/buildkite/docker-buildkite-agent/blob/master/ubuntu/Dockerfile)) - Ubuntu
* `dind` ([source](https://github.com/buildkite/docker-buildkite-agent/blob/master/dind/Dockerfile)) - Ubuntu


## Alpine Linux

This default image is based off Alpine Linux and includes git and Docker Compose. Its minimal footprint and small size makes it ideal for running agents that do Docker-based builds.

```bash
docker run -it -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent
```

## Ubuntu

This image is based on Ubuntu 14.04 and includes git and Docker Compose. Use this if you need a full Ubuntu environment.

```bash
docker run -it -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent:ubuntu
```

## Docker-in-Docker

This image is identical to the Ubuntu image, except that it has docker running inside it. This requires the `--privileged` flag and is extremely experimental.

```bash
docker run -it --privileged -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent:ubuntu
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


## Docker-based Builds

If you want each build to be isolated within its own Docker container, you have two options. The safest route is to use the same docker daemon which is running the agent to run containerized builds:

```bash
docker run -it \
           -e BUILDKITE_AGENT_TOKEN=xxx \
           -v `which docker`:/usr/bin/docker \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v /buildkite:/buildkite \
           buildkite/agent
```

Note that `/buildkite` is mounted in so that there is path parity between the agent container and the host system. This is because the container refers to the host system's docker, so any volume mounts need to be based on the host systems filesystem.

The alternative is docker-in-docker which runs a docker environment within the agent's container. The upside of this is that it's much conceptually simpler and path mapping isn't required. The downside is that it's an experimental side project of the docker team and needs to be run with the `-privileged` flag.

```bash
docker run -it --privileged \
           -e BUILDKITE_AGENT_TOKEN=xxx \
           buildkite/agent:dind
```

## Say hi!

Come and say hi in the #docker channel in the [Buildkite Chat](https://slack.buildkite.com) slack room!
