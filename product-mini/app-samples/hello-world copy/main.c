/*
 * Copyright (C) 2019 Intel Corporation.  All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

#include <stdio.h>
#include <stdlib.h>
#include "./native/example.h"

int
main(int argc, char **argv)
{
    char *buf;

    printf("Hello world!\n");
    printf("Hello luo980!\n");

    buf = malloc(1024);
    if (!buf) {
        printf("malloc buf failed\n");
        return -1;
    }

    int u = foo(4, 5);
    printf("computer from native foo, result is %d\n", u);

    // char *src = "good";
    // char *dst = (char*)malloc(sizeof(src));

    // foo2(dst, src, sizeof(src));
    // printf("computer from native foo2, result is %s", dst);

    printf("buf ptr: %p\n", buf);

    snprintf(buf, 1024, "%s", "1234\n");
    printf("buf: %s", buf);

    free(buf);
    return 0;
}
