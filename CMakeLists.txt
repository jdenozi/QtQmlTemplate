# Specify the minimum CMake version required
cmake_minimum_required(VERSION 3.22)

# Project information
project(
        QtQmlTemplate
        VERSION 0.0.1
        DESCRIPTION "Qt qml template"
)

# Set C++ standard to C++20
set(CMAKE_CXX_STANDARD 20)

# Enable automatic MOC (Meta-Object Compiler), RCC (Resource Compiler), and UIC (User Interface Compiler)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# List of Qt components used by the project
set(QTCOMMON_QT_COMPONENTS
        Concurrent
        Core
        Gui
        Network
        Qml
        Quick
        Widgets
        Test
        Multimedia
        WebView
)

# Define the Qt resource file that contains assets for library
set(PROJECT_QT_RESOURCE "assets/assets.qrc")

# Define the names of the executable and the library
add_executable(${PROJECT_NAME}  ${SOURCES})

# Include additional CMake modules
include("${CMAKE_CURRENT_LIST_DIR}/cmake/AdditionalDependencies.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/AutoQtQml.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/cmake/Config.cmake")

# Link QtCommon to the executable and configure binary path
link_qt_common_to_target(${PROJECT_NAME})
config_target(${PROJECT_NAME})

# Include additional dependencies for the executable
include_fetch_content_dependencies(${PROJECT_NAME})

# Link QtCommon to the library and configure binary path
link_qt_common_to_target(${PROJECT_NAME})
config_target(${PROJECT_NAME})

# Include additional dependencies for the library
include_fetch_content_dependencies(${PROJECT_NAME})

# Set target properties for accessing assets from the "assets" directory
set_target_properties(${PROJECT_NAME} PROPERTIES TARGET_ASSETS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/assets/)
