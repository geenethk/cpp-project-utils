cmake_minimum_required(VERSION %VERSION_HERE%)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/.bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/.bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/.bin)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SOURCE_FILES
)

project(%PROJECT_NAME_HERE%)

add_executable(%PROJECT_NAME_HERE% ${SOURCE_FILES})

# --------------------------------------------------
# Generate THIRD_PARTY_LICENSES.txt
# --------------------------------------------------

if(DEFINED VCPKG_INSTALLED_DIR AND DEFINED VCPKG_TARGET_TRIPLET)
    set(VCPKG_SHARE_DIR
        "${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/share")

    set(LICENSE_OUTPUT
        "${CMAKE_BINARY_DIR}/THIRD_PARTY_LICENSES.txt")

    file(WRITE "${LICENSE_OUTPUT}"
		"Third Party Licenses
		====================

		This file contains license notices for third-party
		libraries distributed with this application.")

    file(GLOB PORT_DIRS
        "${VCPKG_SHARE_DIR}/*")

    foreach(PORT_DIR ${PORT_DIRS})
		if(EXISTS "${PORT_DIR}/copyright")

            get_filename_component(
                PORT_NAME
                "${PORT_DIR}"
                NAME
            )

            file(APPEND "${LICENSE_OUTPUT}"
					"\n\n============================================================\n")

            file(APPEND "${LICENSE_OUTPUT}"
					"${PORT_NAME}\n")

            file(APPEND "${LICENSE_OUTPUT}"
					"============================================================\n\n")

            file(READ
                "${PORT_DIR}/copyright"
                LICENSE_TEXT)

            file(APPEND
                "${LICENSE_OUTPUT}"
                "${LICENSE_TEXT}")
        endif()

    endforeach()

    message(STATUS
        "Generated: ${LICENSE_OUTPUT}")
else()
    message(WARNING
        "vcpkg variables not available. "
        "THIRD_PARTY_LICENSES.txt will not be generated.")
endif()

# --------------------------------------------------
# Install
# --------------------------------------------------

install(TARGETS %PROJECT_NAME_HERE%)

if(EXISTS "${CMAKE_BINARY_DIR}/THIRD_PARTY_LICENSES.txt")
    install(
        FILES "${CMAKE_BINARY_DIR}/THIRD_PARTY_LICENSES.txt"
        DESTINATION .
    )
endif()