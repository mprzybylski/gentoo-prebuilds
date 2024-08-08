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
cmake_minimum_required(VERSION 3.28.1)
project(gentoo-prebuilds)

include(docker_build_target.cmake)

set(DOCKER_REPO_PREFIX "mikeprz")
# See https://hub.docker.com/r/gentoo/stage3/tags?page=&page_size=&ordering=-name&name=2024
set(GENTOO_STAGE3_TAG 20240805)

set(CACHE_FROM_TAGS "main-${GENTOO_STAGE3_TAG}-buildcache" "release-${GENTOO_STAGE3_TAG}-buildcache")

if("$ENV{CI}" STREQUAL true)
    string(REPLACE / _ GITHUB_REF_NAME "$ENV{GITHUB_REF_NAME}")

    #Pull redundant instances of GENTOO_STAGE3_TAG out of GITHUB_REF_NAME
    string(REPLACE "-${GENTOO_STAGE3_TAG}" "" GITHUB_REF_NAME "${GITHUB_REF_NAME}")

    if(RELEASE_TAG AND NOT BUILD_NUMBER)
        set(PUSH_TAG "${RELEASE_TAG}")
    elseif(BUILD_NUMBER AND NOT RELEASE_TAG)
        set(PUSH_TAG "${GITHUB_REF_NAME}-${GENTOO_STAGE3_TAG}-snapshot-${BUILD_NUMBER}")
    else()
        message(FATAL_ERROR "BUILD_NUMBER or RELEASE_TAG must be set when running in CI, (but not both).")
    endif()

    set(CACHE_TO_TAG "${GITHUB_REF_NAME}-${GENTOO_STAGE3_TAG}-buildcache")
    list(APPEND CACHE_FROM_TAGS "${CACHE_TO_TAG}")
else()
    set(PUSH_TAG "${GENTOO_STAGE3_TAG}-snapshot")
endif()



add_subdirectory(docker)
