cmake_minimum_required(VERSION 3.25)
project(ncorpos_utilidades_py VERSION 0.0.1 LANGUAGES C Fortran)

option(SKBUILD "Should be ON of being build by skbuild, 
and OFF of being build by regular cmake" OFF)

if (NOT SKBUILD)
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/../cmake/")
endif()

# Safety net
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.\n"
  )
endif()


# ---------------------------------------------------------------------------
# Python
# ---------------------------------------------------------------------------
find_package(Python3 REQUIRED COMPONENTS
  Interpreter
  Development.Module
  NumPy
)

# Grab the variables from a local Python installation
# F2PY headers
execute_process(
  COMMAND "${Python_EXECUTABLE}"
  -c "import numpy.f2py; print(numpy.f2py.get_include())"
  OUTPUT_VARIABLE F2PY_INCLUDE_DIR
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(ext_dir "src/ncorpos_utilidades/ext")
set(f2py_module_dir "${ext_dir}/ncorpos_utilidades")
add_subdirectory(${f2py_module_dir} utilidades)
set(MOD_DIR ${utilidades_BINARY_DIR})

# Print out the discovered paths
include(CMakePrintHelpers)
cmake_print_variables(Python_INCLUDE_DIRS)
cmake_print_variables(F2PY_INCLUDE_DIR)
cmake_print_variables(Python_NumPy_INCLUDE_DIRS)

if (UNIX)
  set(F2PY_CMD ${Python_EXECUTABLE} -m "numpy.f2py")
else()
  set(F2PY_CMD ${Python_EXECUTABLE} -m "numpy.f2py" --fcompiler=gnu95 --compiler=mingw32)
endif()

# MODULO
set(F2PY_WRAPPER
  ${CMAKE_CURRENT_SOURCE_DIR}/src/ncorpos_utilidades/ext/ncorpos_utilidades.f90
)

set(F2PY_MODULE_NAME _core)
execute_process(
  COMMAND ${Python3_EXECUTABLE}
          -c
          "import sysconfig; print(sysconfig.get_config_var('EXT_SUFFIX'))"
  OUTPUT_VARIABLE PY_EXT_SUFFIX
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(F2PY_OUTPUT
  ${CMAKE_CURRENT_BINARY_DIR}/${F2PY_MODULE_NAME}${PY_EXT_SUFFIX}
)

add_custom_command(
  OUTPUT ${F2PY_OUTPUT}
  COMMAND
    ${Python3_EXECUTABLE} -m numpy.f2py
      -c
      -m ${F2PY_MODULE_NAME}
      ${F2PY_WRAPPER}

      --link-args=-Wl,-rpath,$ORIGIN
      --link-args=-lopenblas
      --link-args=-llapack
      -L$<TARGET_FILE_DIR:utilidades>
      -lutilidades
      -I${MOD_DIR}/mod
      --quiet
  DEPENDS
    utilidades
    ${F2PY_WRAPPER}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Gerando modulo Python via f2py com RPATH=$ORIGIN"
)


add_custom_target(python_module ALL
  DEPENDS ${F2PY_OUTPUT}
)

# Módulo Python gerado pelo f2py
install(
  FILES ${F2PY_OUTPUT}
  DESTINATION ncorpos_utilidades/_core
)

# Bibliotecas Fortran dependentes
install(
  TARGETS utilidades
  LIBRARY DESTINATION ncorpos_utilidades/_core
)

# Arquivos Python do pacote
install(
  DIRECTORY ${CMAKE_SOURCE_DIR}/src/ncorpos_utilidades/
  DESTINATION ncorpos_utilidades
  FILES_MATCHING
    PATTERN "*.py"
)