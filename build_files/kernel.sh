#!/bin/bash

set -ouex pipefail

## Enable Linux Surface Repository
curl -Lo /etc/yum.repos.d/linux-surface.repo https://pkg.surfacelinux.com/fedora/linux-surface.repo

dnf5 update
mkdir kernel-rpms
cd kernel-rpms

kernel_packages=(
  "kernel-surface-${kernel_version}"
  "kernel-surface-core-${kernel_version}"
  "kernel-surface-modules-${kernel_version}"
  "kernel-surface-modules-core-${kernel_version}"
  "kernel-surface-modules-extra-${kernel_version}"
  "kernel-surface-default-watchdog-${kernel_version}"
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
    kernel-surface-"$KERNEL_VERSION".rpm \
    kernel-surface-core-"$KERNEL_VERSION".rpm \
    kernel-surface-modules-"$KERNEL_VERSION".rpm \
    kernel-surface-modules-core-"$KERNEL_VERSION".rpm \
    kernel-surface-modules-extra-"$KERNEL_VERSION".rpm \
    kernel-surface-default-watchdog-"$KERNEL_VERSION".rpm \

cd -
rm -rf kernel-rpms
