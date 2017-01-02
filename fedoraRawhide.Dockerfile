FROM fedora:rawhide
MAINTAINER Robpol86 <robpol86@gmail.com>

RUN dnf update -y && \
    dnf install -y @development-tools fedora-packager rpmdevtools dnf-plugins-core

RUN useradd rpm && \
    mkdir /RPMS /SRPMS /SOURCES && \
    chown rpm:rpm /RPMS /SRPMS /SOURCES && \
    su rpm -lc rpmdev-setuptree && \
    su rpm -lc 'for d in RPMS SRPMS SOURCES SPECS; do rmdir rpmbuild/$d; ln -s /$d $_; done'

VOLUME ["/RPMS", "/SRPMS", "/SOURCES", "/SPECS"]
ADD build.sh build.sh

ENTRYPOINT ["bash", "build.sh"]
