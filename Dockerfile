# syntax=docker/dockerfile:1.9
FROM ubuntu:noble AS build

# The following does not work in Podman unless you build in Docker
# compatibility mode: <https://github.com/containers/podman/issues/8477>
# You can manually prepend every RUN script with `set -ex` too.
SHELL ["sh", "-exc"]

### Start build prep.
### This should be a separate build container for better reuse.

RUN <<EOT
apt-get update -qy
apt-get install -qyy \
    -o APT::Install-Recommends=false \
    -o APT::Install-Suggests=false \
    build-essential \
    ca-certificates \
    python3-setuptools \
    python3.12-dev
EOT

# Security-conscious organizations should package/review uv themselves.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# - Silence uv complaining about not being able to use hard links,
# - tell uv to byte-compile packages for faster application startups,
# - prevent uv from accidentally downloading isolated Python builds,
# - pick a Python,
# - and finally declare `/app` as the target for `uv sync`.
ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=python3.12 \
    UV_PROJECT_ENVIRONMENT=/app

### End build prep -- this is where your app Dockerfile should start.

# Since there's no point in shipping lock files, we move them
# into a directory that is NOT copied into the runtime image.
# The trailing slash makes COPY create `/_lock/` automagically.
COPY pyproject.toml /_lock/
COPY uv.lock /_lock/

# Synchronize DEPENDENCIES without the application itself.
# This layer is cached until uv.lock or pyproject.toml change.
# You can create `/app` using `uv venv` in a separate `RUN`
# step to have it cached, but with uv it's so fast, it's not worth
# it, so we let `uv sync` create it for us automagically.
RUN --mount=type=cache,target=/root/.cache <<EOT
cd /_lock
uv sync \
    --locked \
    --no-dev \
    --no-install-project
EOT

# Now install the APPLICATION from `/src` without any dependencies.
# `/src` will NOT be copied into the runtime container.
# LEAVE THIS OUT if your application is NOT a proper Python package.
# As of uv 0.4.11, you can also use
# `cd /src && uv sync --locked --no-dev --no-editable` instead.
COPY . /src
RUN --mount=type=cache,target=/root/.cache \
    uv pip install \
        --python=$UV_PROJECT_ENVIRONMENT \
        --no-deps \
        /src

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]



