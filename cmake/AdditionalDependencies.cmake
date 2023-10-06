include(FetchContent)

function(include_fetch_content_dependencies TARGET)
    set(CMAKE_AUTOMOC OFF)
    set(CMAKE_AUTORCC OFF)
    set(CMAKE_AUTOUIC OFF)

    # Add Google test lib
    FetchContent_Declare(googletest
            GIT_REPOSITORY https://github.com/google/googletest.git
            GIT_TAG main
    )
    FetchContent_MakeAvailable(googletest)

    # Add fmt lib
    FetchContent_Declare(fmt
            GIT_REPOSITORY https://github.com/fmtlib/fmt.git
            GIT_TAG 7.1.3
    )
    FetchContent_MakeAvailable(fmt)

    # Add json nlohmann lib
    FetchContent_Declare(json
            GIT_REPOSITORY https://github.com/nlohmann/json
            GIT_TAG v3.11.2
    )
    FetchContent_MakeAvailable(json)

    target_include_directories(${TARGET} PRIVATE ${fmt_SOURCE_DIR}/include)

    target_link_libraries(${TARGET}
            PRIVATE
            gtest
            gtest_main
            fmt::fmt
            nlohmann_json::nlohmann_json
    )

    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)
    set(CMAKE_AUTOUIC ON)

    message(STATUS "FMT added on ${TARGET}")
    message(STATUS "GTest added on ${TARGET}")
    message(STATUS "nlohmann added on ${TARGET}")
endfunction()
