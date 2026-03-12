# syntax=docker/dockerfile:1

ARG UV_VERSION=0.9.17
ARG RUFF_VERSION=0.14.9
ARG APP_NAME=python-template
ARG USERNAME=oceanos
ARG GRP_NAME=ihcantabria
ARG USER_UID=1000
ARG USER_GID=1000



###############################################################################
# BASE - Sistema operativo base con herramientas comunes
###############################################################################
FROM ubuntu:22.04 AS base
LABEL maintainer="German Aragon <german.aragon@unican.es>"

ARG APP_NAME
ARG USERNAME
ARG GRP_NAME
ARG USER_UID
ARG USER_GID

# Evitar prompts durante instalación
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Instalar dependencias del sistema en una sola capa
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        sudo \
        vim \
        zsh \
        locales \
        cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario no-root bajo grupo ihcantabria
RUN groupadd --gid ${USER_GID} ${GRP_NAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
# BUILDKIT=0 crea el WORKDIR con root, así que lo creamos manualmente con nuestro usuairio
RUN mkdir -p /home/${USERNAME}/${APP_NAME}
WORKDIR /home/${USERNAME}/${APP_NAME}


###############################################################################
# DEVELOPMENT - Herramientas de desarrollo (para devcontainer)
###############################################################################
FROM base AS local

ARG APP_NAME
ARG USERNAME
ARG UV_VERSION
ARG RUFF_VERSION
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

USER ${USERNAME}
# Instalar uv (gestor de paquetes Python ultra-rápido)
RUN curl -LsSf https://astral.sh/uv/${UV_VERSION}/install.sh | sh

# Instalar ruff como herramienta global
RUN uv tool install ruff@${RUFF_VERSION}


# Builder stage to isolate Token and GitHub configuration from the final image
FROM local AS builder
ARG USERNAME
ARG GRP_NAME
ARG GITHUB_TOKEN
ARG GITHUB_USER
ARG APP_NAME
ENV WORK_DIR=/home/${USERNAME}/${APP_NAME}
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
COPY --chown=${USERNAME}:${GRP_NAME} .python-version pyproject.toml uv.lock ./
# see https://docs.astral.sh/uv/guides/integration/docker/#using-the-environment

# Configure git to use the provided GitHub token
RUN git config --global url."https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com".insteadOf "https://github.com"
RUN uv sync --frozen --no-dev


from local as deployment

ARG USERNAME
ARG GRP_NAME
ARG APP_NAME
ENV WORK_DIR=/home/${USERNAME}/${APP_NAME}
WORKDIR ${WORK_DIR}

COPY --from=builder ${WORK_DIR}/.venv .venv
COPY --chown=${USERNAME}:${GRP_NAME} ./ .
ENV PATH=${WORK_DIR}/.venv/bin:$PATH


# Run the project
CMD ["python", "-m", "src"]

