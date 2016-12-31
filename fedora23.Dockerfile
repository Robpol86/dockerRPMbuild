FROM fedora:23
MAINTAINER Robpol86 <robpol86@gmail.com>

RUN dnf update -y && \
    dnf install -y @development-tools fedora-packager rpmdevtools dnf-plugins-core

VOLUME ["/RPMS", "/SRPMS", "/SOURCES", "/SPECS"]
ADD build.sh build.sh

RUN useradd rpm && \
    su rpm -lc rpmdev-setuptree && \
    su rpm -lc 'for d in RPMS SRPMS SOURCES SPECS; do rmdir rpmbuild/$d; ln -s /$d $_; done'

ENTRYPOINT ["bash", "build.sh"]
