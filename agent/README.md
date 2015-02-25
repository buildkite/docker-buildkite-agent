# buildkite-agent Docker Image

Basic usage:

```
docker run -e -e BUILDKITE_AGENT_TOKEN=xxx buildkite/agent
```

## Doing Docker-based builds

If you want to use buildkite-agent's Docker support you'll need to make Docker available inside the container. You can do this by linking in the binary and the unix socket.

```
docker run -e BUILDKITE_AGENT_TOKEN=xxx \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v `which docker`:/usr/bin/docker \
           buildkite/agent
```

If you're using Docker via a TCP socket (like boot2docker) then you'll need to set the `DOCKER_HOST` environment variable and expose the TCP socket in some way.

## Extending the base image

You can create your own image on the base image to add hooks, ssh keys, etc.

### Adding hooks

Hooks should be copied into `/hooks`. For example:

```
FROM buildkite-agent

ADD hooks/* /hooks
```

### Adding private keys

If you want to check out private code you'll need to copy the access credentials into the container. For example:

```
FROM buildkite-agent

ADD repo_access_rsa ~/.ssh/id_rsa
```
