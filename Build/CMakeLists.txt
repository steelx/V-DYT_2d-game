cmake_minimum_required(VERSION 3.6)

project(pakya_biker_del)
set_directory_properties(PROPERTIES VS_STARTUP_PROJECT pakya_biker_del)

set(projectRoot "C:/Users/Ajinkya/GameMakerProjects/pakya_biker_del")

set(source ${CMAKE_CURRENT_SOURCE_DIR}/source.rsp)

message("${source}")

# Load the script list, and remove the tildes from event scripts We need to
# check for UTF-16LE first for certain formattings and then fall back to utf8
# (default) if file was unable to parse
file(STRINGS ${source} scriptList ENCODING UTF-16LE)
if(NOT scriptList)
  file(STRINGS ${source} scriptList)
endif()

list(TRANSFORM scriptList REPLACE "~" "" OUTPUT_VARIABLE scriptPaths)

# Add the source list and each of the scripts to the project, so they appear in
# the IDE
add_custom_target(pakya_biker_del ALL SOURCES ${source} ${scriptPaths})

# This could be replaced with source_group(TREE ...) if we assume all scripts to
# be under the same directory
foreach(scriptPath ${scriptPaths})
  message("${scriptPath}")
  get_filename_component(scriptDirectory "${scriptPath}" DIRECTORY)
  cmake_path(RELATIVE_PATH scriptDirectory BASE_DIRECTORY "${projectRoot}"
             OUTPUT_VARIABLE relPath)
  # Remove the "../" from the beginning of the relative path
  string(REPLACE "../" "" filterPath "${relPath}")
  source_group("${filterPath}" FILES "${scriptPath}")
endforeach()

set_target_properties(
  "pakya_biker_del"
  PROPERTIES VS_DEBUGGER_COMMAND "${CMAKE_CURRENT_BINARY_DIR}/pakya_biker_del")

set_target_properties("pakya_biker_del" PROPERTIES OUTPUT_NAME
                                                           "pakya_biker_del")

# set_target_properties(pakya_biker_del PROPERTIES
# VS_DEBUGGER_COMMAND_ARGUMENTS
# --wad="${CMAKE_CURRENT_BINARY_DIR}/pakya_biker_del0.wad")

# FIXME :: Erin find_package(YYTools REQUIRED)

# separate_arguments(GMC_ARGS)

if(DEBUG_TOOLCHAIN)
  add_custom_command(
    TARGET "pakya_biker_del"
    COMMAND
      "${YY_DEBUG_TOOLS_DIR}/gmcd" $<$<BOOL:${DEBUG_SCRIPTS}>:-g> -rtdebug -di
      -execution-mode=${SCRIPT_EXECUTION_MODE}
      -bd="${CMAKE_CURRENT_BINARY_DIR}/out" "${USE_CUSTOM_INTERPRETER}"
      "${GMC_ARGS}" -t ${TRIPLE_NAME} ${COMPILE_MODE_FLAGS} @${source} -l
      "${YY_DEBUG_LIBS_DIR}/${TRIPLE_NAME}" -l "${CMAKE_CURRENT_SOURCE_DIR}" -o
      "${CMAKE_CURRENT_BINARY_DIR}/pakya_biker_del"
    COMMENT "Building Executable")
else()
  add_custom_command(
    TARGET "pakya_biker_del"
    COMMAND
      "${YY_RELEASE_TOOLS_DIR}/gmc" $<$<BOOL:${DEBUG_SCRIPTS}>:-g> -di
      -execution-mode=${SCRIPT_EXECUTION_MODE}
      -bd="${CMAKE_CURRENT_BINARY_DIR}/out" "${USE_CUSTOM_INTERPRETER}"
      "${GMC_ARGS}" -t ${TRIPLE_NAME} ${COMPILE_MODE_FLAGS} @${source} -l
      "${YY_RELEASE_LIBS_DIR}/${TRIPLE_NAME}" -l "${CMAKE_CURRENT_SOURCE_DIR}"
      -o "${CMAKE_CURRENT_BINARY_DIR}/pakya_biker_del"
    COMMENT "Building Executable")
endif()
