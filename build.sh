#!/bin/bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

error () {
    >&2 echo -e "\x1b[31m$1\x1b[0m"
    exit 1
}

BUILD_USER="${BUILD_USER:-rpm}"

# Create non-root user to build RPMs with with same UID set by docker for writable volume directories.
uid="0"
for d in /RPMS /SRPMS /SOURCES /SPECS; do
    uid=$(stat -c '%u' "$d")
    [ "$uid" != "0" ] && break
done
[ "$uid" != "0" ] && useradd "$BUILD_USER" -u "$uid" || useradd "$BUILD_USER"

# Setup directories and permissions.
chown rpm /RPMS /SRPMS /SOURCES /SPECS
su rpm -lc rpmdev-setuptree
su rpm -lc 'for d in RPMS SRPMS SOURCES SPECS; do rmdir rpmbuild/$d; ln -s /$d $_; done'

# Print directory contents.
ls -la /home/${BUILD_USER}/rpmbuild
for d in /home/${BUILD_USER}/rpmbuild/*; do
    ls -la "$d/"
done

# Install source RPMs if any.
for f in /home/${BUILD_USER}/rpmbuild/SRPMS/*.src.rpm; do
    [ -e "$f" ] && su rpm -lc "rpm -i $f"
done

# Check if we have at least one spec file.
compgen -G "/home/${BUILD_USER}/rpmbuild/SPECS/*.spec" || error "No spec files in /home/$BUILD_USER/rpmbuild/SPECS"

# Install build dependencies and download source files for every spec file.
for f in /home/${BUILD_USER}/rpmbuild/SPECS/*.spec; do
    if type dnf &> /dev/null; then
        dnf builddep -y --spec "$f"
    else
        yum-builddep -y "$f"
    fi
    su ${BUILD_USER} -lc "spectool -g '$f' -C rpmbuild/SOURCES"
done

# Build all RPMs.
for f in /home/${BUILD_USER}/rpmbuild/SPECS/*.spec; do
    su ${BUILD_USER} -lc "rpmbuild -ba '$f'"
done

echo "Success"
