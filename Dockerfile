FROM ubuntu:22.04

ARG OCTEZ_VERSION=21.0
ARG SMARTPY_VERSION=0.18.2
ARG LIGO_VERSION=0.72.0

ENV DEBIAN_FRONTEND=noninteractive
ENV TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=Y

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    bash \
    python3 \
    python3-pip \
    ca-certificates \
    jq \
    shellcheck \
    && rm -rf /var/lib/apt/lists/*

# Install octez-client
# The binary is available from the Tezos GitLab releases page.
# Pin the version via the ARG above.
RUN wget -q "https://gitlab.com/tezos/tezos/-/releases/v${OCTEZ_VERSION}/downloads/octez-client" \
    -O /usr/local/bin/octez-client \
    && chmod +x /usr/local/bin/octez-client

# Install SmartPy
RUN mkdir -p /opt/smartpy \
    && curl -sSL "https://smartpy.io/cli/install.sh" | bash -s -- --prefix /opt/smartpy --version "${SMARTPY_VERSION}"
ENV SMARTPY=/opt/smartpy

# Install Ligo
RUN wget -q "https://gitlab.com/ligolang/ligo/-/releases/${LIGO_VERSION}/downloads/ligo" \
    -O /usr/local/bin/ligo \
    && chmod +x /usr/local/bin/ligo
ENV LIGO=/usr/local/bin/ligo

# Set up octez-client data directory
RUN mkdir -p /root/.tezos-client
ENV TEZOSCLIENT="octez-client -d /root/.tezos-client"

# Copy framework
WORKDIR /app
COPY . /app

# Make scripts executable
RUN find /app -name "*.sh" -exec chmod +x {} +

ENTRYPOINT ["/app/_framework/execute_all.sh"]
CMD ["latest"]
