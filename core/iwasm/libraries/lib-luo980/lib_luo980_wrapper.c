#include "lib_luo980_wrapper.h"

int foo_native(wasm_exec_env_t exec_env , int a, int b)
{
  return a+b;
}
// void foo2(wasm_exec_env_t exec_env, char * msg, uint8 * buffer, int buf_len)
// {
//   strncpy(buffer, msg, buf_len);
// }