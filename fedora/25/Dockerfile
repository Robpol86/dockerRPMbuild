FROM fedora:25
MAINTAINER Robpol86 <robpol86@gmail.com>

RUN dnf update -y && \
    dnf install -y @development-tools fedora-packager rpmdevtools dnf-plugins-core wget && \
    useradd rpm && \
    su rpm -lc rpmdev-setuptree && \
    wget https://raw.githubusercontent.com/Robpol86/dockerRPMbuild/master/build.sh

VOLUME ["/RPMS", "/SRPMS", "/SOURCES", "/SPECS"]

ENTRYPOINT ["su", "rpm", "-lc", "--", "bash", "build.sh"]
