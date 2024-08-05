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

# Creates a CMake target that runs docker build with the specified
# Args:
#   <target name> (required)
#   <context_dir> (required)
#   TAG (optional, repo_name:tag argument passed to `docker build -t ...`)
#   DOCKERFILE (optional, path to the dockerfile)
#   BUILD_ARGS (optional, list of "ARG_NAME=VALUE" args to pass to `docker build --build-arg="...")
#   DEPENDS (optional, list of CMake targets that must be built before building this docker build target)
function(add_docker_build)
    if(ARGC LESS 2)
        message(FATAL_ERROR "add_docker_build() requires at least two arguments:\n"
                "A target name, and a path to a docker build context.")
    endif()
    set(TARGET_NAME ${ARGV0})
    set(CONTEXT_DIR ${ARGV1})
    cmake_parse_arguments(
            PARSE_ARGV 2 # Start parsing at 3rd arg.
            ADB #result variable prefix
            "" #options, (keywords without values)
            "TAG;DOCKERFILE" #one-value keywords
            "BUILD_ARGS;DEPENDS" #multi-value keywords
    )

    # Populate the build command
    set(DOCKER_BUILD_CMD docker buildx build)
    if(ADB_TAG)
        list(APPEND DOCKER_BUILD_CMD --tag "${ADB_TAG}")
    endif()
    if(ADB_DOCKERFILE)
        list(APPEND DOCKER_BUILD_CMD --file "${ADB_DOCKERFILE}")
    endif()
    foreach(BUILD_ARG ${ADB_BUILD_ARGS})
        list(APPEND DOCKER_BUILD_CMD --build-arg "${BUILD_ARG}")
        message("Adding build arg '${BUILD_ARG}' to target: ${TARGET_NAME}")
    endforeach ()
    list(APPEND DOCKER_BUILD_CMD "${CONTEXT_DIR}")

    # Create the target
    add_custom_target("${TARGET_NAME}" COMMAND ${DOCKER_BUILD_CMD})

    # Add specified dependencies to the target
    foreach(DEP ${ADB_DEPENDS})
        add_dependencies("${TARGET_NAME}" "${DEP}")
        message("Adding dependency '${DEP}' to target: ${TARGET_NAME}")
    endforeach ()
endfunction()