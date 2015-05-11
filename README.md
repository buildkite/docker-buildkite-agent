# buildkite-agent

A standard [Docker](https://docker.com/) image for easily running a [Buildkite Agent](https://github.com/buildkite/agent) instance.

If this pre-made image isn't suitable use our standard install instructions for other platforms to install the agent inside your own Docker image.

Usage:

```bash
docker run -it -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent
```

## Containerizing Builds

Note: you don't need to use this image to containerize each build with Docker, you can do this with any of the standard Linux-based installers. See our [Containerizing Builds Guide](https://buildkite.com/docs/guides/containerizing-builds) for more details.

If you want to use the Docker image and have each build be isolated within its own Docker container you’ll need to make the Docker daemon and binary available inside the image. One way to do this is by linking them in directly like so:

```bash
docker run -it \
           -e BUILDKITE_AGENT_TOKEN=xxx \
           -v `which docker`:/usr/bin/docker \
           -v /var/run/docker.sock:/var/run/docker.sock \
           buildkite/agent
```

If you're using boot2docker (or any TCP and TLS Docker setup) you'll need to pass in the certificates and allow host network access:

```bash
docker run -it \
           -e BUILDKITE_AGENT_TOKEN=xxx \
           -e DOCKER_HOST="$DOCKER_HOST" \
           -e DOCKER_CERT_PATH=/certs \
           -e DOCKER_TLS_VERIFY=1 \
           -v `which docker`:/usr/bin/docker \
           -v ~/.boot2docker/certs/boot2docker-vm:/certs \
           --net=host \
           buildkite/agent
```

## Customising The Agent Image

The base image includes Ubuntu, git, the agent, and little else. If you want to add hooks, ssh keys, etc. you can easily extend the base image using our standard [Ubuntu setup instructions](https://buildkite.com/docs/agent/ubuntu).

For example, to add hooks you could copy the hook scripts into the container:

```
FROM buildkite/agent

ADD hooks/* /etc/buildkite-agent/hooks
```

If you need to test private code you could copy the relevant private key into the container, for example:

```
FROM buildkite/agent

ADD repo_access_rsa ~/.ssh/id_rsa
```

## Say Hi

Come and say hi in the #docker channel in the Buildkite Chat slack room!
