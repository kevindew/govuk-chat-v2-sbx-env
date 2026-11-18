# syntax=docker/dockerfile:1
# Installs the latest uv into /usr/local/bin. Built on the host when the
# sandbox is created, then layered on top of the Claude image.
FROM ghcr.io/astral-sh/uv:latest AS uv

FROM scratch
COPY --from=uv /uv /uvx /usr/local/bin/
