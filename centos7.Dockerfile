FROM centos:7
MAINTAINER Robpol86 <robpol86@gmail.com>

RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y centos-packager rpmdevtools

RUN useradd rpm && \
    mkdir /RPMS /SRPMS /SOURCES && \
    chown rpm:rpm /RPMS /SRPMS /SOURCES && \
    su rpm -lc rpmdev-setuptree && \
    su rpm -lc 'for d in RPMS SRPMS SOURCES SPECS; do rmdir rpmbuild/$d; ln -s /$d $_; done'

VOLUME ["/RPMS", "/SRPMS", "/SOURCES", "/SPECS"]
ADD build.sh build.sh

ENTRYPOINT ["bash", "build.sh"]
