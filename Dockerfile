# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2025-10-14T10:18:12Z

FROM ghcr.io/vexxhost/openstack-venv-builder:2025.2@sha256:5f71266af26b2e9d7a5bb1635bd7de1085bcc96b170c2ed52808fda92371385f AS build
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

FROM ghcr.io/vexxhost/python-base:2025.2@sha256:b2801c0991cc2466bf345c7df5f3aac9a163ee430e0f5b826af2dd2d5363d5c0
COPY --from=build --link /var/lib/openstack /var/lib/openstack

# NOTE(mnaser): The Magnum client relies on the SHELL environment variable
#               to determine the shell to use.
ENV SHELL=/bin/bash

# NOTE(mnaser): When we call this container, we mount the current directory
#               into `/opt` and then we can call `openstack` commands.
WORKDIR /opt
