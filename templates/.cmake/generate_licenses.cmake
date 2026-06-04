if(NOT DEFINED VCPKG_SHARE_DIR)
    message(FATAL_ERROR "VCPKG_SHARE_DIR is not defined")
endif()

if(NOT DEFINED LICENSE_OUTPUT)
    message(FATAL_ERROR "LICENSE_OUTPUT is not defined")
endif()

set(OUTPUT_TEXT
    "Third Party Licenses
====================

This file contains license notices for third-party libraries.")

file(GLOB PORT_DIRS LIST_DIRECTORIES true "${VCPKG_SHARE_DIR}/*")

foreach(PORT_DIR ${PORT_DIRS})
    if(IS_DIRECTORY "${PORT_DIR}" AND EXISTS "${PORT_DIR}/copyright")
        get_filename_component(PORT_NAME "${PORT_DIR}" NAME)
        file(READ "${PORT_DIR}/copyright" LICENSE_TEXT)

        set(OUTPUT_TEXT "${OUTPUT_TEXT}
============================================================
${PORT_NAME}
============================================================
${LICENSE_TEXT}")
    endif()
endforeach()

file(WRITE "${LICENSE_OUTPUT}" "${OUTPUT_TEXT}")

message(STATUS "Generated: ${LICENSE_OUTPUT}")