# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set (LIB_LUO980_DIR ${CMAKE_CURRENT_LIST_DIR})

add_definitions (-DWASM_ENABLE_LIB_LUO980=1)

include_directories(${LIB_LUO980_DIR})

file (GLOB source_all ${LIB_LUO980_DIR}/*.c)

set (LIB_LUO980_SOURCE ${source_all})

