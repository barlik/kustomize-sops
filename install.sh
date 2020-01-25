#!/usr/bin/env bash
set -eu
PLUGIN_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}/kustomize/plugin
PLUGIN_RESOURCE_VERSION=barlik/v1/sopssecret
PLUGIN_DEST=$PLUGIN_HOME/$PLUGIN_RESOURCE_VERSION/SopsSecret

# check for dependencies
if ! python -c 'import yaml'; then
        echo 'Error: PyYAML python package not found.'
        exit 1
fi

mkdir -p "$(dirname $PLUGIN_DEST)"
cp SopsSecret "$PLUGIN_DEST"
chmod +x "$PLUGIN_DEST"
echo "SopsSecret plugin installed to ${PLUGIN_DEST}"
