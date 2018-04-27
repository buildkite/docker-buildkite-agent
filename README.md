# Docker Images for buildkite-agent

**Originally this repository contained the source for the docker images for [Buildkite Agent](https://github.com/buildkite/agent), but they are now built as part of that project. See https://github.com/buildkite/agent/tree/master/packaging/docker/linux.**

## Usage

```bash
docker pull buildkite/agent:3.0
docker run buildkite/agent:3.0 --help
```

## Versioning

The default tag (i.e. `buildkite/agent` and `buildkite/agent:latest`) will always point to the latest stable release (currently 3.x).

We recommend you use `buildkite/agent:3` for new setups.

If you want to use an exact version of Buildkite Agent you can use the corresponding tag, such as `buildkite/agent:3.0.1`.

You can see all the available versions on https://hub.docker.com/r/buildkite/agent/tags/.

## Configuring the agent

Most [agent configuration settings](https://buildkite.com/docs/agent/configuration) can be set with environment variables. Setting sensitive data, (such as the agent token) via environment variables or command line arguments _is not recommended_ as they are exposed in commands such as `docker inspect`.

In addition to environment variables, you can copy or mount a configuration file to `/etc/buildkite-agent/buildkite-agent.cfg`, for example:

```bash
docker run -it \
  -v "$HOME/buildkite-agent.cfg:/etc/buildkite-agent/buildkite-agent.cfg:ro" \
  buildkite/agent:3
```

## Adding hooks

You can add [custom agent hooks](https://buildkite.com/docs/agent/hooks) by mounting or copying them into the `/buildkite/hooks` directory (and ensuring they are executable).

For example, this is how you'd mount the hooks directory using a read-only host volume:

```bash
docker run -it \
  -v "$HOME/buildkite-hooks:/buildkite/hooks:ro" \
  buildkite/agent:3
```

Alternatively, if you create your own image based off `buildkite/agent`, you can copy your hooks into the correct location:

```dockerfile
FROM buildkite/agent

ADD hooks /buildkite/hooks/
```

## Exposing build secrets into the container

There are many approaches to exposing secrets to Docker containers. In addition, many Docker platforms have their own methods for exposing secrets. If you’re running your own Docker containers, we recommend using a read-only [host volume](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume).

The following example mounts a directory containing secrets on the host machine (`$HOME/buildkite-secrets`) into the container as a read-only data volume at `/buildkite-secrets`:

```bash
docker run -it \
  -v "$HOME/buildkite-secrets:/buildkite-secrets:ro" \
  buildkite/agent:3
```

You can then use an `environment` [agent hook](https://buildkite.com/docs/agent/hooks) to expose those secrets via environment variables, or to configure tools such as `git` or `ssh`.

## Authenticating private git repositories

To configure a [git-credentials file](https://git-scm.com/docs/git-credential-store#_storage_format) located at `/buildkite-secrets/git-credentials`, you could use the following `environment` [agent hook](https://buildkite.com/docs/agent/hooks) mounted to `/buildkite/hooks/environment`:

```bash
#!/bin/bash

set -euo pipefail

git config --global credential.helper "store --file=/buildkite-secrets/git-credentials"

# You can export other secrets here too
# export FOO=bar
```

To configure a private SSH key located at `/buildkite-secrets/id_rsa_buildkite_git` you could use the following `environment` [agent hook](https://buildkite.com/docs/agent/hooks) mounted to `/buildkite/hooks/environment`:

```bash
#!/bin/bash

set -euo pipefail

eval "$(ssh-agent -s)"
ssh-add -k /buildkite-secrets/id_rsa_buildkite_git

# You can export other secrets here too
# export FOO=bar
```

Other options for configuring Git and SSH include:

* Running `ssh-agent` on the host machine and mounting the ssh-agent socket into the containers. See the [Buildkite Agent SSH keys documentation](https://buildkite.com/docs/agent/ssh-keys) for examples on using ssh-agent.
* The least-secure approach: the built-in [docker-ssh-env-config](https://github.com/buildkite/docker-ssh-env-config) support allows you to pass in keys via environment variables.

## Invoking Docker from within a build

To invoke Docker from within builds you'll need to mount the Docker socket into the container:

```bash
docker run -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  buildkite/agent:3
```

Note that this gives builds the same access to the host system as docker has, which is generally root.

## Entrypoint customizations

The entrypoint uses `tini` to correctly pass signals to, and kill, sub-processes. Instead of redefining `ENTRYPOINT` we recommend you copy executable scripts into `/docker-entrypoint.d/`. All executable scripts should not contain any file extension, and will be executed in alphanumeric order.

## Say hi!

Come and say hi in the #docker channel in the [Buildkite Chat](https://chat.buildkite.com) slack room!
