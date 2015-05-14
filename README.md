# buildkite-agent

Docker images for the [Buildkite Agent](https://github.com/buildkite/agent). There is a minimal Alpine Linux based image suitable for running Docker-based builds, and a larger Ubuntu based image.

Available tags:

* `latest` ([source](https://github.com/buildkite/docker-buildkite-agent/blob/master/Dockerfile)) - Alpine Linux
* `ubuntu` ([source](https://github.com/buildkite/docker-buildkite-agent/blob/master/ubuntu/Dockerfile)) - Ubuntu

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

## Adding Hooks

You can add custom hooks by copying (or mounting) them into the correct hooks directory, for example:

```
FROM buildkite/agent

Add hooks /buildkite/hooks/
```

## Configuring

Almost all agent settings can be set with environment variables. Alternatively you can copy (or mount) a configuration file into the container:

```
FROM buildkite/agent

ADD buildkite-agent.cfg /buildkite/buildkite-agent.cfg
ENV BUILDKITE_AGENT_CONFIG=/buildkite/buildkite-agent.cfg
```


## Docker-based Builds

If you want each build to be isolated within its own Docker container you’ll need to make the Docker daemon and binary available inside the image. One way to do this is by mounting them into the container:

```bash
docker run -it \
           -e BUILDKITE_AGENT_TOKEN=xxx \
           -v `which docker`:/usr/bin/docker \
           -v /var/run/docker.sock:/var/run/docker.sock \
           buildkite/agent
```

## Say hi!

Come and say hi in the #docker channel in the [Buildkite Chat](https://slack.buildkite.com) slack room!
