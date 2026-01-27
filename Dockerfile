# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2024-06-25T22:49:25Z

FROM ghcr.io/vexxhost/openstack-venv-builder:2025.1@sha256:32de46806f1572a155bea8599663d5fd6ad845561e8701976907443afb9d50c5 AS build
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
        python-swiftclient \
        tap-as-a-service
EOF

FROM ghcr.io/vexxhost/python-base:2025.1@sha256:ceac7dca50150b63e46b4fb42956a1cae1a4f145f25e73428af56d5131ceb49d
COPY --from=build --link /var/lib/openstack /var/lib/openstack

# NOTE(mnaser): The Magnum client relies on the SHELL environment variable
#               to determine the shell to use.
ENV SHELL=/bin/bash

# NOTE(mnaser): When we call this container, we mount the current directory
#               into `/opt` and then we can call `openstack` commands.
WORKDIR /opt
