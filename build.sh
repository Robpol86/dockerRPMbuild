#!/bin/bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

green () {
    echo -e "\x1b[32m$1\x1b[0m"
}

yellow () {
    echo -e "\x1b[33m$1\x1b[0m"
}

# Prepare VOLUME symlinks.
yellow "Prepare VOLUME symlinks..."
for name in RPMS SRPMS SOURCES SPECS; do
    rmdir "~/rpmbuild/$name"
    ln -s "/$name" "~/rpmbuild/$name"
done

# Install build dependencies and download source files for every spec file.
yellow "Install build dependencies/download source files..."
for f in ~/rpmbuild/SPECS/*.spec; do
    dnf builddep -y --spec "$f"
    spectool -g "$f" -C ~/rpmbuild/SOURCES
done

# Build all RPMs.
yellow "Build RPMs..."
for f in ~/rpmbuild/SPECS/*.spec; do
    rpmbuild -ba "$f"
done

green "Success"
