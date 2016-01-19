#!/bin/bash -eu

: ${SSH_ENV_CONFIG_COMMIT="$2"}
: ${OS=$(uname -s)}
: ${ARCH=$(uname -m)}

install_ssh_env_config() {
  curl -fL "https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/${SSH_ENV_CONFIG_COMMIT}/ssh-env-config.sh" -o /usr/local/bin/ssh-env-config.sh
  chmod +x /usr/local/bin/ssh-env-config.sh
}

install_beta() {
  BETA=true DESTINATION=/buildkite bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"
}

install_edge() {
  curl -fL "https://download.buildkite.com/builds/$OS/$ARCH/buildkite-agent-edge" -o /usr/local/bin/buildkite-agent
  chmod +x /usr/local/bin/buildkite-agent
}

install_stable() {
  DESTINATION=/buildkite bash -c "`curl -sL https://raw.githubusercontent.com/buildkite/agent/master/install.sh`"
}

echo "Installing ssh-env-config"
install_ssh_env_config

case "$1" in
stable) echo "Installing stable buildkite"
    install_stable
    ;;
beta) echo "Installing beta buildkite"
    install_beta
    ;;
edge) echo "Installing edge buildkite"
    install_edge
    ;;
esac
