
function(link_qt_common_to_target TARGET)

    find_package(Qt5 COMPONENTS ${QTCOMMON_QT_COMPONENTS} REQUIRED)
    foreach(QT_COMPONENT ${QTCOMMON_QT_COMPONENTS})
        message("-- [Link] Qt5::${QT_COMPONENT}")
        target_link_libraries(${TARGET} PRIVATE "Qt5::${QT_COMPONENT}")
        target_include_directories(${TARGET} PRIVATE ${Qt5${QT_COMPONENT}_INCLUDE_DIRS})
    endforeach()

    # Create modules qmldir files
    function(create_modules_qmldir_files ROOT_DIR)
        file(GLOB MODULE_FILES "${ROOT_DIR}/*")
        list(FILTER MODULE_FILES EXCLUDE REGEX "(qmldir$)|(internal$)")

        foreach(MODULE_FILE ${MODULE_FILES})
            if(IS_DIRECTORY "${MODULE_FILE}")
                list(FILTER MODULE_FILES EXCLUDE REGEX "^${MODULE_FILE}$")
                create_modules_qmldir_files("${MODULE_FILE}")
            endif()
        endforeach()

        list(FILTER MODULE_FILES INCLUDE REGEX "\\.qml$")

        if (NOT MODULE_FILES)
            return()
        endif()

        file(GLOB MODULES_INTERNAL_FILES "${ROOT_DIR}/internal/*")

        get_filename_component(MODULE_NAME "${ROOT_DIR}" NAME)
        set(QMLDIR_FILE_CONTENT "module ${MODULE_NAME}\n")
        foreach(MODULE_FILE ${MODULE_FILES})
            file(READ "${MODULE_FILE}" MODULE_FILE_CONTENT LIMIT 16)
            get_filename_component(MODULE_FILE_NAME "${MODULE_FILE}" NAME_WLE)
            if("${MODULE_FILE_CONTENT}" STREQUAL "pragma Singleton\n")
                set(QMLDIR_FILE_CONTENT "${QMLDIR_FILE_CONTENT}\nsingleton ${MODULE_FILE_NAME} 1.0 ${MODULE_FILE_NAME}.qml")
            else()
                set(QMLDIR_FILE_CONTENT "${QMLDIR_FILE_CONTENT}\n${MODULE_FILE_NAME} 1.0 ${MODULE_FILE_NAME}.qml")
            endif()
        endforeach()

        set(QMLDIR_FILE_CONTENT "${QMLDIR_FILE_CONTENT}\n")

        foreach(MODULES_INTERNAL_FILE ${MODULES_INTERNAL_FILES})
            get_filename_component(MODULES_INTERNAL_FILE_NAME "${MODULES_INTERNAL_FILE}" NAME_WLE)
            set(QMLDIR_FILE_CONTENT "${QMLDIR_FILE_CONTENT}\ninternal ${MODULES_INTERNAL_FILE_NAME} internal/${MODULES_INTERNAL_FILE_NAME}.qml")
        endforeach()

        file(WRITE "${ROOT_DIR}/qmldir" "${QMLDIR_FILE_CONTENT}")
    endfunction()

    create_modules_qmldir_files(${CMAKE_CURRENT_SOURCE_DIR}/assets/modules)

    # Create assets qrc file
    function(create_assets_qrc_file)
        file(GLOB_RECURSE ASSETS_FILES ${CMAKE_CURRENT_SOURCE_DIR}/assets/*)
        list(FILTER ASSETS_FILES EXCLUDE REGEX "${CMAKE_CURRENT_SOURCE_DIR}/assets/assets.qrc")

        set(ASSETS_FILE_CONTENT "<RCC>\n    <qresource prefix=\"/\">")
        foreach(ASSET_FILE ${ASSETS_FILES})
            file(RELATIVE_PATH ASSET_FILE ${CMAKE_CURRENT_SOURCE_DIR}/assets "${ASSET_FILE}")
            set(ASSETS_FILE_CONTENT "${ASSETS_FILE_CONTENT}\n        <file>${ASSET_FILE}</file>")
        endforeach()
        set(ASSETS_FILE_CONTENT "${ASSETS_FILE_CONTENT}\n    </qresource>\n</RCC>")
        file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/assets/assets.qrc" "${ASSETS_FILE_CONTENT}")
    endfunction()
    create_assets_qrc_file()
    target_sources(${TARGET} PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/assets/assets.qrc" ${${TARGET}_QT_QRC} ${${TARGET}_QT_QML})

endfunction()