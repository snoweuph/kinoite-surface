#!/bin/bash

set -ouex pipefail

## Enable Linux Surface Repository
curl -Lo /etc/yum.repos.d/linux-surface.repo https://pkg.surfacelinux.com/fedora/linux-surface.repo

dnf5 update -y
mkdir kernel-rpms
cd kernel-rpms

kernel_packages=(
    "kernel-surface-$KERNEL_VERSION"
    "kernel-surface-core-$KERNEL_VERSION"
    "kernel-surface-modules-$KERNEL_VERSION"
    "kernel-surface-modules-core-$KERNEL_VERSION"
    "kernel-surface-modules-extra-$KERNEL_VERSION"
    "kernel-surface-default-watchdog-$KERNEL_VERSION"
    "iptsd-3-1.fc41.x86_64"
    "libwacom-surface-2.13.0-2.fc41.x86_64"
    "libwacom-surface-data-2.13.0-2.fc41.noarch"
    "libwacom-surface-utils-2.13.0-2.fc41.x86_64"
)

for package in "${kernel_packages[@]}"; do
    dnf5 download "$package"
done

## Install Surface kernel
rpm-ostree override replace \
    --experimental \
    --remove kernel \
    --remove kernel-core \
    --remove kernel-modules \
    --remove kernel-modules-core \
    --remove kernel-modules-extra \
    --remove kernel-uki-virt \
    --remove libwacom \
    --remove libwacom-data \
    kernel-surface-"$KERNEL_VERSION".rpm \
    kernel-surface-core-"$KERNEL_VERSION".rpm \
    kernel-surface-modules-"$KERNEL_VERSION".rpm \
    kernel-surface-modules-core-"$KERNEL_VERSION".rpm \
    kernel-surface-modules-extra-"$KERNEL_VERSION".rpm \
    kernel-surface-default-watchdog-"$KERNEL_VERSION".rpm \
    libwacom-surface*.rpm \
    iptsd*.rpm

cd -
rm -rf kernel-rpms
