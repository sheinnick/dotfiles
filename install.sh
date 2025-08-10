#!/usr/bin/env bash

set -e

case $OSTYPE in
linux*)
    curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
    curl -L https://iterm2.com/shell_integration/zsh \\n-o ~/.iterm2_shell_integration.zsh

    CONFIG="install_linux.conf.yaml"
    DOTBOT_DIR="dotbot"

    DOTBOT_BIN="bin/dotbot"
    BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    cd "${BASEDIR}"
    git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
    git submodule update --init --recursive "${DOTBOT_DIR}"

    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

	;;
darwin*)
    CONFIG="install.conf.yaml"
    DOTBOT_DIR="dotbot"

    DOTBOT_BIN="bin/dotbot"
    BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    cd "${BASEDIR}"
    git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
    git submodule update --init --recursive "${DOTBOT_DIR}"

    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
    ;;
esac