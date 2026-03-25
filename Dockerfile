# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2025-02-20T21:42:46Z

FROM ghcr.io/vexxhost/openstack-venv-builder:2024.2@sha256:a0367b6682a517ebf843430f76594c902a850b24b8d6fb94c3052559db613f52 AS build
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
        python-swiftclient
EOF

FROM ghcr.io/vexxhost/python-base:2024.2@sha256:48971cdaff3e6583e2f15810605a3cb42cb16f37c6ddb5d78c325183d00547ca
COPY --from=build --link /var/lib/openstack /var/lib/openstack

# NOTE(mnaser): The Magnum client relies on the SHELL environment variable
#               to determine the shell to use.
ENV SHELL=/bin/bash

# NOTE(mnaser): When we call this container, we mount the current directory
#               into `/opt` and then we can call `openstack` commands.
WORKDIR /opt
