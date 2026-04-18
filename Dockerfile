FROM ubuntu:24.04 AS builder

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    pkg-config \
    libnss3-dev \
    libxml2-dev \
    uuid-dev \
    libxml2-utils \
    xsltproc \
    python3-pexpect \
    python3-pycurl \
    python3-requests \
    python3-pip \
    autoconf \
    automake \
    libtool \
    gcc \
    g++ \
    make

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install pyinstaller --break-system-packages

WORKDIR /src

RUN --mount=type=bind,source=.,target=/src,readwrite \
    echo "4.15.0" > .tarball-version && \
    rm -rf autom4te.cache configure && \
    ./autogen.sh && \
    ./configure --with-agents=pve && \
    make -C lib && \
    make -C agents pve/fence_pve && \
    PYTHONPATH=lib pyinstaller --onefile --distpath /tmp/dist agents/pve/fence_pve

FROM scratch
COPY --from=builder /tmp/dist/fence_pve /fence_pve
ENTRYPOINT ["/fence_pve"]
