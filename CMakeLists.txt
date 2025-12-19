cmake_minimum_required(VERSION 3.25)
project(ncorpos_utilidades_py VERSION 0.0.1 LANGUAGES C Fortran)

# ---------------------------------------------------------------------------
# Python
# ---------------------------------------------------------------------------
find_package(Python3 REQUIRED COMPONENTS
  Interpreter
  Development.Module
  NumPy
)

add_subdirectory("src/ncorpos_utilidades/ext/ncorpos_utilidades" utilidades)
set(MOD_DIR ${utilidades_BINARY_DIR})
MESSAGE("MOD DIR: ${MOD_DIR}")

# ---------------------------------------------------------------------------
# f2py: gerar wrapper C (SEM -c)
# ---------------------------------------------------------------------------
set(F2PY_MODULE_NAME _core)

set(F2PY_WRAPPER_SRC
  ${CMAKE_CURRENT_SOURCE_DIR}/src/ncorpos_utilidades/ext/ncorpos_utilidades.f90
)

set(F2PY_C_WRAPPER
  ${CMAKE_CURRENT_BINARY_DIR}/${F2PY_MODULE_NAME}module.c
)

add_custom_command(
  OUTPUT ${F2PY_C_WRAPPER}
  COMMAND
    ${Python3_EXECUTABLE} -m numpy.f2py
      -m ${F2PY_MODULE_NAME}
      ${F2PY_WRAPPER_SRC}
      --lower
      --quiet
  DEPENDS
    ${F2PY_WRAPPER_SRC}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Gerando wrapper C via f2py"
)

add_custom_target(f2py_wrapper
  DEPENDS ${F2PY_C_WRAPPER}
)

# ---------------------------------------------------------------------------
# Extensão Python (ELF REAL)
# ---------------------------------------------------------------------------
Python3_add_library(${F2PY_MODULE_NAME} MODULE
  ${F2PY_C_WRAPPER}
)

add_dependencies(${F2PY_MODULE_NAME} f2py_wrapper)

execute_process(
  COMMAND ${Python3_EXECUTABLE}
          -c "import numpy.f2py, os; print(os.path.join(os.path.dirname(numpy.f2py.__file__), 'src'))"
  OUTPUT_VARIABLE F2PY_INCLUDE_DIR
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

target_include_directories(${F2PY_MODULE_NAME}
  PRIVATE
    ${MOD_DIR}
    ${F2PY_INCLUDE_DIR}
)

target_link_libraries(${F2PY_MODULE_NAME}
  PRIVATE
    utilidades
    Python3::NumPy
)

set_target_properties(${F2PY_MODULE_NAME} PROPERTIES
  PREFIX ""
  OUTPUT_NAME "${F2PY_MODULE_NAME}"
  INSTALL_RPATH "$ORIGIN"
)

# ---------------------------------------------------------------------------
# INSTALL (wheel-friendly)
# ---------------------------------------------------------------------------

# Extensão Python
install(
  TARGETS ${F2PY_MODULE_NAME}
  LIBRARY DESTINATION ncorpos_utilidades
)

# Biblioteca Fortran
install(
  TARGETS utilidades
  LIBRARY DESTINATION ncorpos_utilidades
)

# Arquivos Python
install(
  DIRECTORY ${CMAKE_SOURCE_DIR}/src/ncorpos_utilidades/
  DESTINATION ncorpos_utilidades
  FILES_MATCHING PATTERN "*.py"
)