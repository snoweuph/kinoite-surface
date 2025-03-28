#!/bin/bash

set -ouex pipefail

dnf5 update
mkdir wacom-rpms
cd wacom-rpms

wacom_packages=(
	"iptsd-3-1.fc41.x86_64"
    "libwacom-surface-2.13.0-2.fc41.x86_64"
    "libwacom-surface-data-2.13.0-2.fc41.noarch"
    "libwacom-surface-utils-2.13.0-2.fc41.x86_64"
)

for package in "${wacom_packages[@]}"; do
	dnf5 download "$package"
done

## Install Surface kernel
rpm-ostree override replace \
	--experimental \
	--remove libwacom \
	--remove libwacom-data \
	libwacom-surface* \
	iptsd*

cd -
rm -rf wacom-rpms
