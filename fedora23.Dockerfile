FROM fedora:23
MAINTAINER Robpol86 <robpol86@gmail.com>

RUN dnf update -y && \
    dnf install -y @development-tools fedora-packager rpmdevtools dnf-plugins-core

VOLUME ["/RPMS", "/SRPMS", "/SOURCES", "/SPECS"]
ADD build.sh build.sh

ENTRYPOINT ["bash", "build.sh"]
