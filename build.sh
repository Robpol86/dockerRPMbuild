#!/bin/bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

# Prepare VOLUME symlinks.
for name in RPMS SRPMS SOURCES SPECS; do
    rmdir "~/rpmbuild/$name"
    ln -s "/$name" "~/rpmbuild/$name"
done

# Install build dependencies and download source files for every spec file.
for f in ~/rpmbuild/SPECS/*.spec; do
    dnf builddep -y --spec "$f"
    spectool -g "$f" -C ~/rpmbuild/SOURCES
done

# Build all RPMs.
for f in ~/rpmbuild/SPECS/*.spec; do
    rpmbuild -ba "$f"
done
