FROM centos:7
MAINTAINER Robpol86 <robpol86@gmail.com>

RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y centos-packager rpmdevtools

VOLUME ["/RPMS", "/SRPMS", "/SOURCES", "/SPECS"]
ADD build.sh build.sh

ENTRYPOINT ["bash", "build.sh"]
