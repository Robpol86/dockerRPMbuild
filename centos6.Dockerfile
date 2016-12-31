FROM centos:6
MAINTAINER Robpol86 <robpol86@gmail.com>

RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y centos-packager rpmdevtools yum-utils

VOLUME ["/RPMS", "/SRPMS", "/SOURCES", "/SPECS"]
ADD build.sh build.sh

RUN useradd rpm && \
    su rpm -lc rpmdev-setuptree && \
    su rpm -lc 'for d in RPMS SRPMS SOURCES SPECS; do rmdir rpmbuild/$d; ln -s /$d $_; done'

ENTRYPOINT ["bash", "build.sh"]
