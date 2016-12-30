#!/bin/bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

BUILD_USER="${BUILD_USER:-rpm}"

# Install build dependencies and download source files for every spec file.
for f in /home/${BUILD_USER}/rpmbuild/SPECS/*.spec; do
    dnf builddep -y --spec "$f"
    su ${BUILD_USER} -lc "spectool -g '$f' -C rpmbuild/SOURCES"
done

# Build all RPMs.
for f in /home/${BUILD_USER}/rpmbuild/SPECS/*.spec; do
    su ${BUILD_USER} -lc "rpmbuild -ba '$f'"
done

echo "Success"
