if(NOT DEFINED VCPKG_SHARE_DIR OR NOT DEFINED LICENSE_OUTPUT)
    message(FATAL_ERROR "Missing variables")
endif()

file(WRITE "${LICENSE_OUTPUT}"
"Third Party Licenses
====================

This file contains license notices for third-party libraries.
")

file(GLOB PORT_DIRS "${VCPKG_SHARE_DIR}/*")

foreach(PORT_DIR ${PORT_DIRS})
    if(EXISTS "${PORT_DIR}/copyright")

        get_filename_component(PORT_NAME "${PORT_DIR}" NAME)

        file(APPEND "${LICENSE_OUTPUT}"
"\n\n============================================================\n")
        file(APPEND "${LICENSE_OUTPUT}" "${PORT_NAME}\n")
        file(APPEND "${LICENSE_OUTPUT}"
"============================================================\n\n")

        file(READ "${PORT_DIR}/copyright" LICENSE_TEXT)

        file(APPEND "${LICENSE_OUTPUT}" "${LICENSE_TEXT}")
    endif()
endforeach()

message(STATUS "Generated: ${LICENSE_OUTPUT}")