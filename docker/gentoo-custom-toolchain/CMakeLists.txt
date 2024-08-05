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

configure_file(Dockerfile.in Dockerfile @ONLY)

if(NOT "$ENV{CI}" STREQUAL true)
    set(TOOLCHAIN_DEPENDS gentoo-mirror-image)
endif()

add_docker_build(gentoo-custom-toolchain "${CMAKE_CURRENT_BINARY_DIR}"
        TAG "${DOCKER_REPO_PREFIX}/gentoo-custom-toolchain:${GENTOO_STAGE3_TAG}"
        DEPENDS ${TOOLCHAIN_DEPENDS})