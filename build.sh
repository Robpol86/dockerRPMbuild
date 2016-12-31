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

# Print directory contents.
ls -la /home/${BUILD_USER}/rpmbuild
for d in /home/${BUILD_USER}/rpmbuild/*; do
    ls -la "$d/"
done

# Check if we have at least one spec file.
for f in /home/${BUILD_USER}/rpmbuild/SPECS/*.spec; do
    [ -e "$f" ] || error "No spec files found in /home/$BUILD_USER/rpmbuild/SPECS"
    break
done

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
