#!/bin/bash

set -e  # Exit script if a command fails.
set -u  # Treat unset variables as errors and exit immediately.
set -x  # Print commands run by script to standard out.
set -o pipefail  # Exit script if any piped program fails instead of just the last program.

# Install build dependencies and download source files for every spec file.
for f in ~/rpmbuild/SPECS/*.spec; do
    dnf builddep -y --spec "$f"
    spectool -g "$f" -C ~/rpmbuild/SOURCES
done

# Build all RPMs.
for f in ~/rpmbuild/SPECS/*.spec; do
    rpmbuild -ba "$f"
done
