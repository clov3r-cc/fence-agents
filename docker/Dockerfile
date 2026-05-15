FROM opensuse/leap:16.0

RUN zypper in -y \
    git \
    autoconf \
    automake \
    libtool \
    make \
    gcc \
    corosync-devel \
    libxslt1 \
    libxslt-tools \
    python313 \
    python313-devel \
    python313-pip \
    python313-httplib2 \
    python313-pexpect \
    python313-pycurl \
    python313-requests \
    python313-boto3 \
    python3-openwsman \
    mozilla-nss-devel \
    mozilla-nspr-devel \
    libvirt-devel \
    libxml2-devel \
    flex \
    bison \
    libuuid-devel \
    systemd && \
    pip3 install \
    suds-community \
    python-novaclient \
    python-keystoneclient \
    pyinstaller

WORKDIR /code
VOLUME /code
ENTRYPOINT ["./docker/entrypoint.sh"]
