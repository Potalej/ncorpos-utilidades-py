cmake_minimum_required(VERSION 3.25)
project(ncorpos_utilidades_py VERSION 0.0.1)

enable_language(Fortran)
find_package(Python3 REQUIRED COMPONENTS Interpreter)

add_subdirectory("src/ncorpos_utilidades/ext/ncorpos_utilidades" utilidades)
set(MOD_DIR ${utilidades_BINARY_DIR})
MESSAGE("MOD DIR: ${MOD_DIR}")

# Binding
set(F2PY_WRAPPER ${CMAKE_CURRENT_SOURCE_DIR}/src/ncorpos_utilidades/ext/ncorpos_utilidades.f90)
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

      -L$<TARGET_FILE_DIR:utilidades>
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

# ============================================================================
# INSTALL — ISSO É O QUE FALTAVA
# ============================================================================

# Módulo Python gerado pelo f2py
install(
  FILES ${F2PY_OUTPUT}
  DESTINATION ncorpos_vi/_core
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