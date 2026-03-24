# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2024-06-26T17:38:39Z

FROM ghcr.io/vexxhost/openstack-venv-builder:2023.1@sha256:e1b3db6a27effb0d389881b9a47d8e743802e428a335f92fc52e1293fbf61403 AS build
RUN <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        osc-placement \
        python-barbicanclient \
        python-designateclient \
        python-glanceclient \
        python-heatclient \
        python-ironicclient \
        python-magnumclient \
        python-manilaclient \
        python-neutronclient \
        python-octaviaclient \
        python-openstackclient \
        python-senlinclient \
        python-swiftclient
EOF

FROM ghcr.io/vexxhost/python-base:2023.1@sha256:324057ed04d83f12aa9bbbef0b5e92e82004b6a41a90b1277e3aba05b30414c3
COPY --from=build --link /var/lib/openstack /var/lib/openstack

# NOTE(mnaser): The Magnum client relies on the SHELL environment variable
#               to determine the shell to use.
ENV SHELL=/bin/bash

# NOTE(mnaser): When we call this container, we mount the current directory
#               into `/opt` and then we can call `openstack` commands.
WORKDIR /opt
