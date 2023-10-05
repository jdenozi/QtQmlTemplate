cmake_minimum_required(VERSION 3.22)

project(
    qtQmlTemplate
    VERSION 0.0.1
    DESCRIPTION "Qt qml template that fully automize the qrc / qml file cmake import"
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(
    ${PROJECT_NAME}_QT_QRC
    assets/assets.qrc
)

set(
    ${PROJECT_NAME}_QT_QML
    assets/assets.qrc
)

find_package(Qt5 COMPONENTS
        Core
        Gui
        Widgets
        Qml
        REQUIRED)

# Add automatic version file
configure_file(
        include/version.h.in
        include/version.h
)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
        main.cpp
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp"
        )


add_executable(${PROJECT_NAME} ${SOURCES})

include("${CMAKE_CURRENT_LIST_DIR}/cmake/AutoQtQml.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/Config.cmake")

link_qt_common_to_target(${PROJECT_NAME})
config_target_bin_path(${PROJECT_NAME})

target_link_libraries(${PROJECT_NAME}
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::Qml
        )

