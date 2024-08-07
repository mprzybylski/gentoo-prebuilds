#    gentoo-prebuilds: Build automation to optimize the size and build-time
#    of gentoo-based container images used for C, C++, and eBPF development
#    Copyright (C) 2024  Michael Przybylski
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
set(GENTOO_REPO_MOUNT_ARG "--mount=type=bind,from=${DOCKER_REPO_PREFIX}/gentoo-mirror-image:${PUSH_TAG},source=/var/db/repos/gentoo,target=/var/db/repos/gentoo,rw")
set(EMERGE_FEATURES "FEATURES='-ipc-sandbox -network-sandbox -pid-sandbox'")

add_subdirectory(gentoo-mirror-image)

add_subdirectory(gentoo-custom-toolchain)
add_subdirectory(gentoo-libbpf-dev-tools)
add_subdirectory(gentoo-libvirt)
add_subdirectory(gentoo-vcpkg-bootstrap-prereqs)

add_subdirectory(gentoo-with-binpkgs)