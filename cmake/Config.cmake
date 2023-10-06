function(config_target TARGET)

    # Add automatic version file
    configure_file(
            include/version.h.in
            include/version.h
    )

    # Enable compiler errors
    if (MSVC)
        target_compile_options(${TARGET} PRIVATE /W3 /wd4668 /wd5240 /wd4820 /WX /Zc:preprocessor /D_CRT_SECURE_NO_WARNINGS /std:c++20)
    else()
        target_compile_options(${TARGET} PRIVATE -Wall -Wextra -pedantic -Werror -isystem /usr/lib/llvm-project/include/c++/v1/ -std=c++20)

        # Force static libc
        target_link_options(${TARGET} PRIVATE -static-libstdc++ -static-libgcc)
    endif()

    # Disable compiler extensions and enforce C++ standard version
    set_target_properties(
            ${TARGET} PROPERTIES
            CXX_STANDARD_REQUIRED ON
            CXX_EXTENSIONS OFF
    )

    target_include_directories(${TARGET} PRIVATE ${CMAKE_BINARY_DIR}/include)

    # Set include directories
    target_include_directories(${TARGET} PUBLIC
            include
            ${CMAKE_CURRENT_BINARY_DIR}/include
    )

    # Create source file
    file(GLOB_RECURSE SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/include/* ${CMAKE_CURRENT_SOURCE_DIR}/src/*)
    set(SOURCES_FILE_CONTENT "target_sources(\n    ${TARGET} PRIVATE")
    foreach(SOURCE_FILE ${SOURCES})
        file(RELATIVE_PATH SOURCE_FILE_REL ${CMAKE_CURRENT_SOURCE_DIR} ${SOURCE_FILE})
        set(SOURCES_FILE_CONTENT "${SOURCES_FILE_CONTENT}\n    ${SOURCE_FILE_REL}")
    endforeach()
    set(SOURCES_FILE_CONTENT "${SOURCES_FILE_CONTENT}\n)")

    # Creating a file called CMakeLists-sources.cmake in the build directory and then including it.
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/CMakeLists-sources.cmake" "${SOURCES_FILE_CONTENT}")
    include("${CMAKE_CURRENT_BINARY_DIR}/CMakeLists-sources.cmake")

    # Determine the output directory based on platform and architecture
    if(WIN32)
        if(CMAKE_SIZEOF_VOID_P EQUAL 8)
            set(ARCHITECTURE_DIR "x64")
        else()
            set(ARCHITECTURE_DIR "x86")
        endif()
    elseif(UNIX)
        if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
            set(ARCHITECTURE_DIR "x64")
        else()
            set(ARCHITECTURE_DIR "x86")
        endif()
    else()
        set(ARCHITECTURE_DIR "")
    endif()

    if(UNIX)
        set(PLATFORM_DIR "linux")
    elseif(WIN32)
        set(PLATFORM_DIR "windows")
    endif()

    # Set the output directory for the executable
    set_target_properties(${TARGET} PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin/${PLATFORM_DIR}/${ARCHITECTURE_DIR}"
            LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib/${PLATFORM_DIR}/${ARCHITECTURE_DIR}"
            ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib/${PLATFORM_DIR}/${ARCHITECTURE_DIR}"
    )

endfunction()