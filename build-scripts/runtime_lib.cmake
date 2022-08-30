# Copyright (C) 2019 Intel Corporation. All rights reserved.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

message("WAMR_ROOT_DIR is ${WAMR_ROOT_DIR}")
if (NOT DEFINED WAMR_ROOT_DIR)
    set (WAMR_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR}/../)
endif ()

message("SHARED_DIR is ${SHARED_DIR}")
if (NOT DEFINED SHARED_DIR)
    set (SHARED_DIR ${WAMR_ROOT_DIR}/core/shared)
endif ()

message("IWASM_DIR is ${IWASM_DIR}")
if (NOT DEFINED IWASM_DIR)
    set (IWASM_DIR ${WAMR_ROOT_DIR}/core/iwasm)
endif ()

message("APP_MGR_DIR is ${APP_MGR_DIR}")
if (NOT DEFINED APP_MGR_DIR)
    set (APP_MGR_DIR ${WAMR_ROOT_DIR}/core/app-mgr)
endif ()

message("APP_FRAMEWORK_DIR is ${APP_FRAMEWORK_DIR}")
if (NOT DEFINED APP_FRAMEWORK_DIR)
    set (APP_FRAMEWORK_DIR ${WAMR_ROOT_DIR}/core/app-framework)
endif ()

message("DEPS_DIR is ${DEPS_DIR}")
if (NOT DEFINED DEPS_DIR)
    set (DEPS_DIR ${WAMR_ROOT_DIR}/core/deps)
endif ()

message("EXTRA_SDK_INCLUDE_PATH is ${EXTRA_SDK_INCLUDE_PATH}")
if (DEFINED EXTRA_SDK_INCLUDE_PATH)
    message(STATUS, "EXTRA_SDK_INCLUDE_PATH = ${EXTRA_SDK_INCLUDE_PATH} ")
    include_directories (
        ${EXTRA_SDK_INCLUDE_PATH}
    )
endif ()

# Set default options

# Set WAMR_BUILD_TARGET, currently values supported:
# "X86_64", "AMD_64", "X86_32", "AARCH64[sub]", "ARM[sub]", "THUMB[sub]",
# "MIPS", "XTENSA", "RISCV64[sub]", "RISCV32[sub]"
message("WAMR_BUILD_TARGET is ${WAMR_BUILD_TARGET}")
if (NOT DEFINED WAMR_BUILD_TARGET)
    if (CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm64|aarch64)")
        set (WAMR_BUILD_TARGET "AARCH64")
    elseif (CMAKE_SYSTEM_PROCESSOR STREQUAL "riscv64")
        set (WAMR_BUILD_TARGET "RISCV64")
    elseif (CMAKE_SIZEOF_VOID_P EQUAL 8)
        # Build as X86_64 by default in 64-bit platform
        set (WAMR_BUILD_TARGET "X86_64")
    else ()
        # Build as X86_32 by default in 32-bit platform
        set (WAMR_BUILD_TARGET "X86_32")
    endif ()
endif ()

################ optional according to settings ################
message("WAMR_BUILD_INTERP is ${WAMR_BUILD_INTERP}, WAMR_BUILD_JIT is ${WAMR_BUILD_JIT}")
if (WAMR_BUILD_INTERP EQUAL 1 OR WAMR_BUILD_JIT EQUAL 1)
    include (${IWASM_DIR}/interpreter/iwasm_interp.cmake)
endif ()

message("WAMR_BUILD_AOT is ${WAMR_BUILD_AOT}")
if (WAMR_BUILD_AOT EQUAL 1)
    include (${IWASM_DIR}/aot/iwasm_aot.cmake)
    message("WAMR_BUILD_JIT is ${WAMR_BUILD_JIT}")
    if (WAMR_BUILD_JIT EQUAL 1)
        include (${IWASM_DIR}/compilation/iwasm_compl.cmake)
    endif ()
endif ()

message("WAMR_BUILD_APP_FRAMEWORK is ${WAMR_BUILD_APP_FRAMEWORK}")
if (WAMR_BUILD_APP_FRAMEWORK EQUAL 1)
    include (${APP_FRAMEWORK_DIR}/app_framework.cmake)
    include (${SHARED_DIR}/coap/lib_coap.cmake)
    include (${APP_MGR_DIR}/app-manager/app_mgr.cmake)
    include (${APP_MGR_DIR}/app-mgr-shared/app_mgr_shared.cmake)
endif ()

message("WAMR_BUILD_LIBC_BUILTIN is ${WAMR_BUILD_LIBC_BUILTIN}")
if (WAMR_BUILD_LIBC_BUILTIN EQUAL 1)
    include (${IWASM_DIR}/libraries/libc-builtin/libc_builtin.cmake)
endif ()

message("WAMR_BUILD_LIBC_UVWASI is ${WAMR_BUILD_LIBC_UVWASI}, WAMR_BUILD_LIBC_WASI is ${WAMR_BUILD_LIBC_WASI}")
if (WAMR_BUILD_LIBC_UVWASI EQUAL 1)
    include (${IWASM_DIR}/libraries/libc-uvwasi/libc_uvwasi.cmake)
elseif (WAMR_BUILD_LIBC_WASI EQUAL 1)
    include (${IWASM_DIR}/libraries/libc-wasi/libc_wasi.cmake)
endif ()

message("WAMR_BUILD_LIB_PTHREAD is ${WAMR_BUILD_LIB_PTHREAD}")
if (WAMR_BUILD_LIB_PTHREAD EQUAL 1)
    include (${IWASM_DIR}/libraries/lib-pthread/lib_pthread.cmake)
    # Enable the dependent feature if lib pthread is enabled
    set (WAMR_BUILD_THREAD_MGR 1)
    set (WAMR_BUILD_BULK_MEMORY 1)
    set (WAMR_BUILD_SHARED_MEMORY 1)
endif ()

message("WAMR_BUILD_DEBUG_INTERP is ${WAMR_BUILD_DEBUG_INTERP}")
if (WAMR_BUILD_DEBUG_INTERP EQUAL 1)
    set (WAMR_BUILD_THREAD_MGR 1)
    include (${IWASM_DIR}/libraries/debug-engine/debug_engine.cmake)

    message("WAMR_BUILD_FAST_INTERP is ${WAMR_BUILD_FAST_INTERP}")
    if (WAMR_BUILD_FAST_INTERP EQUAL 1)
        set (WAMR_BUILD_FAST_INTERP 0)
        message(STATUS
                "Debugger doesn't work with fast interpreter, switch to classic interpreter")
    endif ()
endif ()

message("WAMR_BUILD_THREAD_MGR is ${WAMR_BUILD_THREAD_MGR}")
if (WAMR_BUILD_THREAD_MGR EQUAL 1)
    include (${IWASM_DIR}/libraries/thread-mgr/thread_mgr.cmake)
endif ()

message("WAMR_BUILD_LIBC_EMCC is ${WAMR_BUILD_LIBC_EMCC}")
if (WAMR_BUILD_LIBC_EMCC EQUAL 1)
    include (${IWASM_DIR}/libraries/libc-emcc/libc_emcc.cmake)
endif ()

message("WAMR_BUILD_luo980 is ${WAMR_BUILD_luo980}")
if (WAMR_BUILD_luo980 EQUAL 1)
    include (${IWASM_DIR}/libraries/lib-luo980/lib_luo980.cmake)
endif ()

####################### Common sources #######################
if (NOT MSVC)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99 -ffunction-sections -fdata-sections \
                                         -Wall -Wno-unused-parameter -Wno-pedantic")
endif ()

# include the build config template file
include (${CMAKE_CURRENT_LIST_DIR}/config_common.cmake)

include_directories (${IWASM_DIR}/include)

file (GLOB header
    ${IWASM_DIR}/include/*.h
)
LIST (APPEND RUNTIME_LIB_HEADER_LIST ${header})

enable_language (ASM)

include (${SHARED_DIR}/platform/${WAMR_BUILD_PLATFORM}/shared_platform.cmake)
include (${SHARED_DIR}/mem-alloc/mem_alloc.cmake)
include (${IWASM_DIR}/common/iwasm_common.cmake)
include (${SHARED_DIR}/utils/shared_utils.cmake)


set (source_all
    ${PLATFORM_SHARED_SOURCE}
    ${MEM_ALLOC_SHARED_SOURCE}
    ${UTILS_SHARED_SOURCE}
    ${LIBC_BUILTIN_SOURCE}
    ${LIBC_WASI_SOURCE}
    ${IWASM_COMMON_SOURCE}
    ${IWASM_INTERP_SOURCE}
    ${IWASM_AOT_SOURCE}
    ${IWASM_COMPL_SOURCE}
    ${WASM_APP_LIB_SOURCE_ALL}
    ${NATIVE_INTERFACE_SOURCE}
    ${APP_MGR_SOURCE}
    ${LIB_PTHREAD_SOURCE}
    ${THREAD_MGR_SOURCE}
    ${LIBC_EMCC_SOURCE}
    ${DEBUG_ENGINE_SOURCE}
    ${LIB_LUO980_SOURCE}
)

set (WAMR_RUNTIME_LIB_SOURCE ${source_all})
message("WAMR_RUNTIME_LIB_SOURCE" is ${WAMR_RUNTIME_LIB_SOURCE})
